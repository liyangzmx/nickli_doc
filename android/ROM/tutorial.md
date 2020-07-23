# AOSP Build
本文与[https://source.android.google.cn/](https://source.android.google.cn/)网站的参考文档顺序稍有不同, 因本文的目的不在于反复提及官网中已经提及的内容, 希望本文对您的开发有所帮助.

## 源代码控制工具
Android官网推荐的两个重要工具: Git & Repo, 他们是必须要了解和熟悉的.

### Git
Android官网推荐的参考文档: [Git 文档](https://git-scm.com/doc), 而本文推荐您直接看官网推荐的这本书: [Git 文档 - Book](https://git-scm.com/book/zh/v2), 是的, 从这个页面中, 下载的pdf是中文的.  

#### Repo
Repo(源码库:[repo](https://gerrit.googlesource.com/git-repo/+/refs/heads/master/README.md))是个非常好用的Git仓库管理工具, 一开始使用这个工具的时候, 你可能苦于如何管理项目中的**.repo/manifest.xml**, 它的参考文档: [repo Manifest Format](https://gerrit.googlesource.com/git-repo/+/master/docs/manifest-format.md), Google同时也提供了其他文档的入口:
* [Repo 命令参考文档](https://source.android.google.cn/setup/develop/repo?hl=zh-cn)
* [Repo README](https://gerrit.googlesource.com/git-repo/+/refs/heads/master/README.md)
* [AOSP Preupload Hooks](https://android.googlesource.com/platform/tools/repohooks/+/refs/heads/master/README.md)

**不幸的是**, 你每次使用`repo init`初始化一个repo项目时, 你送回碰到项目中 **.repo/** 这个基础库需要clone**很久**的问题, 所以您可能需要参考一篇文档:  
[Git Repo 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/git-repo/)  
这将提升您在国内使用repo命令的体验.

## 设备选择
**为什么先选择设备而不是先获取源码?**  
这是因为你选择的设备可能决定了您使用的首选分支, 所以您应该先看下Google提供的文档: [代号、标记和 Build 号](https://source.android.google.cn/setup/start/build-numbers?hl=zh-cn), 而对于Google推荐的设备选择: [选择设备 build](https://source.android.google.cn/setup/build/running?hl=zh-cn#selecting-device-build), 大可不必购买最新的Android手机或者一些奇怪的开发板, 国内有很多的翻新机会是更有性价比的选择~  

**注意:** 尽量选择已解锁的版本, 虽然Google提供了相应的解锁参考文档: [解锁引导加载程序](https://source.android.google.cn/setup/build/running?hl=zh-cn#unlocking-the-bootloader), 但文档中的内容不**总是可用**的, 所以为了节省不必要的麻烦, 可以优先提出解锁的要求, 但这可能需要支付少量的"**手续费**". 这点其实在Google的参考文档([Android 刷写工具 - 准备设备](https://source.android.google.cn/setup/contribute/flash?hl=zh-cn#preparing-your-device))中有对应的提示:  
"**有些设备需要运营商干预才能解锁。如需了解详情，请与您的运营商联系。**"

选择的设备讲决定了您的lunch选项, 这在[编译 Android - 选择目标](https://source.android.google.cn/setup/build/building?hl=zh-cn#choose-a-target)中会有所提及.

**如何根据设备选择分支?**  
在[代号、标记和 Build 号](https://source.android.google.cn/setup/start/build-numbers?hl=zh-cn)中, 如果您选择了Google Pixel XL, 那么请搜索"**Pixel XL**", 那么你将看到它在表给中的项目:
|Build	|标记	|版本	|支持的设备	|安全补丁程序级别|
|:-|:-|:-|:-|:-|  
|QP1A.191005.007.A3	|android-10.0.0_r17	|Android10	|Pixel XL、Pixel	|2019-10-06|

表格中的"**标记**"就是您执行`repo init ***** -b <分支>`时的分支名称.

但是无论选择那种设备, 如果你想编译出来一个能用的系统, 你最好看看这篇资料(以Google Pixel为例): [Pixel XL的驱动程序二进制文件](pixel_drivers.md), 这个步骤可以提前做, 后面会用上

## 个人开发者用户拉取国内AOSP镜像
建议您提前看下Google的官方文档[下载源代码](https://source.android.google.cn/setup/build/downloading?hl=zh-cn), 然后**不要着急开始尝试**, 先看看下面列表中的任何一个:
* [清华 - TUNA - Android 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)
* [中科大 - LUG - AOSP(Android) 镜像使用帮助](https://lug.ustc.edu.cn/wiki/mirrors/help/aosp)  

此时您应该知道如何在国内快速的拉去AOSP的源码了, 源码下载完成后, 您应该按照[Pixel XL的驱动程序二进制文件](pixel_drivers.md)解压好下载完的zip包, 并执行驱动二进制文件的解压操作.


## 代码提交的工作流程
Google官方的参考: [源代码控制工作流程](https://source.android.google.cn/setup/create/coding-tasks?hl=zh-cn)  
但通常你需要**按照公司的要求**来~~


## Build
迄今为止, 应该已经通过repo拉取了android-10.0.0_r17分支的AOSP源码, 并且解压好了驱动二进制文件, 此时在aosp目录下, 可以看到多出来了一个vendor目录.  
对于构建, 你可以先跳过[Soong 构建系统](https://source.android.google.cn/setup/build?hl=zh-cn)的章节, 因为对单纯的编译而言, 现在暂时不需要对这个文档有太多关注.  

对于编译, 参考[编译 Android](https://source.android.google.cn/setup/build/building?hl=zh-cn)开始编译过程吧, 特别的: 如果你选择了Pixel XL, 那么你应该执行的是: `lunch aosp_marlin-userdebug`, 其它的选择, 以[编译 Android - 选择目标](https://source.android.google.cn/setup/build/building?hl=zh-cn#choose-a-target)为准.  

## Android 刷写
如果你是自行构建的Android, 那么**不要**参考: [Android 刷写工具](https://source.android.google.cn/setup/contribute/flash?hl=zh-cn), **而是** 参考: [刷写设备](https://source.android.google.cn/setup/build/running?hl=zh-cn)

## Build 内核
**注意:**  
* 资料:[构建内核](https://source.android.google.cn/setup/build/building-kernels?hl=zh-cn)中提及的[下载源代码和编译工具](https://source.android.google.cn/setup/build/building-kernels?hl=zh-cn#downloading)小节, 请特别注意repo库的区别, 其为: "**kernel/manifest**", 而**不同**于 "**~~platform/manifest~~**"
* 对于有些设备, 可能存在boot.img的**签名问题**, 如果有这个部分资料, 需要在构建boot.img后特别留意.
* **Hikey960**的内核采用资料中的方式是**无法build完成**, 可以试试看: [手动构建内核](https://source.android.google.cn/setup/build/building-kernels-deprecated?hl=zh-cn)