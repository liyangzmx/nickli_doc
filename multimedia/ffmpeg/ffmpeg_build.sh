#!/bin/bash

# libuse
USE_X264=1
USE_FDK_AAC=1
USE_OPENSSL=1

CLEAN_BEFORE=0
DOWNLOAD_DIR=dl/

download() {
    DOWNLOAD_URL=$1
    if [ ! -d ${DOWNLOAD_DIR} ]; then
        mkdir ${DOWNLOAD_DIR}
    fi
    pushd ${DOWNLOAD_DIR}
    proxychains wget ${DOWNLOAD_URL}
    popd
}

NDK=~/Android/Sdk/ndk/21.3.6528147
HOST_TAG=linux-x86_64
TOOLCHAINS=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
SYSROOT="${TOOLCHAINS}/sysroot"
API=23
ARCH="aarch64"
CROSS_PREFIX=$ARCH-linux-android
APP_ABI=arm64-v8a
CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
PREFIX=${PWD}/android-build

echo "Cleaning output..."
if [ -d android-build ]; then
    rm -fr ${PREFIX}
    sync
    mkdir ${PREFIX}
    mkdir -p ${PREFIX}/include
    mkdir -p ${PREFIX}/libs/arm64-v8a
fi

echo "TOOLCHAINS: ${TOOLCHAINS}"
echo "SYSROOT: ${SYSROOT}"
echo "ARCH: ${ARCH}"
echo "APP_ABI: ${APP_ABI}"
echo "API: ${API}"


build_x264() 
{
    echo "Build X264 ..."
    # wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2
    X264_VERSION=master
    X264_NAME=x264-${X264_VERSION}
    X264_DOWNLOAD_URL=https://code.videolan.org/videolan/x264/-/archive/master/${X264_NAME}.tar.bz2

    if [ ! -f ${DOWNLOAD_DIR}${X264_NAME}.tar.bz2 ]; then
        echo "Downloading ${X264_NAME}.tar.bz2"
        download ${X264_DOWNLOAD_URL}
    fi

    if [ ! -d ${X264_NAME} ]; then
        echo "Uncopressing ${X264_NAME}.tar.bz2 ..."
        tar xvf ${DOWNLOAD_DIR}${X264_NAME}.tar.bz2
    fi

    pushd ${X264_NAME}
    CC=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang ./configure \
        --enable-pic \
        --disable-asm \
        --enable-static \
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
    # X264_SO_PATH=`readlink ${PREFIX}/libs/${APP_ABI}/libx264.so`
    # rm ${PREFIX}/libs/${APP_ABI}/libx264.a
    # mv ${PREFIX}/libs/${APP_ABI}/${X264_SO_PATH} ${PREFIX}/libs/${APP_ABI}/libx264.a
    rm ${PREFIX}/libs/${APP_ABI}/libx264.so
    rm ${PREFIX}/libs/${APP_ABI}/${X264_SO_PATH}
    popd
}

build_fdk_aac()
{
    echo "Build Tiny FDK-AAC ..."
    FDK_AAC_VERSION=2.0.1
    FDK_AAC_NAME=fdk-aac-${FDK_AAC_VERSION}
    FDK_AAC_DOWNLOAD_URL=https://downloads.sourceforge.net/opencore-amr/${FDK_AAC_NAME}.tar.gz

    if [ ! -f ${DOWNLOAD_DIR}${FDK_AAC_NAME}.tar.gz ]; then
        echo "Downloading ${FDK_AAC_NAME}.tar.gz"
        download ${FDK_AAC_DOWNLOAD_URL}
    fi

    if [ ! -d ${FDK_AAC_NAME} ]; then
        echo "Uncopressing ${FDK_AAC_NAME}.tar.gz ..."
        tar xvf ${DOWNLOAD_DIR}${FDK_AAC_NAME}.tar.gz
    fi
    
    pushd ${FDK_AAC_NAME}
    grep -q "#undef __ANDROID__" libSBRdec/src/lpp_tran.cpp
    if [ $? != 0 ]; then
        sed -i "N;120a#undef __ANDROID__" libSBRdec/src/lpp_tran.cpp
    fi

    CC=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang; \
    CXX=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang++; \
    AR=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ar; \
    AS=${TOOLCHAINS}/bin/${CROSS_PREFIX}-as; \
    LD=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ld; \
    NM=${TOOLCHAINS}/bin/${CROSS_PREFIX}-nm; \
    RANLIB=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ranlib; \
    STRIP=${TOOLCHAINS}/bin/${CROSS_PREFIX}-strip; \
    ./configure \
        --prefix=${PREFIX} \
        --disable-shared \
        --enable-static \
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
    # rm -rf ${PREFIX}/libs/${APP_ABI}/pkgconfig
    rm -rf ${PREFIX}/libs/${APP_ABI}/libfdk-aac.so*
    rm -rf ${PREFIX}/libs/${APP_ABI}/libfdk-aac.la
    # rm -rf ${PREFIX}/libs/${APP_ABI}/libfdk-aac.a
    # rm -rf ${PREFIX}/libs/${APP_ABI}/libfdk-aac.la
    # FDK_AAC_SO_PATH=`readlink ${PREFIX}/libs/${APP_ABI}/libfdk-aac.so`
    # mv ${PREFIX}/libs/${APP_ABI}/${FDK_AAC_SO_PATH} ${PREFIX}/libs/${APP_ABI}/__${FDK_AAC_SO_PATH} 
    # rm ${PREFIX}/libs/${APP_ABI}/libfdk-aac.so*
    # mv ${PREFIX}/libs/${APP_ABI}/__${FDK_AAC_SO_PATH} ${PREFIX}/libs/${APP_ABI}/libfdk-aac.so
    # mv ${PREFIX}/libs/${APP_ABI}/libfdk-aac.a ${PREFIX}/libs/${APP_ABI}/libfdk_aac.a
    popd
}

build_openssl()
{
    OPENSSL_VERSION=1.1.1g
    OPENSSL_NAME=openssl-${OPENSSL_VERSION}
    OPENSSL_DOWNLOAD_URL=https://www.openssl.org/source/${OPENSSL_NAME}.tar.gz

    if [ ! -f ${DOWNLOAD_DIR}${OPENSSL_NAME}.tar.gz ]; then
        echo "Downloading ${OPENSSL_NAME}.tar.gz"
        download ${OPENSSL_DOWNLOAD_URL}
    fi

    if [ ! -d ${OPENSSL_NAME} ]; then
        echo "Uncopressing ${OPENSSL_NAME}.tar.gz ..."
        tar xvf ${DOWNLOAD_DIR}${OPENSSL_NAME}.tar.gz
    fi

    pushd ${OPENSSL_NAME}
    
    export ANDROID_NDK_HOME=${NDK}
    export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin:${PATH}
    ./Configure android-arm64 -D__ANDROID_API__=23 no-tests shared --prefix=${PREFIX}
    echo "PATH: ${PATH}"

    make -j8
    # install
    # cp libssl.so.1.1 ${PREFIX}/libs/${APP_ABI}/libssl.so
    # cp libcrypto.so.1.1 ${PREFIX}/libs/${APP_ABI}/libcrypto.so
    # cp libssl.so.1.1 ${PREFIX}/libs/${APP_ABI}/libssl.so
    # cp libcrypto.so.1.1 ${PREFIX}/libs${APP_ABI}/libcrypto.so
    cp libssl.a ${PREFIX}/libs/${APP_ABI}/libssl.a
    cp libcrypto.a ${PREFIX}/libs/${APP_ABI}/libcrypto.a
    cp -r include/* ${PREFIX}/include
    # make install
    
    popd
}

build_ffmpeg()
{
    echo "FFmpeg Build Start..."
    FFMPEG_VERSION=4.2.2
    FFMPEG_NAME=ffmpeg-${FFMPEG_VERSION}
    # http://ffmpeg.org/releases/ffmpeg-4.3.1.tar.bz2
    FFMPEG_OFFICIAL_SITE=http://ffmpeg.org/releases
    FFMPEG_DOWNLOAD_URL=$FFMPEG_OFFICIAL_SITE/${FFMPEG_NAME}.tar.bz2

    echo "${DOWNLOAD_DIR}${FFMPEG_NAME}.tar.bz2"

    echo "FFmpeg Version: ${FFMPEG_VERSION}"
    if [ ! -f ${DOWNLOAD_DIR}${FFMPEG_NAME}.tar.bz2 ]; then
        echo "Downloading ${FFMPEG_NAME}"
        download ${FFMPEG_DOWNLOAD_URL}
    fi

    if [ ! -d ${FFMPEG_NAME} ]; then
        echo "Uncopressing ${FFMPEG_NAME}.tar.gz ..."
        tar xvf ${DOWNLOAD_DIR}${FFMPEG_NAME}.tar.bz2
    fi
    echo "Build FFmpeg..."
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

    if [ "X_${USE_OPENSSL}" == "X_1" ]; then
        EXTRA_OPTIONS="${EXTRA_OPTIONS} --enable-openssl"
        build_openssl
    fi
    if [ "X_${USE_LIBRTMP}" == "X_1" ]; then
        EXTRA_OPTIONS="${EXTRA_OPTIONS} --enable-librtmp"
        build_librtmp
    fi
    # FFmpeg build
    CONFIG_LOG_PATH=${PREFIX}/
    PWD=`pwd`
    EXTRA_CFLAGS="-D__ANDROID_API__=${API} -Os -fPIC -DANDROID -I${PREFIX}/include/"
    EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -lc -lm -ldl -llog -L${PREFIX}/libs/${APP_ABI}"

    pushd ${FFMPEG_NAME}
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
        --prefix=${PREFIX} \
        --libdir=${PREFIX}/libs/${APP_ABI} \
        --incdir=${PREFIX}/include/ \
        --cross-prefix=$CROSS_PREFIX \
        --logfile=$CONFIG_LOG_PATH/config_${APP_ABI}.log \
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
    rm -r ${PREFIX}/share
    popd
}

build_tiny_ffmpeg()
{
    echo "Build Tiny FFmpeg..."
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
    EXTRA_LDFLAGS="-lc -lm -ldl -llog -L${PREFIX}/libs/${APP_ABI}"
    echo "EXTRA_OPTIONS: ${EXTRA_OPTIONS}"
    echo "cc: ${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang"
    echo "PREFIX: ${PREFIX}"

    pushd ${FFMPEG_NAME}
    ./configure \
        --cc=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang \
        --cxx=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang++ \
        --nm=${TOOLCHAINS}/bin/${CROSS_PREFIX}-nm \
        --strip=${TOOLCHAINS}/bin/${CROSS_PREFIX}-strip \
        --target-os=android \
        --enable-static \
        --disable-shared \
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
        --disable-filters \
        --disable-avformat \
        --disable-postproc \
        --logfile=$CONFIG_LOG_PATH/config_${APP_ABI}.log \
        --prefix=${PREFIX} \
        --libdir=${PREFIX}/libs/${APP_ABI} \
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
    rm -r ${PREFIX}/share
    popd
}

# No openssl
build_librtmp()
{
    # http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz
    LIBRTMP_VERSION=2.3
    LIBRTMP_NAME=rtmpdump-${LIBRTMP_VERSION}
    LIBRTMP_URL=http://rtmpdump.mplayerhq.hu/download/${LIBRTMP_NAME}.tgz

    if [ ! -f ${DOWNLOAD_DIR}${LIBRTMP_NAME}.tgz ]; then
        echo "Downloading ${LIBRTMP_NAME}.tgz"
        download ${LIBRTMP_URL}
    fi

    if [ ! -d ${LIBRTMP_NAME} ]; then
        echo "Uncopressing ${LIBRTMP_NAME}.tgz ..."
        tar xvf ${DOWNLOAD_DIR}${LIBRTMP_NAME}.tgz
    fi

    pushd ${LIBRTMP_NAME}
    # sed -i "s|gcc|$\(API\)\-clang|g" Makefile
    # sed -i "s|)ld|\)\-ld|g" Makefile

    make \
    PATH=$PATH:${TOOLCHAINS}/bin \
    CC=${TOOLCHAINS}/bin/${CROSS_PREFIX}${API}-clang \
    LD=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ld \
    AR=${TOOLCHAINS}/bin/${CROSS_PREFIX}-ar \
    XCFLAGS="-I${PREFIX}/include/ -isysroot ${TOOLCHAINS}/sysroot -isystem ${TOOLCHAINS}/sysroot/usr/include/${CROSS_PREFIX} -D__ANDROID_API__=${API}" \
    XLDFLAGS="-L${PREFIX}/libs/${APP_ABI}" \
    CRYPTO= \
    THREADLIB_posix= -j${CORES}

    cp librtmp/librtmp.so.0 ${PREFIX}/libs/${APP_ABI}/librtmp.so
    mkdir -p ${PREFIX}/include/librtmp/
    cp -rf librtmp/amf.h librtmp/http.h librtmp/log.h librtmp/rtmp.h ${PREFIX}/include/librtmp/

    popd
}

build_ffmpeg