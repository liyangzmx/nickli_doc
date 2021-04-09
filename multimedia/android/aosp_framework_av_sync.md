# 同步AOSP部分源码(多媒体/NDK)

国内清华大学提供了AOSP的镜像地址:[Android 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)

获得repo, 请参考: [Git Repo 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/git-repo/)

Android分支选择请参考: [代号、标记和 Build 号](https://source.android.com/setup/start/build-numbers)

备注: 这里我们选择**android-11.0.0_r28**

初始化Repo:
```
$ repo init -u https://mirrors.tuna.tsinghua.edu.cn/git/AOSP/platform/manifest -b android-11.0.0_r28
```

**注意**: 由于我们只需要多媒体的部分代码作为参考, 因此我们没有必要同步所有的源码, 只需:
```
$ repo sync frameworks/av
```
即可.

关于**NDK**的**AMediaCodec/AMediaFormat/AMediaExtractor**等, 请参考**frameworks/av/media/ndk/**即可.