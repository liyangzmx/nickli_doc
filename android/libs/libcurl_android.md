# libcurl(7.71.1) for Android

## 官方链接
[https://curl.haxx.se/libcurl/](https://curl.haxx.se/libcurl/)

## 源码
下载源码:
```
wget https://curl.haxx.se/download/curl-7.71.1.tar.gz
tar xvf curl-7.71.1.tar.gz
cd curl-7.71.1
```

设置环境变量():
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
```

配置:
```
./configure --host aarch64-linux-android --with-ssl="$OPENSSL_INSTALL_PATH" --prefix=`pwd`/install/
```
<!-- 
./configure --host aarch64-linux-android --with-ssl="/opt/work/ssl_android/openssl-1.1.1g/install" --prefix=`pwd`/install/ 
-->
注意: **$OPENSSL_INSTALL_PATH** 为OpenSSL的路径(由NDKbuild)  
关于OpenSSL的编译, 参考: [OpenSSL in Android](openssl_android.md)  

编译:
```
make
make install
```

## 集成到APK
拷贝文件:
```
cp install/lib/libcurl.so  $APP_PROJECT_PATH/app/libs/arm64-v8a/
cp -rf install/include/ $APP_PROJECT_PATH/app/src/main/cpp/
```

添加如下内容到CMakeLists.txt(它通常在: **app/src/main/cpp/CMakeLists.txt**):
```
add_library(curl_lib SHARED IMPORTED)
set_target_properties(
        curl_lib
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libcurl.so
)
include_directories(${CMAKE_CURRENT_LIST_DIR}/include/)
... ...
target_link_libraries( 
    native-lib
    ... ...
    curl_lib
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
    System.loadLibrary("crypto");
    System.loadLibrary("ssl");
    System.loadLibrary("curl)
    System.loadLibrary("native-lib");
}
```
**注意:** 特别注意上述库的**加载顺序!!!**

## 运行报错
Log如下:
```
java.lang.UnsatisfiedLinkError: dlopen failed: cannot locate symbol "fread_unlocked" referenced by "/data/app/com.wyze.libcurljni-vQUM_YoM3Mz5BEEB7kl8HA==/lib/arm64/libcurl.so"...
        at java.lang.Runtime.loadLibrary0(Runtime.java:1016)
        at java.lang.System.loadLibrary(System.java:1657)
        at com.wyze.libcurljni.MainActivity.<clinit>(MainActivity.java:14)
        at java.lang.Class.newInstance(Native Method)
        at android.app.Instrumentation.newActivity(Instrumentation.java:1174)
        at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:2669)
        at android.app.ActivityThread.handleLaunchActivity(ActivityThread.java:2856)
        at android.app.ActivityThread.-wrap11(Unknown Source:0)
        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:1589)
        at android.os.Handler.dispatchMessage(Handler.java:106)
        at android.os.Looper.loop(Looper.java:164)
        at android.app.ActivityThread.main(ActivityThread.java:6494)
        at java.lang.reflect.Method.invoke(Native Method)
        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:438)
        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:807)
```
**暂时无解**