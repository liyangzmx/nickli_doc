# WebRTC Google SDK简介

## 相关协议
|协议名称|协议编号|协议链接|
|:-|:-|:-|
|SCTP|Stream Control Transmission Protocol|[https://tools.ietf.org/html/rfc2960](https://tools.ietf.org/html/rfc2960)|
|STUN|Simple Traversal of User Datagram Protocol|[https://tools.ietf.org/html/rfc3489](https://tools.ietf.org/html/rfc3489)|
|ICE|Interactive Connectivity Establishment|[https://tools.ietf.org/html/rfc5245](https://tools.ietf.org/html/rfc5245)|
|TURN|Traversal Using Relays around NAT|[https://tools.ietf.org/html/rfc5766](https://tools.ietf.org/html/rfc5766)|
|RTP/RTCP|Real-Time Transport Protocol|[https://tools.ietf.org/html/rfc3550](https://tools.ietf.org/html/rfc3550)|
|SRTP|The Secure Real-time Transport Protocol|[https://tools.ietf.org/html/rfc3711](https://tools.ietf.org/html/rfc3711)|
|HMAC|Keyed-Hashing for Message Authentication|https://tools.ietf.org/html/rfc2104|
|TLS|The TLS Protocol|https://tools.ietf.org/html/rfc2246|
|DTLS|Datagram Transport Layer Security|https://tools.ietf.org/html/rfc4347|

## 自行编译安装
### 安装deptools
`$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git`  
`$ export PATH=/path/to/depot_tools:$PATH`  

参考: [depot_tools_tutorial - SETTING UP](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up)  

### 准备工作
`./build/install-build-deps.sh`  
参考: [Prerequisite Software](http://webrtc.github.io/webrtc-org/native-code/development/prerequisite-sw/)  

### 获取源码
`fetch --nohooks webrtc_android`  
`gclient sync`  
参考: [WebRTC Native Code - Android](http://webrtc.github.io/webrtc-org/native-code/android/)  

### 其它平台请参考
[WebRTC Native Code](http://webrtc.github.io/webrtc-org/native-code/)  

### 编译(通用)
`gn gen out/Debug --args='target_os="android" target_cpu="arm"'`  
`ninja -C out/Debug`  

### 编译(Android Demo App)
为了使用捆绑在其中的Android SDK和NDK third_party/android_tools，请运行以下命令以将其包含在您的中PATH（来自 src/）：  
`. build/android/envsetup.sh`  
正常生成项目（out / Debug应该是使用GN生成生成文件时使用的目录）：  
`ninja -C out/Debug AppRTCMobile`  
生成项目文件：  
`build/android/gradle/generate_gradle.py --output-directory $PWD/out/Debug \
--target "//examples:AppRTCMobile" --use-gradle-process-resources \
--split-projects --canary`

## 预建库(Android)
最简单的入门方法是使用 JCenter上可用的[官方预建库](https://bintray.com/google/webrtc/google-webrtc)。这些库是从树梢编译的，仅用于开发目的。

在Android Studio 3上，添加到您的依赖项：  
`implementation 'org.webrtc:google-webrtc:1.0.+'`  
在Android Studio 2上，添加到您的依赖项：  
`compile 'org.webrtc:google-webrtc:1.0.+'`  


## 集成到app中:
拷贝生成的库到app的libs目录(假设webrtc的源码路径在:`/opt/work/webrtc/webrtc_android`, app工程目录在:`/opt/work/webrtc/amazon-kinesis-video-streams-webrtc-sdk-android/`):  
```
cp /opt/work/webrtc/webrtc_android/src/out/DebugArm64/lib.unstripped/libjingle_peerconnection_so.so /opt/work/webrtc/amazon-kinesis-video-streams-webrtc-sdk-android/libs/arm64-v8a/

cp /opt/work/webrtc/webrtc_android/src/out/DebugArm/lib.java/sdk/android/libwebrtc.jar /opt/work/webrtc/amazon-kinesis-video-streams-webrtc-sdk-android/libs/
```
然后在build.gradle(app)中添加如下内容:
```
android {
    ...
    sourceSets {
        main {
            jniLibs.srcDirs = ['libs']
        }
    }
    // 这个地方不清楚怎么回事儿, 在AWS的Demo上要加这部分, 否则会找不到so库
    splits {
        abi {
            enable true
            reset()
            include 'x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a' //select ABIs to build APKs for
            universalApk true //generate an additional APK that contains all the ABIs
        }
    }
}
```  
添加依赖:  
```
dependencies {
    // 注释掉原有的webrtc预编译依赖
    // implementation 'org.webrtc:google-webrtc:1.0.28513'
    // 添加本地的jar包支持
    implementation files('libs/libwebrtc.jar')
}