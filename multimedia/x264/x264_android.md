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
	--prefix=/opt/work/_install/ \
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
cp /opt/work/lib/libx264.so.161 $APP_PROJECT_PATH/app/libs/arm64-v8a/
cp -r include/ $APP_PROJECT_PATH/app/src/main/cpp/
```

## FFmpeg的集成
`configure`的参数要附加:
```
    ./configure \
    ... \
    --extra-cflags="... -I/opt/work/_install/include/"
    --extra-ldflags="... -L/opt/work/_install/lib/" \
    --enable-gpl \
    --enable-libx264 \
    ... \
    ...
```

然后重新编译ffmpeg, 此时可以留意到`config.h`中的变化:
```
...
// 此前的定义都是: 0
#define CONFIG_LIBX264_ENCODER 1
#define CONFIG_LIBX264RGB_ENCODER 1
```
还有`libavcodec/codec_list.c`:
```
static const AVCodec * const codec_list[] = {
    ...
    // 启用libx264前没有这两行
    &ff_libx264_encoder,
    &ff_libx264rgb_encoder,
    ...
    NULL
};
```

最终得到的`libavcodec/libavcodec.so`会有变化.

## Android App的集成
首先将`libx264.so`和重新编译的`libavcodec.so`放置到APP的`app/libs/${ANDROID_ABI}/`下, 然后在Java的so加载代码中添加对应的项即可:
```
static {
    // "fdk-aac"应当在ffmpeg的库前加载
    System.loadLibrary("x264");

    System.loadLibrary("avutil");
    System.loadLibrary("swresample");
    System.loadLibrary("avformat");
    System.loadLibrary("avcodec");
    System.loadLibrary("swscale");
    System.loadLibrary("avfilter");
    System.loadLibrary("avresample");
    System.loadLibrary("avdevice");
    ...
}
```

## 备注
关于FFmpeg的编译请参考这篇: [FFmpeg in Android](../ffmpeg/ffmpeg_android.md)