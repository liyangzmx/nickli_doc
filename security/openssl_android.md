# OpenSSL in Android

## 说明
* 使用**Setenv-android.sh**的方式已经**过时**了
* 使用NDK中的**build/tools/make-standalone-toolchain.sh**生成工具链的方式也过时了
* 请仔细阅读[**NOTES.ANDROID**](https://github.com/openssl/openssl/blob/OpenSSL_1_1_1-stable/NOTES.ANDROID), 不要参考第三方的博客等

## 使用NDK编译
下载源码:
```
wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz
```

解压源码:
```
tar xvf openssl-1.1.1g.tar.gz
cd openssl-1.1.1g/
```

下载脚本:
```
wget https://wiki.openssl.org/images/7/70/Setenv-android.sh
```

设置环境变量:
```
export ANDROID_NDK_HOME=~/Android/Sdk/ndk/21.3.6528147/
export PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
```

配置/编译(**arm64**):
```
./Configure android-arm64 -D__ANDROID_API__=29
make -j8
```

配置/编译(**arm64**):
```
./Configure android-arm -D__ANDROID_API__=29
make -j8
```

## Android APK集成
拷贝库到App的项目目录下:
```
cp libssl.so.1.1 $APP_PROJECT_PATH/app/libs/arm64-v8a/libssl.so
cp libcrypto.so.1.1 $APP_PROJECT_PATH/app/libs/arm64-v8a/libcrypto.so
cp libssl.so.1.1 $APP_PROJECT_PATH/app/libs/armeabi-v7a/libssl.so
cp libcrypto.so.1.1 $APP_PROJECT_PATH/app/libs/armeabi-v7a/libcrypto.so
cp -rf include/ $APP_PROJECT_PATH/app/src/main/cpp/
```

添加如下内容到CMakeLists.txt(它通常在: **app/src/main/cpp/CMakeLists.txt**):
```
add_library(crypto_lib SHARED IMPORTED)
set_target_properties(
    crypto_lib
    PROPERTIES IMPORTED_LOCATION
    ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libcrypto.so
)

add_library(ssl_lib SHARED IMPORTED)
set_target_properties(
    ssl_lib
    PROPERTIES IMPORTED_LOCATION
    ${CMAKE_CURRENT_LIST_DIR}/../../../libs/${ANDROID_ABI}/libssl.so
)

include_directories(${CMAKE_CURRENT_LIST_DIR}/include/)
... ...
target_link_libraries( 
    native-lib
    ... ...
    crypto_lib
    ssl_lib
    ...
)
```

检查并调整build.gradle(**app**):
```
android {
    ...
    defaultConfig {
        ...
        externalNativeBuild {
            cmake {
                cppFlags ""
            }
        }
        ndk {
            abiFilters 'arm64-v8a'
        }
    }
    sourceSets {
        main {
            jniLibs.srcDirs = ['libs/']
        }
    }
    externalNativeBuild {
        cmake {
            path "src/main/cpp/CMakeLists.txt"
            version "3.10.2"
        }
    }
}
...
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    ...
}
```

**native-lib.c**中使用**HMAC()**的例子:
```
#include <openssl/hmac.h>
extern "C"
JNIEXPORT jbyteArray JNICALL
Java_com_wyze_libcurljni_MainActivity_HMAC(JNIEnv *env, jobject thiz, jbyteArray input_) {
    // TODO: implement HMAC()
    const char *key = "5fd6s4gs8f7s1dfv23sdf4ag65rg4arhb4fb1f54bgf5gbvf1534as";
    jbyte *value = env->GetByteArrayElements(input_, NULL);
    size_t value_Len = env->GetArrayLength(input_);

    unsigned int result_len;
    unsigned char result[EVP_MAX_MD_SIZE];
    char buff[EVP_MAX_MD_SIZE];
    char hex[EVP_MAX_MD_SIZE];

    HMAC(EVP_sha1(), key, strlen(key), (unsigned char *) value, value_Len, result, &result_len);
    strcpy(hex, "");
    for (int i = 0; i != result_len; i++) {
        sprintf(buff, "%02x", result[i]);
        strcat(hex, buff);
    }
    env->ReleaseByteArrayElements(input_, value, 0);
    jbyteArray signature = env->NewByteArray(strlen(hex));
    env->SetByteArrayRegion(signature, 0, strlen(hex), (jbyte *) hex);
    return signature;
}
```

对应的Java层例子:
```
public native byte[] HMAC(byte[] input);
...
@Override
    protected void onCreate(Bundle savedInstanceState) {
        TextView tv = findViewById(R.id.sample_text);
        String inputStr = "Hello";
        tv.setText(new String(HMAC(inputStr.getBytes())));
    }
```

检查**System.loadLibrary**():
```
static {
    System.loadLibrary("crypto");
    System.loadLibrary("ssl");
    System.loadLibrary("native-lib");
}
```
**注意:** 特别注意上述库的**加载顺序!!!**