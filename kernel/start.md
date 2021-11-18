# 准备工作

## 下载buildroot
[buildroot-2021.02.4.tar.bz2](https://buildroot.org/downloads/buildroot-2021.02.4.tar.bz2)

解压并配置:
```
mkdir -p ~/work/
cd ~/work/
tar xvf ~/Download/buildroot-2021.02.4.tar.bz2
cd buildroot-2021.02.4
make qemu_arm_vexpress_defconfig
make -j32
```

注意: 内核版本为: **5.10.7**
源码: output/build/linux-5.10.7/
ELF: output/build/linux-5.10.7/vmlinux
DTS: output/build/linux-5.10.7/arch/arm/boot/dts/vexpress-v2p-ca9.dts

安装虚拟机:
```
sudo apt-get install qemu-system-arm
```

启动buildroot虚拟机:
```
cd ~/work/buildroot-2021.02.4
./output/images/start-qemu.sh
```
但是通常上面的脚本并不好用, 因此你可能需要手动执行下
```
./output/build/host-qemu-5.2.0/build/qemu-system-arm -M vexpress-a9 -smp 1 -m 256 -kernel output/images/zImage -dtb output/images/vexpress-v2p-ca9.dtb -drive file=output/images/rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 rootwait root=/dev/mmcblk0" -nographic
```

对于Linux内核的配置修改:
```
make linux-menuconfig
```

基本内核配置:
```
DEBUG_INFO=y
DEBUG_KERNEL=y
DEBUG_FS=y
```