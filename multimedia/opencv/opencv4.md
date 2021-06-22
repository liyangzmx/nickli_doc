# OpenCV4 on Android

## 自己编译
### 脚本
代码:
```
#!/bin/bash

export ANDROID_SDK_ROOT=/home/${USER}/Android/Sdk
export ANDROID_PLATFORM=android-21

mkdir -p out
pushd out
# for java
# cmake -DBUILD_FAT_JAVA_LIB=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_TOOLCHAIN_FILE=${ANDROID_SDK_ROOT}/ndk/21.3.6528147/build/cmake/android.toolchain.cmake ..

# static only?
cmake \
	-DBUILD_FAT_JAVA_LIB=OFF \
	-DBUILD_ANDROID_PROJECTS=OFF \
	-DBUILD_ANDROID_EXAMPLES=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_PERF_TESTS=OFF \
	-DCMAKE_TOOLCHAIN_FILE=${ANDROID_SDK_ROOT}/ndk/21.3.6528147/build/cmake/android.toolchain.cmake \
	..

make -j$(nprocs)

popd
```

**备注**: 如果需要编译arm64-v8a的架构, 需要自己在cmake的参数指定:`-DADNROID_ABI=arm64-v8a`

生成安装:
```
cd out/
make install/
```

文件将安装到`out/install/`下, 需要拷贝的有:
`out/install/sdk/native/jni/include/` -> `<APP目录>/app/src/main/cpp/include/`  
`out/install/sdk/native/staticlibs/*` -> `<APP目录>/app/libs/`  
`out/install/sdk/native/3rdparty/libs/*` -> `<APP目录>/app/libs/`  

`CMakeList.txt`的配置:
```
include_directories(${CMAKE_SOURCE_DIR}/include/)
... ...
target_link_libraries( # Specifies the target library.
        <Your Target>

        # 直接写绝对路径就行
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_core.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/liblibpng.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/liblibtiff.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libade.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libcpufeatures.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/liblibjpeg-turbo.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libtegra_hal.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/liblibprotobuf.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libquirc.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/liblibwebp.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libittnotify.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libIlmImf.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/liblibopenjp2.a

        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_videoio.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_core.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_dnn.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_objdetect.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_video.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_highgui.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_flann.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_calib3d.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_gapi.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_features2d.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_imgcodecs.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_ml.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_stitching.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_photo.a
        ${CMAKE_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libopencv_imgproc.a



        # Links the target library to the log library
        # included in the NDK.
        ${log-lib}
)
... ...
```

ABI Filter设置, 文件`app/build.gradle`:
```
... ...
android {
    compileSdk 30
    buildToolsVersion "30.0.3"

    defaultConfig {
        ... ...
        externalNativeBuild {
            cmake {
                cppFlags ''
                // 添加下面这行
                abiFilters 'armeabi-v7a'
            }
        }
    }
    ... ...
}
... ...
```

代码引用:
```
... ...
#include <opencv2/opencv.hpp>
cv::Mat mat;

extern "C" JNIEXPORT jstring JNICALL
... ...
```

## 直接用官方的sdk
### SDK获取
主页: https://opencv.org/android/  
基本参考(不推荐): https://docs.opencv.org/2.4/doc/tutorials/introduction/android_binary_package/O4A_SDK.html

SDK下载页面: https://opencv.org/releases/  
选择"Android"即可, 一般会得到: `opencv-4.5.2-android-sdk.zip`.  
解压缩后得到: `OpenCV-android-sdk`

### Android Java
将`OpenCV-android-sdk`中的`sdk/`目录直接拷贝到工程目录下, 然后重命名为`opencv`(假设是这个名字).  
配置项目的`settings.gradle`文件, 添加:
```
include ':opencv'
```

配置项目的`build.gradle`文件, 修改并添加:
```
... ...
android {
    ... ...
    defaultConfig {
        ... ...
        // sdk的版本必须大于21
        minSdkVersion 21
        ... ...
    }
    ... ...
}
... ...
dependencies {
    implementation project(':opencv')
}
... ...
```

然后便可以在项目的java代码中正常的使用:
```
import org.opencv.imgproc.Imgproc;
```

### Android NDK Only
将`OpenCV-android-sdk`中的如下目录进行拷贝:  
`sdk/native/jni/include/` -> `<APP目录>/app/src/main/cpp/include/`  
`sdk/native/libs/*` -> `<APP目录>/app/libs/`  

然后配置`app/build.gradle`, 添加并修改:
```
... ...
android {
    ... ...
    defaultConfig {
        ... ...
        externalNativeBuild {
            ... ...
            cmake {
                ... ...
                arguments '-DANDROID_STL=c++_shared'
            }
            ... ...
        }
        ... ...
    }
    ... ...
}
```

然后配置`app/src/main/cpp/CMakeLists.txt`, 添加并修改:
```
... ...
// opencv4头文件路径
include_directories(include/)

// 导入opencv4的动态库
add_library(opencv_java SHARED IMPORTED)
set_target_properties(
        opencv_java
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libopencv_java4.so
)
... ...
target_link_libraries(
    ... ...
    opencv_java
    ... ...
)
```

然后可在项目中使用, 例如:
```
... ...
#include <opencv2/opencv.hpp>

cv::Mat mat;
... ...
```