# Pixel XL的驱动程序二进制文件
* 确定AOSP的分支
```
cd .repo/manifests
git rev-parse --abbrev-ref default@{upstream}
```
例如  
```
origin/android-10.0.0_r17
```
* 然后去如下网站  
[代号、标记和 Build 号](https://source.android.google.cn/setup/start/build-numbers?hl=zh-cn)  
确定对应的**Build Number**, 例如: **QP1A.191005.007.A3**  

* 然后去如下网站  
[Driver Binaries for Nexus and Pixel Devices
](https://developers.google.com/android/drivers/)  
根据你设备(例如: **Pixel XL**), 下载对应的驱动二进制文件, 例如:  
Pixel XL binaries for Android 10.0.0 (**QP1A.191005.007.A3**)  

* 会得到两个文件, 在你的AOSP源码目录下, 对你得到的包中的sh分别加权限
然后你的AOSP下会多出目录:  
```
$ ls vendor
google_devices qcom
```

* 接下来重新编译你的AOSP, 你将在你的out目录得到一个vendor.img, 例如:  
```
out/target/product/marlin/vendor.img
```

* 然后重新刷写固件:  
```
adb reboot bootloader
fastboot flashall -w
```