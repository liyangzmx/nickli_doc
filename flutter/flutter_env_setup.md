# Flutter环境设置

## 参考资料
* [在 Linux 操作系统上安装和配置 Flutter 开发环境(可能需要科学上网)](https://flutter.cn/docs/get-started/install/linux)
* [Flutter Widgets 介绍合集(BiliBili: Google中国)](https://space.bilibili.com/64169458/channel/detail?cid=131083)
* [入门: 在Linux上搭建Flutter开发环境(Flutter中文社区)](https://flutterchina.club/setup-linux/)

## 前提
* 系统: Ubuntu 18.04.3 LTS
* 假设工作目录在: /home/liyang/flutter/下

## 开始
配置环境变量
```
$ cat ~/.bashrc
...
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PATH=$PATH:/home/liyang/flutter/flutter/bin
```

## 克隆SDK的git库
```
$ git clone -b master https://github.com/flutter/flutter.git
```

## 检查flutter状态
```
$ flutter doctor
...
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel master, v1.18.0-5.0.pre.89, on Linux, locale zh_CN.UTF-8)
 
[!] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
    ! Some Android licenses not accepted.  To resolve this, run: flutter doctor --android-licenses
[!] Android Studio (version 3.5)
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
[!] VS Code (version 1.42.1)
    ✗ Flutter extension not installed; install from
      https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
[✓] Connected device (1 available)
 
! Doctor found issues in 3 categories.
```

## 接受License
```
$ flutter doctor --android-licenses
```

## 安装VSCode的flutter插件

## 安装Android Studio 的Flutter插件(Dart插件将随Flutter插件自动安装)

## 重启IDE后再次检查Flutter状态
```
$ flutter doctor 
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, v1.12.13+hotfix.9, on Linux, locale zh_CN.UTF-8)
 
[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
[✓] Android Studio (version 3.5)
[✓] VS Code (version 1.42.1)
[✓] Connected device (1 available)
 
• No issues found!
```

至此Flutter环境已准备好.

PS: 可提前下载一些二进制依赖关系
```
$ flutter precache
```