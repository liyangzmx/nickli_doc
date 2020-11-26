# RTL8125 网卡驱动安装

## 下载驱动
官网: [Realtek PCIe FE / GBE / 2.5G / Gaming Ethernet Family Controller Software](https://www.realtek.com/ja/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software)

## 命令
```
$ cd /opt/work/
$ tar xvf ~/download/r8125-9.004.01.tar.bz2
$ cd r8125-9.004.01/
$ sudo ./autorun.sh
--------------- < OUTPUT > ---------------
Check old driver and unload it.
Build the module and install
At main.c:160:
- SSL error:02001002:system library:fopen:No such file or directory: ../crypto/bio/bss_file.c:69
- SSL error:2006D080:BIO routines:BIO_new_file:no such file: ../crypto/bio/bss_file.c:76
sign-file: certs/signing_key.pem: No such file or directory
Warning: modules_install: missing 'System.map' file. Skipping depmod.
DEPMOD 5.4.0-54-generic
load module r8125
Updating initramfs. Please wait.
update-initramfs: Generating /boot/initrd.img-5.4.0-54-generic
Completed.
```