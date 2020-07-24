# X264 in Android

## 代码下载:
```
wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2
tar xvf x264-master.tar.bz2
x264-master/
```

## 编译
```
export NDK=~/Android/Sdk/ndk/21.3.6528147/
export HOST_TAG=linux-x86_64 # adjust to your building host
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG

export CC=$TOOLCHAIN/bin/aarch64-linux-android21-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android21-clang++

./configure \
	--prefix=./android/arm64-v8a \
	--enable-static \
	--enable-pic \
	--disable-asm \
	--enable-shared \
	--disable-opencl \
	--disable-cli \
	--host=aarch64-linux \
	--cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
	--sysroot=$TOOLCHAIN/sysroot \

make clean
make -j8
make install
```

## 集成
拷贝库和头文件
```
cp android/arm64-v8a/lib/libx264.so.161 $APP_PROJECT_PATH/app/libs/arm64-v8a/
cp -r include/ $APP_PROJECT_PATH/app/src/main/cpp/
```

通常不需要主动集成, 保证其在**$APP_PROJECT_PATH/app/libs/arm64-v8a/**即可