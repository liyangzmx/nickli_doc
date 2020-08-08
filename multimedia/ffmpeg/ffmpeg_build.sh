#!/bin/bash

# libuse
USE_X264=1

CLEAN_BEFORE=1

echo "FFmpeg Build Start..."
FFMPEG_VERSION=4.2.2
FFMPEG_NAME=ffmpeg-${FFMPEG_VERSION}
# http://ffmpeg.org/releases/ffmpeg-4.3.1.tar.bz2
FFMPEG_OFFICIAL_SITE=http://ffmpeg.org/releases
FFMPEG_DOWNLOAD_URL=$FFMPEG_OFFICIAL_SITE/${FFMPEG_NAME}.tar.bz2

download() {
    DOWNLOAD_URL=$1
    proxychains wget ${DOWNLOAD_URL}
}

echo "FFmpeg Version: ${FFMPEG_VERSION}"
if [ ! -f ${FFMPEG_NAME}.tar.bz2 ]; then
    echo "Downloading ${FFMPEG_NAME}"
    download FFMPEG_DOWNLOAD_URL
fi

if [ ! -d ${FFMPEG_NAME} ]; then
    echo "Uncopressing ${FFMPEG_NAME}.tar.gz ..."
    tar xvf ${FFMPEG_NAME}.tar.bz2
fi

export NDK=~/Android/Sdk/ndk/21.3.6528147
export HOST_TAG=linux-x86_64
export TOOLCHAINS=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
export SYSROOT="${TOOLCHAINS}/sysroot"
export API=23
export ARCH="aarch64"
export TARGET=$ARCH-linux-android
export APP_ABI=arm64-v8a
export CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
export PREFIX=${PWD}/android-build/

echo "TOOLCHAINS: ${TOOLCHAINS}"
echo "SYSROOT: ${SYSROOT}"
echo "ARCH: ${ARCH}"
echo "APP_ABI: ${APP_ABI}"
echo "API: ${API}"

echo "Cleaning output..."
if [ -d android-build ]; then
    rm -fr android-build
fi

build_x264() 
{
    # wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2
    export X264_VERSION=master
    export X264_NAME=x264-${X264_VERSION}
    export X264_DOWNLOAD_URL=https://code.videolan.org/videolan/x264/-/archive/master/${X264_NAME}.tar.bz2

    if [ ! -f ${X264_NAME}.tar.bz2 ]; then
        echo "Downloading ${X264_NAME}.tar.bz2"
        download ${X264_DOWNLOAD_URL}
    fi

    if [ ! -d ${X264_NAME} ]; then
        echo "Uncopressing ${X264_NAME}.tar.bz2 ..."
        tar xvf ${X264_NAME}.tar.bz2
    fi

    pushd ${X264_NAME}
    export CC=$TOOLCHAINS/bin/${TARGET}${API}-clang
    export CXX=$TOOLCHAINS/bin/${TARGET}${API}-clang++
    export CROSS_PREFIX=$TOOLCHAINS/bin/${TARGET}-
    echo "CC: ${CC}"
    echo "CXX: ${CXX}"
    echo "CROSS_PREFIX: ${CROSS_PREFIX}"
    ./configure \
        --enable-pic \
        --disable-asm \
        --enable-shared \
        --disable-opencl \
        --disable-cli \
        --host=${ARCH}-linux \
        --cross-prefix=${CROSS_PREFIX} \
        --sysroot=${SYSROOT} \
        --libdir=${PREFIX}/libs/${APP_ABI} \
        --includedir=${PREFIX}/include/

    if [ "X_${CLEAN_BEFORE}" != "X_" ]; then
        make clean
    fi
    make -j${CORES}
    make install
    rm -rf ${PREFIX}/libs/${APP_ABI}/pkgconfig
    export X264_SO_PATH=`readlink ${PREFIX}/libs/${APP_ABI}/libx264.so`
    rm  ${PREFIX}/libs/${APP_ABI}/libx264.so
    mv ${PREFIX}/libs/${APP_ABI}/${X264_SO_PATH} ${PREFIX}/libs/${APP_ABI}/libx264.so
    rm ${PREFIX}/libs/${APP_ABI}/${X264_SO_PATH}
    popd
}

build_ffmpeg()
{
    if [ "X_${USE_X264}" != "X_" ]; then
        EXTRA_OPTIONS += "--enable-gpl"
        EXTRA_OPTIONS += "--enable-libx264"
        build_x264
    fi

    # FFmpeg build
    export CONFIG_LOG_PATH=${PREFIX}/log
    export PWD=`pwd`

    export CC="$TOOLCHAINS/bin/$TARGET$API-clang"
    export CXX="$TOOLCHAINS/bin/$TARGET$API-clang++"
    export CROSS_PREFIX="$TOOLCHAINS/bin/$TARGET-"
    # export LD="${CROSS_PREFIX}ld"
    export STRIP="${CROSS_PREFIX}strip"
    export EXTRA_CFLAGS="-D__ANDROID_API__=$API -Os -fPIC -DANDROID"
    export EXTRA_LDFLAGS="-lc -lm -ldl -llog"
    export EXTRA_OPTIONS=""
    echo "CC: ${CC}"
    echo "CXX: ${CXX}"
    # echo "LD: ${LD}"
    echo "CROSS_PREFIX: ${CROSS_PREFIX}"
    echo "PREFIX: ${PREFIX}"

    pushd ${FFMPEG_NAME}

    mkdir -p ${CONFIG_LOG_PATH}
    ./configure \
        --target-os=android \
        --disable-static \
        --enable-shared \
        --enable-protocols \
        --enable-cross-compile \
        --enable-optimizations \
        --enable-debug=3 \
        --enable-small \
        --disable-doc \
        --disable-programs \
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-symver \
        --disable-network \
        --disable-x86asm \
        --disable-iconv \
        --disable-asm \
        --enable-pthreads \
        --enable-mediacodec \
        --enable-jni \
        --enable-zlib \
        --enable-pic \
        --enable-avresample \
        --enable-decoder=h264 \
        --enable-decoder=mpeg4 \
        --enable-decoder=mjpeg \
        --enable-decoder=png \
        --enable-decoder=vorbis \
        --enable-decoder=opus \
        --enable-decoder=flac \
        --logfile=$CONFIG_LOG_PATH/config_$APP_ABI.log \
        --prefix=${PREFIX} \
        --libdir=${PREFIX}/libs/$APP_ABI \
        --incdir=${PREFIX}/include/ \
        --cross-prefix=$CROSS_PREFIX \
        --arch=$ARCH \
        --sysroot=$SYSROOT \
        --cc=$CC \
        --cxx=$CXX \
        --ld=$LD \
        --strip=${STRIP} \
        $EXTRA_OPTIONS \
        --extra-cflags="$EXTRA_CFLAGS" \
        --extra-ldflags="$EXTRA_LDFLAGS"

    if [ "X_${CLEAN_BEFORE}" != "X_" ]; then
        make clean
    fi
    make -j${CORES}
    make install
    rm -r ${PREFIX}/libs/${APP_ABI}/pkgconfig
    rm -r ${PREFIX}/log
    rm -r ${PREFIX}/share
    popd
}

build_ffmpeg