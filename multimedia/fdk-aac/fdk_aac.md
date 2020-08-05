# libfdk-aac with FFmpeg

## 下载源码并解压
```
cd /opt/work/
wget https://downloads.sourceforge.net/opencore-amr/fdk-aac-2.0.1.tar.gz
tar xvf fdk-aac-2.0.1.tar.gz
fdk-aac-2.0.1
```

准备编译脚本(以`21.3.6528147`为例):
```
#!/bin/bash

export API=21
export NDK=~/Android/Sdk/ndk/21.3.6528147/
export HOST_TAG=linux-x86_64 # adjust to your building host
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
export CROSS_PREFIX=aarch64-linux-android

export CC=$TOOLCHAIN/bin/${CROSS_PREFIX}${API}-clang
export CXX=$TOOLCHAIN/bin/${CROSS_PREFIX}${API}-clang++
export AR=$TOOLCHAIN/bin/${CROSS_PREFIX}-ar
export AS=$TOOLCHAIN/bin/${CROSS_PREFIX}-as
export LD=$TOOLCHAIN/bin/${CROSS_PREFIX}-ld
export RANLIB=$TOOLCHAIN/bin/${CROSS_PREFIX}-ranlib
export STRIP=$TOOLCHAIN/bin/${CROSS_PREFIX}-strip

echo "${CC}"

function build_arm64-v8a
{
	./configure \
	--prefix=/opt/work/_install/ \
	--enable-shared \
	--host=aarch64-linux \
	--with-sysroot=$TOOLCHAIN/sysroot
	CPPFLAGS="-fPIC"

    make clean
	make -j8
	make install
}

build_arm64-v8a
echo build_arm64-v8a finished
```

此时输出会在`/opt/work/_install/`目录中:
```
tree /opt/work/_install/
--- <OUTPUT> ---
/opt/work/_install/
├── include
│   └── fdk-aac
│       ├── aacdecoder_lib.h
│       ├── aacenc_lib.h
│       ├── FDK_audio.h
│       ├── genericStds.h
│       ├── machine_type.h
│       └── syslib_channelMapDescr.h
└── lib
    ├── libfdk-aac.a
    ├── libfdk-aac.la
    ├── libfdk-aac.so -> libfdk-aac.so.2.0.1
    ├── libfdk-aac.so.2 -> libfdk-aac.so.2.0.1
    ├── libfdk-aac.so.2.0.1
    └── pkgconfig
        └── fdk-aac.pc
```

## FFmpeg的集成
`configure`的参数要附加:
```
    ./configure \
    ... \
    --extra-cflags="... -I/opt/work/_install/include/"
    --extra-ldflags="... -L/opt/work/_install/lib/" \
    --enable-nonfree \
    --enable-libfdk-aac \
    ... \
    ...
```

然后重新编译ffmpeg, 此时可以留意到`config.h`中的变化:
```
...
// 此前的定义都是: 0
#define CONFIG_LIBFDK_AAC 1
#define CONFIG_LIBFDK_AAC_DECODER 1
#define CONFIG_LIBFDK_AAC_ENCODER 1
```
还有`libavcodec/codec_list.c`:
```
static const AVCodec * const codec_list[] = {
    ...
    // 启用fdk-aac前没有这两行
    &ff_libfdk_aac_encoder,
    &ff_libfdk_aac_decoder,
    ...
    NULL
};
```

最终得到的`libavcodec/libavcodec.so`会有变化.

## Android App的集成
首先将`libfdk-aac.so`和重新编译的`libavcodec.so`放置到APP的`app/libs/${ANDROID_ABI}/`下, 然后在Java的so加载代码中添加对应的项即可:
```
static {
    // "fdk-aac"应当在ffmpeg的库前加载
    System.loadLibrary("fdk-aac");

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

## Native Code中对libfdk-aac的有限选择
在确定`AVMEDIA_TYPE_AUDIO`的流的ID后, 需要准备解码器(`AVCodec`), 使用的方法:
```
/**
 * Find a registered decoder with the specified name.
 *
 * @param name name of the requested decoder
 * @return A decoder if one was found, NULL otherwise.
 */
AVCodec *avcodec_find_decoder_by_name(const char *name);
```
可以得到期望的"fdk_aac"解码器, 但还是建议在使用该函数前根据`AVFormatContext`的`streams[video_stream_idx]->codecpar->codec_id`成员进行判断, 在其值为`AV_CODEC_ID_AAC`再用该方法.

## 备注
关于FFmpeg的编译请参考这篇: [FFmpeg in Android](../ffmpeg/ffmpeg_android.md)