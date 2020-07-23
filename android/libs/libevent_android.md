# Libevent in Android

官网:[https://libevent.org/](https://libevent.org/)

## 源码下载
```
wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
tar xvf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
```

设置环境变量:
```
export NDK=~/Android/Sdk/ndk/21.3.6528147/
export HOST_TAG=linux-x86_64
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
export AR=$TOOLCHAIN/bin/aarch64-linux-android-ar
export AS=$TOOLCHAIN/bin/aarch64-linux-android-as
export CC=$TOOLCHAIN/bin/aarch64-linux-android23-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android23-clang++
export LD=$TOOLCHAIN/bin/aarch64-linux-android-ld
export RANLIB=$TOOLCHAIN/bin/aarch64-linux-android-ranlib
export STRIP=$TOOLCHAIN/bin/aarch64-linux-android-strip
export LDFLAGS=-L/opt/work/ssl_android/openssl-1.1.1g/install/lib/
export CFLAGS=-I/opt/work/ssl_android/openssl-1.1.1g/install/include/
```

为了不生成类似**libevent-2.1.so**类似的命名, 修改**Makefile.in**:
```
RELEASE = -release 2.1
```
为:
```
RELEASE =
```

配置&编译:
```
./configure --disable-thread-support --host aarch64-linux-android --prefix=`pwd`/install/
make & make install
```

## 集成到APK
拷贝文件:
```
cp install/lib/libevent_core.so  $APP_PROJECT_PATH/app/libs/arm64-v8a/
cp install/lib/libevent.so  $APP_PROJECT_PATH/app/libs/arm64-v8a/
cp -rf install/include/ $APP_PROJECT_PATH/app/src/main/cpp/
```

添加如下内容到CMakeLists.txt(它通常在: **app/src/main/cpp/CMakeLists.txt**):
```
add_library(event_lib SHARED IMPORTED)
set_target_properties(
        event_lib
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libevent.so
)
add_library(event_core_lib SHARED IMPORTED)
set_target_properties(
        event_core_lib
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libevent_core.so
)

include_directories(${CMAKE_CURRENT_LIST_DIR}/include/)
... ...
target_link_libraries( 
    native-lib
    ... ...
    event_lib
    event_core_lib
    ... ...
)
```
检查并调整build.gradle(**app**):
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
    System.loadLibrary("event_core");
    System.loadLibrary("event");
    System.loadLibrary("native-lib");
}
```