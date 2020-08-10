# OpenSLES

## 关于
虽然Google在[Android Developers > NDK > 指南 > OpenSL ES](https://developer.android.com/ndk/guides/audio/opensl)中推荐使用Oboe, 但依然保留了原有的文档: [向您的应用添加 OpenSL ES](https://developer.android.com/ndk/guides/audio/opensl/getting-started)以供参考, 并提供了两个参考:
* [audio-echo](https://github.com/android/ndk-samples/tree/master/audio-echo)
* [native-audio](https://github.com/android/ndk-samples/tree/master/native-audio)

## 头文件
```
#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>
```

## CMakeLists.txt
```
target_link_libraries( # Specifies the target library.
    native-lib
    ...
    OpenSLES
    ...
)
```

其它信息参考: 