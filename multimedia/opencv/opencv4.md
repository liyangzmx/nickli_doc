# OpenCV4 on Android

## SDK获取
主页: https://opencv.org/android/  
基本参考(不推荐): https://docs.opencv.org/2.4/doc/tutorials/introduction/android_binary_package/O4A_SDK.html

SDK下载页面: https://opencv.org/releases/  
选择"Android"即可, 一般会得到: `opencv-4.5.2-android-sdk.zip`.  
解压缩后得到: `OpenCV-android-sdk`

## Android Java
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

## Android NDK Only
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