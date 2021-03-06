# FFmpeg in Android

## 源码
```
wget https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.xz
tar xvf ffmpeg-4.3.1.tar.xz
cd ffmpeg-4.3.1
```

编译(X264):
```
NDK_PATH=~/Android/Sdk/ndk/21.3.6528147/
HOST_PLATFORM_LINUX=linux-x86_64
HOST_PLATFORM=$HOST_PLATFORM_LINUX
API=23

TOOLCHAINS="$NDK_PATH/toolchains/llvm/prebuilt/$HOST_PLATFORM"
SYSROOT="$NDK_PATH/toolchains/llvm/prebuilt/$HOST_PLATFORM/sysroot"
CFLAG="-D__ANDROID_API__=$API -Os -fPIC -DANDROID "
LDFLAG="-lc -lm -ldl -llog "
PREFIX=android-build
CONFIG_LOG_PATH=${PREFIX}/log
ARCH="aarch64"
TARGET=$ARCH-linux-android
CC="$TOOLCHAINS/bin/$TARGET$API-clang"
CXX="$TOOLCHAINS/bin/$TARGET$API-clang++"
LD="$TOOLCHAINS/bin/$TARGET$API-clang"
CROSS_PREFIX="$TOOLCHAINS/bin/$TARGET-"
EXTRA_CFLAGS="$CFLAG"
EXTRA_LDFLAGS="$LDFLAG"
EXTRA_OPTIONS=""
APP_ABI=arm64-v8a

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
    --prefix=$PREFIX \
    --libdir=$PREFIX/libs/$APP_ABI \
    --incdir=$PREFIX/includes/$APP_ABI \
    --pkgconfigdir=$PREFIX/pkgconfig/$APP_ABI \
    --cross-prefix=$CROSS_PREFIX \
    --arch=$ARCH \
    --sysroot=$SYSROOT \
    --cc=$CC \
    --cxx=$CXX \
    --ld=$LD \
    $EXTRA_OPTIONS \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-ldflags="$EXTRA_LDFLAGS"

make -j8
make install
```

## 集成
拷贝库和头文件:
```
export APP_PROJECT_PATH=~/work/... .../
mkdir -p $APP_PROJECT_PATH/app/src/main/cpp/include/
mkdir -p $APP_PROJECT_PATH/app/libs/arm64-v8a/
cp -r android-build/includes/arm64-v8a/* $APP_PROJECT_PATH/app/src/main/cpp/include/
cp -r android-build/libs/arm64-v8a/* $APP_PROJECT_PATH/app/libs/arm64-v8a/
```

CMakeLists.txt添加:
```
add_library(avcodec SHARED IMPORTED)
set_target_properties(
        avcodec
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libavcodec.so
)

add_library(avdevice SHARED IMPORTED)
set_target_properties(
        avdevice
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libavdevice.so
)

add_library(avfilter SHARED IMPORTED)
set_target_properties(
        avfilter
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libavfilter.so
)

add_library(avformat SHARED IMPORTED)
set_target_properties(
        avformat
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libavformat.so
)

add_library(avutil SHARED IMPORTED)
set_target_properties(
        avutil
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libavutil.so
)

add_library(avresample SHARED IMPORTED)
set_target_properties(
        avresample
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libavresample.so
)

add_library(swresample SHARED IMPORTED)
set_target_properties(
        swresample
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libswresample.so
)

add_library(swscale SHARED IMPORTED)
set_target_properties(
        swscale
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libswscale.so
)

target_include_directories(native-lib PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include/)

target_link_libraries( # Specifies the target library.
    native-lib
    avutil
    avformat
    avcodec
    swscale
    swresample
    avfilter
    avresample
    avdevice


    # Links the target library to the log library
    # included in the NDK.
    ${log-lib}
)
```


检查并调整build.gradle(app):
```
android {
    ...
    defaultConfig {
        ...
        externalNativeBuild {
            cmake {
                cppFlags ""
            }
        }
        ndk {
            abiFilters 'arm64-v8a'
        }
    }
    sourceSets {
        main {
            jniLibs.srcDirs = ['libs/']
        }
    }
    externalNativeBuild {
        cmake {
            path "src/main/cpp/CMakeLists.txt"
            version "3.10.2"
        }
    }
}
...
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    ...
}
```

检查**System.loadLibrary**():
```
static {
        System.loadLibrary("avutil");
        System.loadLibrary("swresample");
        System.loadLibrary("avformat");
        System.loadLibrary("avcodec");
        System.loadLibrary("swscale");
        System.loadLibrary("avfilter");
        System.loadLibrary("avresample");
        System.loadLibrary("avdevice");
}
```
**注意:** 特别注意上述库的**加载顺序!!!**


关于`iconv_close`符号的问题
```
2020-10-13 10:25:23.369 18707-18707/? E/AndroidRuntime: FATAL EXCEPTION: main
    Process: com.wyze.wyzevideodownloader, PID: 18707
    java.lang.UnsatisfiedLinkError: dlopen failed: cannot locate symbol "iconv_close" referenced by "/data/app/... .../base.apk!/lib/arm64-v8a/libavformat.so"...
        at java.lang.Runtime.loadLibrary0(Runtime.java:1016)
        at java.lang.System.loadLibrary(System.java:1657)
```
编译时API的版本太高了, 比如29, 改成21即可.