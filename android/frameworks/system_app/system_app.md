# Android Studio开发系统应用(尝试)

## 参考资料
关于Android.bp, 建议参考`$OUT_DIR/soong/docs/`下的文档
* 对于Android.bp的`android_app`参考: `$OUT_DIR/soong/docs/soong_build.html`
* 对于Android.bp的`cc_prebuilt_library_shared`参考:`$OUT_DIR/soong/docs/cc.html`

## 没有第三方库的情况
使用Android Studio建立一个项目, 假设名字: `YourSystemApp`, 目录存放在`packages/apps/YourSystemApp`目录, 然后编写`packages/apps/YourSystemApp/Android.bp`:
```
android_app {
    name: "YourSystemApp", 
    min_sdk_version: "23", 
    sdk_version: "current",
    srcs: [
        "app/src/main/java/**/*.java"
    ], 
    resource_dirs: [
        "app/src/main/res", 
    ], 
    manifest: "app/src/main/AndroidManifest.xml", 
    platform_apis: true,
    certificate: "platform",
    privileged: true,
    dex_preopt: {
        enabled: false, 
    }, 
    optimize: {
        enabled: false, 
    }, 
    static_libs: [
        "androidx.appcompat_appcompat", 
        "androidx-constraintlayout_constraintlayout",
    ], 
}
```

使用如下脚本(建议路径: `aosp/gen_key/gen_key.sh`)生成`platform.keystore`:
```
#!/bin/bash

export ANDROID_ROOT=`pwd`/../
openssl pkcs8 -inform DER -nocrypt -in \
  $ANDROID_ROOT/build/target/product/security/platform.pk8 -out platform.key
openssl pkcs12 -export -in \
  $ANDROID_ROOT/build/target/product/security/platform.x509.pem -inkey \
  platform.key -name platform -out platform.pem -password pass:password
keytool -importkeystore -destkeystore platform.keystore -deststorepass \
  password -srckeystore platform.pem -srcstoretype PKCS12 -srcstorepass password
```

然后配置gradle:
```
android {
    signingConfigs {
        debug {
            storeFile file('platform.keystore')
            storePassword 'password'
            keyAlias 'platform'
            keyPassword 'password'
        }
        release {
            storeFile file('platform.keystore')
            storePassword 'password'
            keyAlias 'platform'
            keyPassword 'pass:password'
        }
    }

    buildTypes {
        debug {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        release {
            minifyEnabled false
            // 这里特别的坑, 对于release, 必须显示说明
            signingConfig signingConfigs.release
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

修改App的`AndroidManifest.xml`文件:
```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.yoursystemapp"
    // 下面一行是新增的
    android:sharedUserId="android.uid.system">

    <application
        ... ...
    </application>

</manifest>
```

### Android Studio编译
`Build Variant`选择`release`, 最终生成的release版的apk在如下目录:  
`app/build/outputs/apk/release/app-release.apk`

### AOSP编译
执行:  
`mmm packages/apps/YourSystemApp/`  
最终生成的apk(debug)版在:  
`$OUT_DIR/target/product/marlin/system/priv-app/YourSystemApp/YourSystemApp.apk`

### 备注
对于使用系统API的情况, 以`UpdateEngine`为例子, 编译`Android 10`源码, 然后拷贝:  
`$OUT_DIR/soong/.intermediates/development/build/android_system_stubs_current/android_common/combined/android_system_stubs_current.jar`  
到  
`packages/apps/YourSystemApp/app/libs/`  
目录下.


## 有第三方库的情况
Java部分同上文

### Android Studio
`build.gradle`检查
```
android {
    ... ...
    externalNativeBuild {
        cmake {
            path "src/main/cpp/CMakeLists.txt"
            version "3.10.2"
        }
    }
    sourceSets {
        main {
            jniLibs.srcDirs = ['libs/']
            jni.srcDirs = [] //disable automatic ndk-build call
        }
    }
    packagingOptions {
        pickFirst '**/*.so'
    }
}
... ...
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    ... ...
}
```

对库进行检查:
```
$ tree app/libs/
app/libs/
├── android_system_stubs_current.jar
├── arm64-v8a
│   ├── libavcodec.so
│   ├── libavdevice.so
│   ├── libavfilter.so
│   ├── libavformat.so
│   ├── libavresample.so
│   ├── libavutil.so
│   ├── libswresample.so
│   ├── libswscale.so
│   └── libx264.so
└── armeabi-v7a
    ├── libavcodec.so
    ├── libavdevice.so
    ├── libavfilter.so
    ├── libavformat.so
    ├── libavresample.so
    ├── libavutil.so
    ├── libswresample.so
    └── libswscale.so
```

修改`CMakeLists.txt`:
```
cmake_minimum_required(VERSION 3.4.1)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")

find_library( 
              log-lib
              log )

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

include_directories(${CMAKE_CURRENT_LIST_DIR}/include/)

add_library(native-ffmpeg-decoder
        SHARED
        ffmpeg-decoder.cpp
        )

target_link_libraries(
        native-ffmpeg-decoder
        avutil
        avformat
        avcodec
        swscale
        swresample
        avfilter
        avresample
        avdevice
        android
        ${log-lib}
)
```

`Android.bp`修改
```
cc_prebuilt_library_shared {
    name: "libavutil",
    double_loadable: true,
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libavutil.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libavutil.so"],
        }
    }, 
    strip: {
        none:true,
    },
}

cc_prebuilt_library_shared {
    name: "libavcodec",
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libavcodec.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libavcodec.so"],
        }
    }, 
    strip: {
        none:true,
    },
}

cc_prebuilt_library_shared {
    name: "libavdevice",
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libavdevice.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libavdevice.so"],
        }
    }, 
    strip: {
        none:true,
    },
}

cc_prebuilt_library_shared {
    name: "libavfilter",
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libavfilter.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libavfilter.so"],
        }
    }, 
    strip: {
        none:true,
    },
}

cc_prebuilt_library_shared {
    name: "libswresample",
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libswresample.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libswresample.so"],
        }
    }
}

cc_prebuilt_library_shared {
    name: "libswscale",
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libswscale.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libswscale.so"],
        }
    }, 
    strip: {
        none:true,
    },
}

cc_prebuilt_library_shared {
    name: "libavformat",
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libavformat.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libavformat.so"],
        }
    }, 
    strip: {
        none:true,
    },
}

cc_prebuilt_library_shared {
    name: "libavresample",
    target: {
        android_arm64: {
            srcs: ["app/libs/arm64-v8a/libavresample.so"],
        }, 
        android_arm: {
            srcs: ["app/libs/armeabi-v7a/libavresample.so"],
        }
    }, 
    strip: {
        none:true,
    },
}

cc_library_shared {
    name: "libffmpegdecoder", 
    cflags: [
        "-Werror",
        "-Wno-error=unused-parameter",
    ],
    product_specific: true,
    shared_libs: [
        "liblog",
        "libavutil", 
        "libavcodec", 
        "libavdevice", 
        "libavfilter", 
        "libswresample", 
        "libswscale", 
        "libavformat", 
        "libavresample", 
    ],
}

android_app {
    name: "YourSystemApp", 
    min_sdk_version: "23", 
    sdk_version: "system_current",
    srcs: [
        "app/src/main/java/**/*.java"
    ], 
    resource_dirs: [
        "app/src/main/res", 
    ], 

    jni_libs: [
        "libffmpegdecoder", 
    ], 
    manifest: "app/src/main/AndroidManifest.xml", 
    platform_apis: true,
    certificate: "platform",
    dex_preopt: {
        enabled: false, 
    }, 
    optimize: {
        enabled: false, 
    }, 
    static_libs: [
        "androidx.appcompat_appcompat", 
        "androidx-constraintlayout_constraintlayout",
    ], 
}
```

为了可以让app访问/system/lib64/下对应的库, 修改 `system/core/rootdir/etc/public.libraries.android.txt`:
```
... ...
libz.so

// 以下是添加的部分
libnativeloader.so
libavutil.so
libavcodec.so
libavdevice.so
libavfilter.so
libswscale.so
libavformat.so
libavresample.so
libswresample.so
```

编译同上.