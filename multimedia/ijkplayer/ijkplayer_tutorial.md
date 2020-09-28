# ijkplayer Tutorial

## 参考资料
* [GitHub - ijkplayer](https://github.com/bilibili/ijkplayer)
* [GitHub - ijkplayer - Build Android](https://github.com/bilibili/ijkplayer#build-android)

## 直接使用
### Android
直接在`build.gradle`中添加:
```
# required
allprojects {
    repositories {
        jcenter()
    }
}

dependencies {
    # required, enough for most devices.
    compile 'tv.danmaku.ijk.media:ijkplayer-java:0.8.8'
    compile 'tv.danmaku.ijk.media:ijkplayer-armv7a:0.8.8'

    # Other ABIs: optional
    compile 'tv.danmaku.ijk.media:ijkplayer-armv5:0.8.8'
    compile 'tv.danmaku.ijk.media:ijkplayer-arm64:0.8.8'
    compile 'tv.danmaku.ijk.media:ijkplayer-x86:0.8.8'
    compile 'tv.danmaku.ijk.media:ijkplayer-x86_64:0.8.8'

    # ExoPlayer as IMediaPlayer: optional, experimental
    compile 'tv.danmaku.ijk.media:ijkplayer-exo:0.8.8'
}
```

## 源码下载
```
$ cd /opt/work/
$ git clone https://github.com/Bilibili/ijkplayer.git ijkplayer-android
remote: Enumerating objects: 1, done.
remote: Counting objects: 100% (1/1), done.
remote: Total 24877 (delta 0), reused 0 (delta 0), pack-reused 24876
接收对象中: 100% (24877/24877), 7.97 MiB | 1.21 MiB/s, 完成.
处理 delta 中: 100% (15835/15835), 完成.

$ cd ijkplayer-android
$ git checkout -B latest k0.8.8
切换到一个新分支 'latest'

$ ./init-android.sh
git version 2.25.1
== pull ffmpeg base ==
正克隆到 'extra/ffmpeg'...
remote: Enumerating objects: 539035, done.
... ...

$ cd android/contrib

$ ./compile-ffmpeg.sh clean
====================
[*] check archs
====================
FF_ALL_ARCHS = armv5 armv7a arm64 x86 x86_64
FF_ACT_ARCHS = FF_ACT_ARCHS_64

/opt/work/ijkplayer-android/android/contrib
/opt/work/ijkplayer-android/android/contrib
/opt/work/ijkplayer-android/android/contrib
/opt/work/ijkplayer-android/android/contrib
/opt/work/ijkplayer-android/android/contrib

$ ./compile-ffmpeg.sh all
====================
[*] check archs
====================
FF_ALL_ARCHS = armv5 armv7a arm64 x86 x86_64
FF_ACT_ARCHS = armv5 armv7a arm64 x86 x86_64

====================
[*] check env armv5
====================
FF_ARCH=armv5
FF_BUILD_OPT=

--------------------
[*] make NDK standalone toolchain
--------------------
build on Linux x86_64
ANDROID_NDK=
You must define ANDROID_NDK before starting.
They must point to your NDK directories.
```

要求设置下环境变量`ANDROID_NDK`:
```
$ export ANDROID_NDK=~/Android/Sdk/ndk/21.3.6528147/
$ ./compile-ffmpeg.sh all
====================
[*] check archs
====================
FF_ALL_ARCHS = armv5 armv7a arm64 x86 x86_64
FF_ACT_ARCHS = armv5 armv7a arm64 x86 x86_64

====================
[*] check env armv5
====================
FF_ARCH=armv5
FF_BUILD_OPT=

--------------------
[*] make NDK standalone toolchain
--------------------
build on Linux x86_64
ANDROID_NDK=/home/nickli/Android/Sdk/ndk/21.3.6528147/
IJK_NDK_REL=21.3.6528147
You need the NDKr10e or later
```