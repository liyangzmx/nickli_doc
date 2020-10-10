# WebRTC笔记

## 开始
### 官方资料
毫无疑问, WebRTC的官网([webrtc.org](https://webrtc.org/))是了解WebRTC本身的一个好的开始, 网站提供了简体中文的支持. 
注: 对于[导游](https://webrtc.org/getting-started/overview)的陈述都是以`javascript`为主的, 其它的参考, 应移步到其它页面:
* [WebRTC native code](https://webrtc.googlesource.com/src/+/refs/heads/master/docs/native-code/index.md)

### WebRTC标准
* [WebRTC 1.0：浏览器之间的实时通信](https://w3c.github.io/webrtc-pc/)
* [WebRTC统计API的标识符](https://w3c.github.io/webrtc-stats/)
* [媒体捕获和流](https://w3c.github.io/mediacapture-main/)

---
## WebRTC Android源码获取与编译
### 获取depot_tools
WebRTC的源码是与哦那个了Google Chrome的源码管理工具: depot_tools, 安装该工具的方法:  
[Install the Chromium depot tools](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up)  
```
$ mkdir ~/work/webrtc/
$ cd ~/work/webrtc/
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
$ export PATH=~/work/webrtc/depot_tools:$PATH
```

备注:
在使用`depot_tools`前你可能需要提前装git, 参考: [git-scm - Downloads](https://git-scm.com/downloads), 然后便可以使用如下命令同步代码:
```
$ fetch --nohooks webrtc_android
$ gclient sync
```

### 获取源码
此时已经有了`depot_tools`并且已经为它配置好了工作路径, 对于**Android**下的情形, 参考:  
[WebRTC Android development - Getting the Code](https://webrtc.googlesource.com/src/+/refs/heads/master/docs/native-code/android/index.md#getting-the-code)  
创建一个工作目录，进入它，然后运行：
```
$ fetch --nohooks webrtc_android
Running: gclient root
WARNING: Your metrics.cfg file was invalid or nonexistent. A new one will be created.
Running: gclient config --spec 'solutions = [
  {
    "name": "src",
    "url": "https://webrtc.googlesource.com/src.git",
    "deps_file": "DEPS",
    "managed": False,
    "custom_deps": {},
  },
]
target_os = ["android", "unix"]
'
Running depot tools as root is sad.
Running: gclient sync --nohooks --with_branch_heads
Running depot tools as root is sad.

________ running 'git -c core.deltaBaseCacheLimit=2g clone --no-checkout --progress https://webrtc.googlesource.com/src.git /root/webrtc_android/_gclient_src_fiw33rwz' in '/root/webrtc_android'
Cloning into '/root/webrtc_android/_gclient_src_fiw33rwz'...
remote: Sending approximately 303.35 MiB ...
remote: Total 362714 (delta 269798), reused 362714 (delta 269798)
Receiving objects: 100% (362714/362714), 303.33 MiB | 12.53 MiB/s, done.
Resolving deltas: 100% (269798/269798), done.
Syncing projects:   3% (10/310) src/base                                  
[0:02:20] Still working on:
[0:02:20]   src/examples/androidtests/third_party/gradle
[0:02:20]   src/third_party
[0:02:20]   src/tools
... ...
[0:15:36] Still working on:
[0:15:36]   src/third_party/android_ndk
Syncing projects: 100% (310/310), done. 
Running: git submodule foreach 'git config -f $toplevel/.git/config submodule.$name.ignore all'
Running: git config --add remote.origin.fetch '+refs/tags/*:refs/tags/*'
Running: git config diff.ignoreSubmodules all


# 其实这个命令可以不必使用了, 因为上问的fetch命令已经涵盖了`gclient sync --nohooks --with_branch_heads`
$ gclient sync
```

注意：如何更新代码, 应参考: [WebRTC development - Getting the Code](https://webrtc.googlesource.com/src/+/refs/heads/master/docs/native-code/development/index.md#getting-the-code)
注意: 如果fetch和gclient命令遇到卡顿/超时等报错, 请参考本文结尾的补充说明.
---

## 编译Android平台的`libjingle_peerconnection_so.so`, `libwebrtc.a`与`libwebrtc.jar`
参考  
[WebRTC development - Compiling](https://webrtc.googlesource.com/src/+/refs/heads/master/docs/native-code/android/index.md#compiling)  
执行:
```
$ export PATH=~/work/webrtc/depot_tools:$PATH
$ source build/android/envsetup.sh
$ gn gen out/DebugArm64 --args='target_os="android" target_cpu="arm64" use_custom_libcxx=false' 
$ ninja -C out/DebugArm64
```
对于编译, 我们最终需要得到的产出:  
* `out/DebugArm64/lib.unstripped/libjingle_peerconnection_so.so`
* `out/DebugArm64/obj/libwebrtc.a`
* `out/DebugArm64/lib.java/sdk/android/libwebrtc.jar`
---

## 编译官方的Android Demo
执行命令:
```
$ cd webrtc_android/src
$ build/android/gradle/generate_gradle.py --output-directory $PWD/out/DebugArm64 \
> --target "//examples:AppRTCMobile" --use-gradle-process-resources \
> --split-projects --canary
W    0.000s Main  Creating project at: /home/nickli/work/webrtc/30987/webrtc_android/src/out/DebugArm64/gradle
W    0.000s Main  Building .build_config files...

# ... 时间会比价久

```
生成的工程在: `out/DebugArm64/gradle`, 使用**Android Studio**导入即可.

---
## `webrtc.jar`与`libjingle_peerconnection_so.so`在Android App中的使用
拷贝生成的库到app的libs目录(假设webrtc的源码路径在:`~/work/webrtc/webrtc_android`, app工程目录在:`~/work/webrtc/amazon-kinesis-video-streams-webrtc-sdk-android/`):  
```
cp ~/work/webrtc/webrtc_android/src/out/DebugArm64/lib.unstripped/libjingle_peerconnection_so.so ~/work/webrtc/<APP_DIR>/app/libs/arm64-v8a/

cp ~/work/webrtc/webrtc_android/src/out/DebugArm/lib.java/sdk/android/libwebrtc.jar ~/work/webrtc/<APP_DIR>/app/libs/
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
    splits {
        abi {
            enable true
            reset()
            include 'arm64-v8a' //select ABIs to build APKs for
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
```

### libwebrtc.a在Android App中的使用
摘取头文件
```
$ mkdir -p /tmp/include
$ find api/ audio/ base/ call/ common_audio/ common_video/ logging/ media/ modules/ p2p/ pc/ rtc_base/ rtc_tools/ sdk/ stats/ system_wrappers/ third_party/abseil-cpp/ video/ -name "*.h" -exec cp --parents '{}' /tmp/include/ ';'

$ find . -maxdepth 1 -name "*.h" -exec cp --parents '{}' /tmp/include/ ';'
```
将头文件放置于`app/src/main/cpp/`下, 然后修改`app/src/main/cpp/CMakeLists.txt`
```
... ...

add_library( # Sets the name of the library.
    native-lib

    # Sets the library as a shared library.
    SHARED

    # Provides a relative path to your source file(s).
    native-lib.cpp 
)
add_library(webrtc STATIC IMPORTED)
set_target_properties(webrtc PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libwebrtc.a)

target_include_directories(native-lib PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include/)
target_include_directories(native-lib PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include/third_party/abseil-cpp/)

target_link_libraries( # Specifies the target library.
    native-lib
    webrtc
    ...
)
```

### 关于`use_custom_libcxx=false`的说明
`use_custom_libcxx=false`这个选项是为了防止后面链接`libwebrtc.a`时出现C++库链接问题. 该选项默认为`true`, 这会导致webrtc的库, 默认链接到的是自己的`in-tree libc++`. 
在`buildtools/third_party/libc++/trunk/include/__config`文件中:
```
... ...
 126 #define _LIBCPP_CONCAT1(_LIBCPP_X,_LIBCPP_Y) _LIBCPP_X##_LIBCPP_Y
 127 #define _LIBCPP_CONCAT(_LIBCPP_X,_LIBCPP_Y) _LIBCPP_CONCAT1(_LIBCPP_X,_LIBCPP_Y)
 128 
 129 #ifndef _LIBCPP_ABI_NAMESPACE
 130 # define _LIBCPP_ABI_NAMESPACE _LIBCPP_CONCAT(__,_LIBCPP_ABI_VERSION)
 131 #endif
... ...
 761 // Inline namespaces are available in Clang/GCC/MSVC regardless of C++ dialect.
 762 #define _LIBCPP_BEGIN_NAMESPACE_STD namespace std { inline namespace _LIBCPP_ABI_NAMESPACE {
 763 #define _LIBCPP_END_NAMESPACE_STD  } }
... ...
```
因此对于`in-tree libc++`, 在文件`buildtools/third_party/libc++/trunk/include/string`中:
```
... ...
4358 }
4359 #endif
4360 
4361 _LIBCPP_END_NAMESPACE_STD
4362 
4363 _LIBCPP_POP_MACROS
4364 
4365 #endif  // _LIBCPP_STRING
```
所以`basic_string`的完整定义是:`std::__1::basic_string`

而N对于NDK, 文件`third_party/android_ndk/sources/cxx-stl/llvm-libc++/include/__config`中:
```
... ...
 121 #define _LIBCPP_CONCAT1(_LIBCPP_X,_LIBCPP_Y) _LIBCPP_X##_LIBCPP_
 122 #define _LIBCPP_CONCAT(_LIBCPP_X,_LIBCPP_Y) _LIBCPP_CONCAT1(_LIBCPP_X,_LIBCPP_Y)
 123 
 124 #ifndef _LIBCPP_ABI_NAMESPACE
 125 # define _LIBCPP_ABI_NAMESPACE _LIBCPP_CONCAT(__ndk,_LIBCPP_ABI_VERSION)
 126 #endif
... ...
 802 #define _LIBCPP_BEGIN_NAMESPACE_STD namespace std { inline namespace _LIBCPP_ABI_NAMESPACE {
 803 #define _LIBCPP_END_NAMESPACE_STD  } }

```
所以`_LIBCPP_BEGIN_NAMESPACE_STD`就是`namespace std { inline namespace __ndk1 {`  
`_LIBCPP_END_NAMESPACE_STD`就是`}}`  
那么被`_LIBCPP_BEGIN_NAMESPACE_STD`和`_LIBCPP_END_NAMESPACE_STD`所包裹的类就均处于namespace: `srd::__ndk1`之下, 完整的定义是`std::__ndk1::basic_string`, 例如在文件`third_party/android_ndk/sources/cxx-stl/llvm-libc++/include/string`中:
```
... ...
 529 _LIBCPP_PUSH_MACROS
 530 #include <__undef_macros>
 531 
 532 
 533 _LIBCPP_BEGIN_NAMESPACE_STD
 ... ...
```
可以看出这点.

所以, 如果不使用`use_custom_libcxx=false`的设子, 后续编译链接到`libwebrtc.a`会报错. 

---


## 从源码编译(#30987分支)
### `src/main/cpp/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.8.1)

set(CWD ${CMAKE_CURRENT_LIST_DIR})
set(WEBRTC_REPO /home/nickli/work/webrtc/30987/webrtc_android/src)
set(WEBRTC_BUILD_DIR out/DebugArm64)
set(TEST_CC_FILTER ".*gunit.cc|.*/mock/.*|.*mock_.*|.*/mocks/.*|.*fake.*|.*/test/.*|.*/tests/.*|.*_test_.*|.*unittest.*|.*/end_to_end_tests/.*|.*_test.cc|.*_tests.cc|.*_integrationtest.cc|.*_perftest.cc|.*test_utils.cc|.*testutils.cc|.*testclient.cc|.*test.c")
set(OTHER_PLATFORM_CC_FILTER ".*_chromeos.cc|.*_freebsd.cc|.*_fuchsia.cc|.*/fuchsia/.*|.*_ios.cc|.*_ios.mm|.*/ios/.*|.*_mac.cc|.*_mac.mm|.*/mac/.*|.*_openbsd.cc|.*_win.cc|.*/win/.*|.*win32.*|.*/windows/.*|.*sse.cc|.*sse2.cc|.*_mips.cc|.*_mips.c")

# add at first, avoid header search path, definition chaos
add_subdirectory(third_party)

add_definitions(-DWEBRTC_POSIX=1, -DWEBRTC_LINUX=1, -DWEBRTC_ANDROID=1)
add_definitions(-DWEBRTC_ENABLE_PROTOBUF=1)
add_definitions(-DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE)
add_definitions(-DHAVE_PTHREAD -DHAVE_SCTP -DHAVE_WEBRTC_VIDEO -DHAVE_WEBRTC_VOICE)
add_definitions(-DUSE_BUILTIN_SW_CODECS)
add_definitions(-DENABLE_RTC_EVENT_LOG)
add_definitions(-DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0)
if (${ANDROID_ABI} STREQUAL "armeabi-v7a")
    add_definitions(-DWEBRTC_USE_BUILTIN_ISAC_FIX=1 -DWEBRTC_USE_BUILTIN_ISAC_FLOAT=0)
else()
    add_definitions(-DWEBRTC_USE_BUILTIN_ISAC_FIX=0 -DWEBRTC_USE_BUILTIN_ISAC_FLOAT=1)
endif()
add_definitions(-DWEBRTC_OPUS_VARIABLE_COMPLEXITY=0)
add_definitions(-DNO_TCMALLOC=1)
if (${ANDROID_ABI} STREQUAL "arm64-v8a")
    add_definitions(-DWEBRTC_ARCH_ARM64 -DWEBRTC_HAS_NEON)
elseif (${ANDROID_ABI} STREQUAL "armeabi-v7a")
    add_definitions(-DWEBRTC_ARCH_ARM -DWEBRTC_ARCH_ARM_V7)
endif()
add_definitions(-DWEBRTC_CODEC_ILBC -DWEBRTC_CODEC_OPUS -DWEBRTC_OPUS_SUPPORT_120MS_PTIME=1 -DWEBRTC_CODEC_ISAC -DWEBRTC_CODEC_RED)
add_definitions(-DWEBRTC_INTELLIGIBILITY_ENHANCER=0 -DWEBRTC_NS_FIXED)
add_definitions(-DWEBRTC_APM_DEBUG_DUMP=0)
add_definitions(-DHAVE_NETINET_IN_H)

include_directories(
    ${WEBRTC_REPO}
    ${WEBRTC_REPO}/${WEBRTC_BUILD_DIR}/gen
    ${WEBRTC_REPO}/third_party/abseil-cpp
    ${WEBRTC_REPO}/third_party/boringssl/src/include
    ${WEBRTC_REPO}/third_party/icu/source/common
    ${WEBRTC_REPO}/third_party/jsoncpp/source/include
    ${WEBRTC_REPO}/third_party/libsrtp/config
    ${WEBRTC_REPO}/third_party/libsrtp/crypto/include
    ${WEBRTC_REPO}/third_party/libsrtp/include
    ${WEBRTC_REPO}/third_party/libyuv/include
    ${WEBRTC_REPO}/third_party/libvpx/source/libvpx
    ${WEBRTC_REPO}/third_party/opus/src/include
    ${WEBRTC_REPO}/third_party/protobuf/src
    ${WEBRTC_REPO}/third_party/usrsctp/usrsctplib
#    ${WEBRTC_REPO}/third_party/libaom/source/libaom
)

file(GLOB_RECURSE src_api
    ${WEBRTC_REPO}/api/*.cc
)
list(FILTER src_api EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_api EXCLUDE REGEX
    ".*echo_canceller3_config_json.cc|.*default_task_queue_factory_gcd.cc|.*default_task_queue_factory_stdlib.cc|.*default_task_queue_factory_win.cc|.*video_stream_decoder_create.cc"
)

file(GLOB_RECURSE src_audio
    ${WEBRTC_REPO}/audio/*.cc
)
list(FILTER src_audio EXCLUDE REGEX ${TEST_CC_FILTER})

file(GLOB_RECURSE src_call
    ${WEBRTC_REPO}/call/*.cc
)
list(FILTER src_call EXCLUDE REGEX ${TEST_CC_FILTER})
list(APPEND src_call ${WEBRTC_REPO}/call/fake_network_pipe.cc)

file(GLOB_RECURSE src_common_audio
    ${WEBRTC_REPO}/common_audio/*.c
    ${WEBRTC_REPO}/common_audio/*.cc
)
list(FILTER src_common_audio EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_common_audio EXCLUDE REGEX ${OTHER_PLATFORM_CC_FILTER})

file(GLOB_RECURSE src_common_video
    ${WEBRTC_REPO}/common_video/*.cc
)
list(FILTER src_common_video EXCLUDE REGEX ${TEST_CC_FILTER})

file(GLOB_RECURSE src_logging
    ${WEBRTC_REPO}/logging/rtc_event_log/encoder/*.cc
    ${WEBRTC_REPO}/logging/rtc_event_log/events/*.cc
    ${WEBRTC_REPO}/logging/rtc_event_log/output/*.cc
    ${WEBRTC_REPO}/logging/rtc_event_log/ice_logger.cc
    ${WEBRTC_REPO}/logging/rtc_event_log/rtc_event_log.cc
    ${WEBRTC_REPO}/logging/rtc_event_log/rtc_event_log_factory.cc
    ${WEBRTC_REPO}/logging/rtc_event_log/rtc_event_log_impl.cc
    ${WEBRTC_REPO}/logging/rtc_event_log/rtc_stream_config.cc
    ${WEBRTC_REPO}/${WEBRTC_BUILD_DIR}/gen/logging/*.cc
)
list(FILTER src_logging EXCLUDE REGEX ${TEST_CC_FILTER})

file(GLOB_RECURSE src_media
    ${WEBRTC_REPO}/media/*.cc
)
list(FILTER src_media EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_media EXCLUDE REGEX ".*fakertp.cc")

file(GLOB_RECURSE src_modules
    ${WEBRTC_REPO}/modules/*.c
    ${WEBRTC_REPO}/modules/*.cc
    ${WEBRTC_REPO}/${WEBRTC_BUILD_DIR}/gen/modules/*.cc
)
list(FILTER src_modules EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_modules EXCLUDE REGEX ${OTHER_PLATFORM_CC_FILTER})
list(FILTER src_modules EXCLUDE REGEX ${WEBRTC_REPO}/modules/video_coding/codecs/av1/.*.cc)
list(FILTER src_modules EXCLUDE REGEX 
    ".*/desktop_capture/.|.*/linux/.*|.*include/audio_device_factory.cc|.*bwe_simulations.cc|.*/audio_coding/neteq/tools/.*|.*/remote_bitrate_estimator/tools/.*|.*rnn_vad_tool.cc|.*null_aec_dump_factory.cc|.*h264_color_space.cc|.*vp9_noop.cc|.*h264_decoder_impl.cc|.*h264_encoder_impl.cc|.*/android/aaudio_.*|.*ensure_initialized.cc|.*fixed_gain_controller.cc|.*click_annotate.cc"
)

file(GLOB_RECURSE src_ortc
    ${WEBRTC_REPO}/ortc/*.cc
)
list(FILTER src_ortc EXCLUDE REGEX ${TEST_CC_FILTER})

file(GLOB_RECURSE src_p2p
    ${WEBRTC_REPO}/p2p/*.cc
)
list(FILTER src_p2p EXCLUDE REGEX ${TEST_CC_FILTER})

file(GLOB_RECURSE src_pc
    ${WEBRTC_REPO}/pc/*.cc
)
list(FILTER src_pc EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_pc EXCLUDE REGEX 
    ".*peer_connection_wrapper.cc"
)

file(GLOB_RECURSE src_rtc_base
    ${WEBRTC_REPO}/rtc_base/*.cc
)
list(FILTER src_rtc_base EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_rtc_base EXCLUDE REGEX ${OTHER_PLATFORM_CC_FILTER})
list(FILTER src_rtc_base EXCLUDE REGEX 
    ".*mac_utils.cc|.*mac_ifaddrs_converter.cc|.*test_echo_server.cc|.*task_queue_gcd.cc|.*task_queue_stdlib.cc|.*task_queue_for_test.cc|.*virtual_socket_server.cc|.*nat_socket_factory.cc|.*nat_server.cc|.*strings/json.cc"
)

file(GLOB_RECURSE src_sdk
    ${WEBRTC_REPO}/sdk/android/*.cc
    ${WEBRTC_REPO}/sdk/media_constraints.cc
)
list(FILTER src_sdk EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_sdk EXCLUDE REGEX 
    ".*null_audio.cc|.*null_media.cc|.*null_video.cc|.*/audio_device/aaudio_.*"
)

file(GLOB_RECURSE src_stats
    ${WEBRTC_REPO}/stats/*.cc
)
list(FILTER src_stats EXCLUDE REGEX ${TEST_CC_FILTER})

file(GLOB_RECURSE src_system_wrappers
    ${WEBRTC_REPO}/system_wrappers/*.cc
)
list(FILTER src_system_wrappers EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_system_wrappers EXCLUDE REGEX ${OTHER_PLATFORM_CC_FILTER})

file(GLOB_RECURSE src_video
    ${WEBRTC_REPO}/video/*.cc
)
list(FILTER src_video EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_video EXCLUDE REGEX 
    ".*_loopback.cc|.*replay.cc|.*video_analyzer.cc|.*video_loopback_main.cc|.*video_stream_decoder_impl.cc"
)

add_library(jingle_peerconnection_so SHARED
    ${src_api}
    ${src_audio}
    ${src_call}
    ${src_common_audio}
    ${src_common_video}
    ${src_logging}
    ${src_media}
    ${src_modules}
    ${src_ortc}
    ${src_p2p}
    ${src_pc}
    ${src_rtc_base}
    ${src_sdk}
    ${src_stats}
    ${src_system_wrappers}
    ${src_video}
)

target_link_libraries(jingle_peerconnection_so
    absl::optional
    absl::variant
    absl::strings
    crypto
    event
    #json
    opus
    pffft
    protobuf_lite
    rnnoise
    srtp
    ssl
    usrsctp
    vpx
    yuv
    android
    log
    GLESv2
    OpenSLES
    z
)
```
### `src/main/cpp/webrtc/third_party/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

set(ENABLE_STATIC TRUE)

add_subdirectory(abseil-cpp)
add_subdirectory(boringssl)
#add_subdirectory(jsoncpp)
add_subdirectory(libevent)
add_subdirectory(libsrtp)
add_subdirectory(libvpx)
add_subdirectory(libyuv)
add_subdirectory(opus)
add_subdirectory(pffft)
add_subdirectory(protobuf)
add_subdirectory(rnnoise)
add_subdirectory(usrsctp)
```
### `src/main/cpp/webrtc/third_party/abseil-cpp/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

set(CMAKE_INSTALL_PREFIX /tmp)
add_subdirectory(${WEBRTC_REPO}/third_party/abseil-cpp abseil-cpp)
```
### `src/main/cpp/webrtc/third_party/boringssl/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

set(ANDROID true)
add_subdirectory(${WEBRTC_REPO}/third_party/boringssl/src boringssl)
```
### `src/main/cpp/webrtc/third_party/jsoncpp/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

include_directories(
    ${WEBRTC_REPO}/third_party/jsoncpp/source/include
)

file(GLOB_RECURSE src_json
    ${WEBRTC_REPO}/third_party/jsoncpp/source/src/lib_json/*.cpp
)
list(FILTER src_json EXCLUDE REGEX ${TEST_CC_FILTER})

add_library(json STATIC
    ${src_json}
)
```
### `src/main/cpp/webrtc/third_party/libevent/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

add_definitions(-DHAVE_CONFIG_H=1)

include_directories(
    ${WEBRTC_REPO}

    ${WEBRTC_REPO}/base/third_party/libevent
    ${WEBRTC_REPO}/base/third_party/libevent/android
)

# infered from base/third_party/libevent/BUILD.gn, the base source set, plus Android source (epoll.c)
set(src_event
    ${WEBRTC_REPO}/base/third_party/libevent/buffer.c
    ${WEBRTC_REPO}/base/third_party/libevent/evbuffer.c
    ${WEBRTC_REPO}/base/third_party/libevent/evdns.c
    ${WEBRTC_REPO}/base/third_party/libevent/event.c
    ${WEBRTC_REPO}/base/third_party/libevent/event_tagging.c
    ${WEBRTC_REPO}/base/third_party/libevent/evrpc.c
    ${WEBRTC_REPO}/base/third_party/libevent/evutil.c
    ${WEBRTC_REPO}/base/third_party/libevent/http.c
    ${WEBRTC_REPO}/base/third_party/libevent/log.c
    ${WEBRTC_REPO}/base/third_party/libevent/poll.c
    ${WEBRTC_REPO}/base/third_party/libevent/select.c
    ${WEBRTC_REPO}/base/third_party/libevent/signal.c
    ${WEBRTC_REPO}/base/third_party/libevent/strlcpy.c

    ${WEBRTC_REPO}/base/third_party/libevent/epoll.c
)

add_library(event STATIC
    ${src_event}
)
```
### `src/main/cpp/webrtc/third_party/libjpeg_turbo/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

file(GLOB_RECURSE src_jpeg_turbo
        ${WEBRTC_REPO}/third_party/libjpeg_turbo/*.S
        ${WEBRTC_REPO}/third_party/libjpeg_turbo/*.c
        )
list(FILTER src_jpeg_turbo EXCLUDE REGEX ${TEST_CC_FILTER})
list(FILTER src_jpeg_turbo EXCLUDE REGEX 
        ".*ext.c|.*arith.c|.*565.c|.*bmp.c|.*djpeg.c|.*jstdhuff.c|.*altivec.c|.*bench.c|.*turbojpeg.c|.*turbojpeg-jni.c")

add_library(jpeg_turbo STATIC
        ${src_jpeg_turbo}
        )
```
### `src/main/cpp/webrtc/third_party/libsrtp/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

include_directories(
    ${WEBRTC_REPO}/third_party/boringssl/src/include
    ${WEBRTC_REPO}/third_party/libsrtp/config
    ${WEBRTC_REPO}/third_party/libsrtp/crypto/include
    ${WEBRTC_REPO}/third_party/libsrtp/include
    ${WEBRTC_REPO}/third_party/protobuf/src
)

add_definitions(
    -DHAVE_CONFIG_H
    -DOPENSSL
    -DHAVE_STDLIB_H
    -DHAVE_STRING_H
    -DHAVE_STDINT_H
    -DHAVE_INTTYPES_H
    -DHAVE_INT16_T
    -DHAVE_INT32_T
    -DHAVE_INT8_T
    -DHAVE_UINT16_T
    -DHAVE_UINT32_T
    -DHAVE_UINT64_T
    -DHAVE_UINT8_T
    -DHAVE_ARPA_INET_H
    -DHAVE_NETINET_IN_H
    -DHAVE_SYS_TYPES_H
    -DHAVE_UNISTD_H
    -DPACKAGE_STRING="libsrtp2 2.1.0-pre"
    -DPACKAGE_VERSION="2.1.0-pre"
)

file(GLOB_RECURSE src_srtp
    ${WEBRTC_REPO}/third_party/libsrtp/*.c
)
list(FILTER src_srtp EXCLUDE REGEX ${TEST_CC_FILTER})

add_library(srtp STATIC
    ${src_srtp}
)
```
### `src/main/cpp/webrtc/third_party/libvpx/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

add_subdirectory(${WEBRTC_REPO}/third_party/libyuv libyuv)
```
### `src/main/cpp/webrtc/third_party/opus/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

add_definitions(-DOPUS_BUILD -DOPUS_EXPORT= -DHAVE_LRINT -DHAVE_LRINTF -DVAR_ARRAYS -DOPUS_WILL_BE_SLOW -DFIXED_POINT)

include_directories(
    ${WEBRTC_REPO}/third_party/opus/src/celt
    ${WEBRTC_REPO}/third_party/opus/src/include
    ${WEBRTC_REPO}/third_party/opus/src/silk
    ${WEBRTC_REPO}/third_party/opus/src/silk/fixed
)

set(OPUS_SRC_FILTER ".*opus_custom_demo.c|.*mlp_train.c|.*opus_compare.c|.*opus_demo.c|.*repacketizer_demo.c")
file(GLOB src_opus_arm64
    ${WEBRTC_REPO}/third_party/opus/src/celt/*.c
    ${WEBRTC_REPO}/third_party/opus/src/silk/*.c
    ${WEBRTC_REPO}/third_party/opus/src/silk/fixed/*.c
    ${WEBRTC_REPO}/third_party/opus/src/src/*.c
)
list(FILTER src_opus_arm64 EXCLUDE REGEX ${OPUS_SRC_FILTER})

add_library(opus STATIC
    ${src_opus_arm64}
)
```
### `src/main/cpp/webrtc/third_party/pffft/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

include_directories(
    ${WEBRTC_REPO}/third_party/pffft/src
)

file(GLOB src_pffft
    ${WEBRTC_REPO}/third_party/pffft/src/pffft.c
)

add_library(pffft STATIC
    ${src_pffft}
)
```
### `src/main/cpp/webrtc/third_party/protobuf/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

add_definitions(-DHAVE_PTHREAD)

include_directories(
    ${WEBRTC_REPO}/third_party/protobuf/src
)

# extracted from `protobuf_lite_sources` of third_party/protobuf/BUILD.gn
# python extract_src_from_gn.py third_party/protobuf/BUILD.gn protobuf_lite_sources '    ${WEBRTC_REPO}/third_party/protobuf/'
set(src_protobuf_lite
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/any_lite.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/arena.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/arenastring.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/extension_set.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/generated_enum_util.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/generated_message_table_driven_lite.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/generated_message_util.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/implicit_weak_message.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/io/coded_stream.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/io/io_win32.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/io/strtod.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/io/zero_copy_stream.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/io/zero_copy_stream_impl.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/io/zero_copy_stream_impl_lite.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/message_lite.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/repeated_field.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/bytestream.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/common.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/int128.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/status.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/statusor.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/stringpiece.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/stringprintf.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/structurally_valid.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/strutil.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/stubs/time.cc
    ${WEBRTC_REPO}/third_party/protobuf/src/google/protobuf/wire_format_lite.cc
)

add_library(protobuf_lite STATIC
    ${src_protobuf_lite}
)
```
### `src/main/cpp/webrtc/third_party/rnnoise/CMakeLists.txt`
```
cmake_minimum_required(VERSION 3.4.1)

include_directories(
    ${WEBRTC_REPO}
)

file(GLOB_RECURSE src_rnnoise
    ${WEBRTC_REPO}/third_party/rnnoise/src/*.cc
)
list(FILTER src_rnnoise EXCLUDE REGEX ${TEST_CC_FILTER})

add_library(rnnoise STATIC
    ${src_rnnoise}
)
```

## 杂
### 关于gclient sync的网络缓慢的问题
推荐的方式:
1. 购买一个阿里云的ECS实例, 地区: **美国硅谷**
2. 选择付费方式为: **按量付费**
3. 选择硬盘空间为: **至少80GB**
4. 为了防止过量支付配置费用, 可以考虑: **自动释放**
5. 在该实例上进行同步, 然后打包并传输到本地解压.

### 签出30987分支
```
$ cd src/
$ git checkout -b 30987 04c1b445019e10e54b96f70403d25cc54215faf3
Switched to a new branch '30987'

$ cd -
## 一定不要用--nohooks!!!
$ gclient sync -D
Running depot tools as root is sad.
Syncing projects: 100% (261/261), done

# 如果需要传回本地, 则对源码进行打包, 否则不需要执行以下命令
$ cd ..
$ tar cvfz webrtc_android.tar.gz webrtc_android/
```

### 关于在代理机上配置文件服务器和获取代码
1. 可以配置一个Apache2的文件服务器, 安装apache2:
```
$ sudo apt-get install apache2
```

修改配置文件`/etc/apache2/sites-enabled/000-default.conf`:
```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        <Directory "/root">
                Options Indexes FollowSymLinks Includes ExecCGI
                AllowOverride All
                Order allow,deny
                Allow from all
                Require all granted
        </Directory>
        DocumentRoot /root

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

2. 在阿里云的ECS主机安全组配置中新增一个允许访问80端口的安全组规则.

3. 本地通过如下命令获取文件:
```
$ axel -n 100 http://<ESC2实例的公网IP地址>/webrtc_android.tar.gz
```
