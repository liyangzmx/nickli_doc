# Yocto and RaspberryPi

# 下载meta-raspberrypi
```
$ cd /opt/work/poky/
$ git clone git://git.yoctoproject.org/meta-raspberrypi
// cd meta-raspberrypi/; $ git checkout -b gatesgarth origin/gatesgarth; cd -
$ cd build/
$ bitbake-layers add-layer ../meta-raspberrypi/
```

# 执行编译
```
MACHINE=raspberrypi4-64 bitbake rpi-test-image
```

拷贝镜像: 
```
sudo bmaptool copy build/tmp/deploy/images/raspberrypi4-64/rpi-test-image-raspberrypi4-64.wic.bz2 /dev/sde
```



# 尝试添加Qt5支持
```
$ cd /opt/work/poky/
$ git clone git://code.qt.io/yocto/meta-qt5.git
$ cd build/
$ bitbake-layers add-layer ../meta-qt5
```

但遇到报错:
```
$ bitbake rpi-test-image
ERROR: Layer qt5-layer is not compatible with the core layer which only supports these series: gatesgarth (layer is compatible with thud sumo)
```

这是层不匹配导致的:
```
$ cd ../meta-qt5/; git checkout -b gatesgarth remotes/origin/upstream/gatesgarth; cd -
$ bitbake rpi-test-image
ERROR: No recipes in default available for:
  /opt/work/poky/meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-omx_1.18%.bbappend
  /opt/work/poky/meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good_1.18.%.bbappend
```
以上是因为层的配置上存在问题:
```
$ mv /opt/work/poky/meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-omx_1.18%.bbappend /opt/work/poky/meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-omx_1.16%.bbappend

$ mv /opt/work/poky/meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good_1.18.%.bbappend /opt/work/poky/meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good_1.16.%.bbappend

$ bitbake rpi-test-image
Loading cache: 100% |############################################################################| Time: 0:00:00
Loaded 1471 entries from dependency cache.
Parsing recipes: 100% |##########################################################################| Time: 0:00:00
Parsing of 887 .bb files complete (885 cached, 2 parsed). 1471 targets, 66 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies

Build Configuration:
BB_VERSION           = "1.48.0"
BUILD_SYS            = "x86_64-linux"
NATIVELSBSTRING      = "ubuntu-20.04"
TARGET_SYS           = "aarch64-poky-linux"
MACHINE              = "raspberrypi4-64"
DISTRO               = "poky"
DISTRO_VERSION       = "3.2.1"
TUNE_FEATURES        = "aarch64 armv8a crc crypto cortexa72"
TARGET_FPU           = ""
meta                 
meta-poky            
meta-yocto-bsp       = "gatesgarth:999af8ca436d1ccc2b545bbba9c7e060bc21dd38"
meta-qt5             = "gatesgarth:2b33a5d5e888370bb56685b86aa82b73624f19f0"
meta-raspberrypi     = "master:a7cc636d4ef0ed7ddabf5785463dbb5c79633b1e"
... ...
```



# 分析
## `meta/recipes-core/images/core-image-base.bb`
```
SUMMARY = "A console-only image that fully supports the target device \
hardware."

IMAGE_FEATURES += "splash"

LICENSE = "MIT"
# 包含core-image文件
inherit core-image
```

查看`meta/classes/core-image.bbclass`:
```
FEATURE_PACKAGES_x11 = "packagegroup-core-x11"
... ...
FEATURE_PACKAGES_ssh-server-openssh = "packagegroup-core-ssh-openssh"
FEATURE_PACKAGES_hwcodecs = "${MACHINE_HWCODECS}"

IMAGE_FEATURES_REPLACES_ssh-server-openssh = "ssh-server-dropbear"

MACHINE_HWCODECS ??= ""

CORE_IMAGE_BASE_INSTALL = '\
    packagegroup-core-boot \
    packagegroup-base-extended \
    \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    '

CORE_IMAGE_EXTRA_INSTALL ?= ""

IMAGE_INSTALL ?= "${CORE_IMAGE_BASE_INSTALL}"

inherit image
```

**注意:** 对于`FEATURE_PACKAGES_<NAME>`的定义, 当`IMAGE_FEATURES`的设置包含`<NAME>`时, 所有`FEATURE_PACKAGES_<NAME>`中的包将被包含在镜像当中.


查看`meta/classes/image.bbclass`:
```

```