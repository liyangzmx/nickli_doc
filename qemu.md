# QEMU

## build
For Ubuntu LTS Trusty (and maybe other Debian based distributions), all required additional packages can be installed like this:
```
sudo apt-get install git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
```

Recommended additional packages:
```
sudo apt-get install git-email
sudo apt-get install libaio-dev libbluetooth-dev libbrlapi-dev libbz2-dev
sudo apt-get install libcap-dev libcap-ng-dev libcurl4-gnutls-dev libgtk-3-dev
sudo apt-get install libibverbs-dev libjpeg8-dev libncurses5-dev libnuma-dev
sudo apt-get install librbd-dev librdmacm-dev
sudo apt-get install libsasl2-dev libsdl1.2-dev libseccomp-dev libsnappy-dev libssh2-1-dev
sudo apt-get install libvde-dev libvdeplug-dev libvte-2.90-dev libxen-dev liblzo2-dev
sudo apt-get install valgrind xfslibs-dev 
```

Newer versions of Debian / Ubuntu might also try these additional packages: 
```
sudo apt-get install libnfs-dev libiscsi-dev
```

## Getting the source code
```
git clone git://git.qemu-project.org/qemu.git
```

## Configure
```
./configure --target-list=aarch64-linux-user
```

如果遇到报错:
```
fatal: 无法克隆 'https://gitlab.com/qemu-project/dtc.git' 到子模组路径 '/home/yuanxin/work/qemu/dtc'
第二次尝试克隆 'dtc' 失败，退出
/home/yuanxin/work/qemu/scripts/git-submodule.sh: failed to update modules

Unable to automatically checkout GIT submodules ' ui/keycodemapdb tests/fp/berkeley-testfloat-3 tests/fp/berkeley-softfloat-3 meson dtc capstone slirp'.
If you require use of an alternative GIT binary (for example to
enable use of a transparent proxy), then please specify it by
running configure by with the '--with-git' argument. e.g.

 $ ./configure --with-git='tsocks git'

Alternatively you may disable automatic GIT submodule checkout
with:

 $ ./configure --with-git-submodules=validate

and then manually update submodules prior to running make, with:

 $ scripts/git-submodule.sh update  ui/keycodemapdb tests/fp/berkeley-testfloat-3 tests/fp/berkeley-softfloat-3 meson dtc capstone slirp
```

按照提示尝试执行：
```
scripts/git-submodule.sh update  ui/keycodemapdb tests/fp/berkeley-testfloat-3 tests/fp/berkeley-softfloat-3 meson dtc capstone slirp
```

再次执行：
```
./configure --target-list=aarch64-linux-user
```

遇到报错：
```
../tests/fp/meson.build:27:0: ERROR: Include dir berkeley-softfloat-3/source/include does not exist.
```

更新子模块即可：
```
git submodule update
```

再次执行：
```
./configure --target-list=aarch64-linux-user
```

输出：
```
                libdaxctl support: NO
                          libudev: NO
                       FUSE lseek: NO

  Subprojects
                    libvhost-user: YES

Found ninja-1.8.2 at /usr/bin/ninja
```
表示configure完成， 然后执行编译命令：
```
make -j4
```