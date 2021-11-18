# Filament on Ubuntu

## 参考
* Github: http://github.com/google/filament  
* Release: https://github.com/google/filament/releases  
* 官方文档: https://google.github.io/filament/Filament.html  
* 中文翻译: https://jerkwin.github.io/filamentcn/Filament.md.html  
* 源码编译手册: https://github.com/google/filament/blob/main/BUILDING.md  

## Ubuntu 编译
### CMake版本

写本文时, filament官方代码`master`分支要求CMake版本在`3.19`以上.
CMake官方下载地址: https://cmake.org/download/
根据实际的情况下载对应的版本, 本人使用Ubuntu, 因此下载的是linux_x86_64版本:`cmake-3.22.0-rc1-linux-x86_64.sh`  
安装最新版本CMake:
```
$ chmod a+x ~/Downloads/cmake-3.22.0-rc1-linux-x86_64.sh
$ cd /usr/
$ sudo ~/Downloads/cmake-3.22.0-rc1-linux-x86_64.sh   (先'y'后'n'即可)
$ cmake --version 
cmake version 3.22.0-rc1

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

### 编译前的准备
参考`build/linux/ci-common.sh`脚本:
```
$ sudo apt-get install clang-8 libc++-8-dev libc++abi-8-dev
$ sudo apt-get install mesa-common-dev libxi-dev libxxf86vm-dev
$ sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang-8 100
$ sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-8 100
```

REF: [Build Error #3071](https://github.com/google/filament/issues/3071)

### 编译
```
$ ./build.sh -p desktop debug
```

### Vulkan SDK
Filament Demo的运行需要Vulkan的支持, 前往[Vulkan - SDK Home](https://vulkan.lunarg.com/sdk/home)下载Linux版本SDK(本例`vulkansdk-linux-x86_64-1.2.189.0.tar.gz`)
```
$ cd ~/work/
$ mkdir VulkanSDK
$ cd VulkanSDK/
$ tar xvf ~/Downloads/vulkansdk-linux-x86_64-1.2.189.0.tar.gz
$ cd ~/work/filament
$ source ~/work/VulkanSDK/1.2.189.0/setup-env.sh
```

### 关于Vulkan驱动
参考: 
* [Vulkan GPU Resources](https://www.vulkan.org/tools#vulkan-gpu-resources)  
<!-- * [How to Find Graphics Drivers for Linux*](https://www.intel.com/content/www/us/en/support/articles/000005520/graphics.html)

查看显卡驱动:
```
$ lspci -k | grep -EA3 'VGA|3D|Display'
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor Integrated Graphics Controller (rev 06)
	Subsystem: Dell Xeon E3-1200 v3/4th Gen Core Processor Integrated Graphics Controller
	Kernel driver in use: i915
	Kernel modules: i915
``` -->

### 安装Vulkan驱动
```
$ sudo apt install mesa-vulkan-drivers
```

### 运行Demo
```
$ ./out/cmake-debug/samples/hellopbr 
FEngine (64 bits) created at 0x3b51e30 (threading is enabled)
FEnginetr
运行报错是因为HD 4600集成显卡不支持Vulkan, 参考: [Vulkan support for Intel HD 4600 on I7-4790](https://community.intel.com/t5/Graphics/Vulkan-support-for-Intel-HD-4600-on-I7-4790/td-p/1205436)

解决办法: 使用`-DFILAMENT_SUPPORTS_VULKAN=OFF`禁用Vulkan的支持.
修改如下:
```
diff --git a/build.sh b/build.sh
index 45b3cf1..1f812fb 100755
--- a/build.sh
+++ b/build.sh
@@ -150,7 +150,7 @@ RUN_TESTS=false
 
 INSTALL_COMMAND=
 
-VULKAN_ANDROID_OPTION="-DFILAMENT_SUPPORTS_VULKAN=ON"
+VULKAN_ANDROID_OPTION="-DFILAMENT_SUPPORTS_VULKAN=OFF"
 VULKAN_ANDROID_GRADLE_OPTION=""
 
 SWIFTSHADER_OPTION="-DFILAMENT_USE_SWIFTSHADER=OFF"
@@ -212,6 +212,7 @@ function build_desktop_target {
             -G "${BUILD_GENERATOR}" \
             -DIMPORT_EXECUTABLES_DIR=out \
             -DCMAKE_BUILD_TYPE="$1" \
+           -DFILAMENT_SUPPORTS_VULKAN=OFF \
             -DCMAKE_INSTALL_PREFIX="../${lc_target}/filament" \
             ${SWIFTSHADER_OPTION} \
             ${MATDBG_OPTION} \
```

重新编译并运行:
```
$ ./build.sh -p desktop debug
$ ./out/cmake-debug/samples/hellopbr
```