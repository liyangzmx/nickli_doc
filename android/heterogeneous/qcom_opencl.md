# OpenCL with Qualcomm(玩儿砸了)

首先下载SDK  
[opencl-sdk-1.2.2.zip](https://developer.qualcomm.com/qfile/35497/opencl-sdk-1.2.2.zip)  

解压:
```
mkdir -p /opt/work/qcom_opencl-sdk-1.2.2/
cd /opt/work/qcom_opencl-sdk-1.2.2/
unzip ~/download/opencl-sdk-1.2.2.zip
```

准备内核头文件
```
cd /opt/work/qcom_opencl-sdk-1.2.2/
git clone --depth=1 https://android.googlesource.com/platform/hardware/qcom/msm8960
ls msm8960/original-kernel-headers/linux/msm_ion.h
```

下载专用的ndk, 需要到[不受支持的 NDK 下载](https://developer.android.com/ndk/downloads/older_releases), 需要同意条款, 才能下载, 这里我们选择[android-ndk-r11c-linux-x86_64.zip](https://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip?hl=zh_cn)
```
cd /opt/work/qcom_opencl-sdk-1.2.2/
axel -n 10 https://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip?hl=zh_cn
unzip android-ndk-r11c-linux-x86_64.zip

```

拉取[taka-no-me/android-cmake](https://github.com/taka-no-me/android-cmake)库:
```
cd /opt/work/qcom_opencl-sdk-1.2.2/opencl-sdk-1.2.2
git clone https://github.com/taka-no-me/android-cmake.git
```

设置环境变量, 执行脚本
```
export ANDROID_NDK=~/Android/Sdk/ndk/21.3.6528147/
export ANDROID_NATIVE_API_LEVEL=android-21
export ANDROID_TOOLCHAIN_NAME=aarch64-linux-android-clang
# export ANDROID_NDK=/opt/work/qcom_opencl-sdk-1.2.2/android-ndk-r11c
export OPEN_CL_LIB=`pwd`/libOpenCL.so
export ION_INCLUDE_PATH=`pwd`/../msm8960/original-kernel-headers/linux/
cd opencl-sdk-1.2.2/
chmod a+x build_android.sh
```