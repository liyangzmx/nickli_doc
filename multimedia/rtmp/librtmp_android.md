# RTMPDump in Android(无OpenSSL)

## 编译
源码:
```
wget http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz
tar xvf rtmpdump-2.3.tgz
cd rtmpdump-2.3/
```

环境变量:
```
export NDK=~/Android/Sdk/ndk/21.3.6528147/
export HOST_TAG=linux-x86_64
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
export PATH=$PATH:$TOOLCHAIN/bin
export target_host=aarch64-linux-android
export ANDROID_API=23
export XCFLAGS="-isysroot ${TOOLCHAIN}/sysroot -isystem ${TOOLCHAIN}/sysroot/usr/include/${target_host} -D__ANDROID_API__=${ANDROID_API}"
export CROSS_COMPILE=${TOOLCHAIN}/bin/${target_host}-
export CC=${TOOLCHAIN}/bin/${target_host}${ANDROID_API}-clang
export AR=${TOOLCHAIN}/bin/${target_host}-ar
export LD=${TOOLCHAIN}/bin/${target_host}-ld
```
编译:
```
make clean
make SYS=posix prefix=`pwd`/install CC=$CC AR=$AR LD=$LD CRYPTO=
```