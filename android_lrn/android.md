# 使用Android  命令行工具获取 adb/fastboot以及 ndk/cmake等
从[Android Studio](https://developer.android.google.cn/studio)页面的[Command line tools only]处下载命令行工具

配置工具:
```
mkdir -p ~/tools
cd ~/tools/
unzip ~/download/commandlinetools-linux-7583922_latest.zip
export PATH=$PATH:~/tools/cmdline-tools/bin
```

可以列出sdkmanager的下载目录:
```
mkdir -p ~/Andorid/Sdk/
sdkmanager --sdk_root=~/Andorid/Sdk/ --list
```

下载需要的ndk等:
```
sdkmanager --sdk_root=~/Andorid/Sdk/ "platform-tools" "platforms;android-28"
```

参考:[sdkmanager](https://developer.android.google.cn/studio/command-line/sdkmanager?hl=en)