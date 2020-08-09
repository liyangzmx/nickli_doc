#!/bin/bash

# libuse
USE_X264=1
USE_FDK_AAC=1

CLEAN_BEFORE=0

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

NDK=~/Android/Sdk/ndk/21.3.6528147
HOST_TAG=linux-x86_64
TOOLCHAINS=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
SYSROOT="${TOOLCHAINS}/sysroot"
API=23
ARCH="aarch64"
CROSS_PREFIX=$ARCH-linux-android
APP_ABI=arm64-v8a
CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
PREFIX=${PWD}/android-build/

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
    X264_VERSION=master
    X264_NAME=x264-${X264_VERSION}
    X264_DOWNLOAD_URL=https://code.videolan.org/videolan/x264/-/archive/master/${X264_NAME}.tar.bz2

    if [ ! -f ${X264_NAME}.tar.bz2 ]; then
        echo "Downloading ${X264_NAME}.tar.bz2"
        download ${X264_DOWNLOAD_URL}
    fi

    if [ ! -d ${X264_NAME} ]; then
        echo "Uncopressing ${X264_NAME}.tar.bz2 ..."
        tar xvf ${X264_NAME}.tar.bz2
    fi

    pushd ${X264_NAME}
    CC=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang ./configure \
        --enable-pic \
        --disable-asm \
        --enable-shared \
        --disable-opencl \
        --disable-cli \
        --host=${ARCH}-linux \
        --cross-prefix=${TOOLCHAINS}/bin/${CROSS_PREFIX}- \
        --sysroot=${SYSROOT} \
        --libdir=${PREFIX}/libs/${APP_ABI} \
        --includedir=${PREFIX}/include/

    if [ "X_${CLEAN_BEFORE}" == "X_1" ]; then
        make clean
    fi
    make -j${CORES}
    make install
    rm -rf ${PREFIX}/libs/${APP_ABI}/pkgconfig
    X264_SO_PATH=`readlink ${PREFIX}/libs/${APP_ABI}/libx264.so`
    rm  ${PREFIX}/libs/${APP_ABI}/libx264.so
    mv ${PREFIX}/libs/${APP_ABI}/${X264_SO_PATH} ${PREFIX}/libs/${APP_ABI}/libx264.so
    rm ${PREFIX}/libs/${APP_ABI}/${X264_SO_PATH}
    popd
}

build_fdk_aac()
{

    FDK_AAC_VERSION=2.0.1
    FDK_AAC_NAME=fdk-aac-${FDK_AAC_VERSION}
    FDK_AAC_DOWNLOAD_URL=https://downloads.sourceforge.net/opencore-amr/${FDK_AAC_NAME}.tar.gz

    if [ ! -f ${FDK_AAC_NAME}.tar.gz ]; then
        echo "Downloading ${FDK_AAC_NAME}.tar.gz"
        download ${FDK_AAC_DOWNLOAD_URL}
    fi

    if [ ! -d ${FDK_AAC_NAME} ]; then
        echo "Uncopressing ${FDK_AAC_NAME}.tar.gz ..."
        tar xvf ${FDK_AAC_NAME}.tar.gz
    fi
    
    pushd ${FDK_AAC_NAME}
    grep -q "#undef __ANDROID__" libSBRdec/src/lpp_tran.cpp
    if [ $? != 0 ]; then
        sed -i "N;120a#undef __ANDROID__" libSBRdec/src/lpp_tran.cpp
    fi

    CC=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang \
    CXX=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang++ \
    AR=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ar \
    AS=${TOOLCHAINS}/bin/${CROSS_PREFIX}-as \
    LD=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ld \
    NM=${TOOLCHAINS}/bin/${CROSS_PREFIX}-nm \
    RANLIB=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ranlib \
    STRIP=${TOOLCHAINS}/bin/${CROSS_PREFIX}-strip \
    ./configure \
        --prefix=${PREFIX} \
        --enable-shared \
        --host=aarch64-linux \
        --with-sysroot=${SYSROOT} \
        --libdir=${PREFIX}/libs/${APP_ABI} \
        --includedir=${PREFIX}/include/ \
        CPPFLAGS="-fPIC"

    if [ "X_${CLEAN_BEFORE}" == "X_1" ]; then
        make clean
    fi
	make -j${CORES}
	make install
    rm -rf ${PREFIX}/libs/${APP_ABI}/pkgconfig
    rm -rf ${PREFIX}/libs/${APP_ABI}/libfdk-aac.a
    rm -rf ${PREFIX}/libs/${APP_ABI}/libfdk-aac.la
    FDK_AAC_SO_PATH=`readlink ${PREFIX}/libs/${APP_ABI}/libfdk-aac.so`
    mv ${PREFIX}/libs/${APP_ABI}/${FDK_AAC_SO_PATH} ${PREFIX}/libs/${APP_ABI}/__${FDK_AAC_SO_PATH} 
    rm ${PREFIX}/libs/${APP_ABI}/libfdk-aac.so*
    mv ${PREFIX}/libs/${APP_ABI}/__${FDK_AAC_SO_PATH} ${PREFIX}/libs/${APP_ABI}/libfdk-aac.so
    popd
}

build_ffmpeg()
{
    EXTRA_OPTIONS=
    if [ "X_${USE_X264}" == "X_1" ]; then
        EXTRA_OPTIONS="${EXTRA_OPTIONS} --enable-gpl"
        EXTRA_OPTIONS="${EXTRA_OPTIONS} --enable-libx264"
        build_x264
    fi

    if [ "X_${USE_FDK_AAC}" == "X_1" ]; then
        EXTRA_OPTIONS="${EXTRA_OPTIONS} --enable-nonfree"
        EXTRA_OPTIONS="${EXTRA_OPTIONS} --enable-libfdk-aac"
        build_fdk_aac
    fi
    # FFmpeg build
    CONFIG_LOG_PATH=${PREFIX}/log
    PWD=`pwd`
    EXTRA_CFLAGS="-D__ANDROID_API__=${API} -Os -fPIC -DANDROID -I${PREFIX}/include/"
    EXTRA_LDFLAGS="-lc -lm -ldl -llog -L${PREFIX}/libs/$APP_ABI"
    echo "EXTRA_OPTIONS: ${EXTRA_OPTIONS}"
    echo "cc: ${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang"
    echo "PREFIX: ${PREFIX}"

    pushd ${FFMPEG_NAME}
    mkdir -p ${CONFIG_LOG_PATH}
    ./configure \
        --cc=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang \
        --cxx=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang++ \
        --nm=${TOOLCHAINS}/bin/${CROSS_PREFIX}-nm \
        --strip=${TOOLCHAINS}/bin/${CROSS_PREFIX}-strip \
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
        --sysroot="${SYSROOT}" \
        $EXTRA_OPTIONS \
        --extra-cflags="$EXTRA_CFLAGS" \
        --extra-ldflags="$EXTRA_LDFLAGS"

    if [ $? != 0 ]; then
        echo "ffmpeg configure error."
        exit 0
    fi
    if [ "X_${CLEAN_BEFORE}" == "X_1" ]; then
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