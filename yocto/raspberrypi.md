# Yocto and RaspberryPi

# 下载meta-raspberrypi
```
$ cd /opt/work/poky/
$ git clone git://git.yoctoproject.org/meta-raspberrypi
$ cd build/
$ bitbake-layers add-layer ../meta-raspberrypi/
```

# 执行编译
```
MACHINE=raspberrypi4-64 bitbake core-image-base
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