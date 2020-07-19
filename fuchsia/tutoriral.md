# Hikey960 开发板 Fuchsia 编译
## 前提
* 源码路径: /opt/work/fuchsia/  
* 操作系统: Ubuntu 18.04.3 X64

## 版本
我使用的是离线下载的Fuchsia 2020.04.07版本, 地址请见下文.

## 源码下载
参考官方教程: [https://fuchsia.dev/docs/development/source_code/README](https://fuchsia.dev/docs/development/source_code/README)  

## 安装依赖
```
sudo apt-get install build-essential curl git python unzip
cd ~
```

引导脚本(此命令开始后将启动代码下载流程)
```
curl -s "https://fuchsia.googlesource.com/fuchsia/+/master/scripts/bootstrap?format=TEXT" | base64 --decode | bash
```

PS:不幸的是, 国内网速不好, 我使用的是镜像:
[fuchsia-source-20200407.tar.gz](https://mirrors.sirung.org/fuchsia/source-code/fuchsia-source-20200407.tar.gz)

## 构建前的准备
* 配置环境变量(参考官方):  
```
export PATH=$PATH:/opt/work/fuchsia/.jiri_root/bin
source /opt/work/fuchsia/scripts/fx-env.sh
fx-update-path
```

* 恢复bootloader(正确, 需要切换到recovery模式)
1. 下载
```
git clone https://github.com/96boards-hikey/tools-images-hikey960
```
2.  可能需要准备的文件:  
然后需要一个Android版本的Image, 需要其中的一些img, 你可以通过AOSP编译获得:  
```
. build/envsetup.sh
lunch hikey960-userdebug
make -j64
fastboot flashall
```
也可以直接从官方下载, 注意: 需要将编译输出的bin和img拷贝到tools-images-hikey960/下, 否则可能无法启动.

3. 开始刷入bootloader:
```
cd tools-images-hikey960
sudo ./recovery-flash.sh /dev/ttyUSB1
```

##  刷入基本固件
1. 下载
```
git clone https://android.googlesource.com/device/linaro/hikey hikey-firmware
git -C hikey-firmware checkout 972114436628f874ac9ca28ef38ba82862937fbf
fastboot flash ptable hikey-firmware/installer/hikey960/ptable.img
fastboot flash xloader hikey-firmware/installer/hikey960/sec_xloader.img
fastboot flash fastboot hikey-firmware/installer/hikey960/fastboot.img
fastboot flash nvme hikey-firmware/installer/hikey960/nvme.img
fastboot flash fw_lpm3 hikey-firmware/installer/hikey960/lpm3.img
fastboot flash trustfirmware hikey-firmware/installer/hikey960/bl31.bin
```

2. 安装
* 编译
```
fx set bringup.hikey960
fx build
```
* 烧录Hikey960(fastboot模式)
```
out/default/flash.sh
```