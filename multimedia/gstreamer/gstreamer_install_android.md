# 在Ubuntu上安装GStreamer For Android并编译demo

## 参考资料
* [Building from source using Cerbero](https://gstreamer.freedesktop.org/documentation/installing/building-from-source-using-cerbero.html?gi-language=c)  
* [Installing for Android development](https://gstreamer.freedesktop.org/documentation/installing/for-android-development.html?gi-language=c)

## 采用预编译的库
从[prebuilt binaries](https://gstreamer.freedesktop.org/data/pkg/android/)可以下载到预编译的二进制库文件, 对于app, 这样做可以节省不少的时间, 以[gstreamer-1.0-android-universal-1.18.0.tar.xz](https://gstreamer.freedesktop.org/data/pkg/android/1.18.0/gstreamer-1.0-android-universal-1.18.0.tar.xz)为例:
```
$ mkdir -p /opt/work/gstreamer
$ cd /opt/work/gstreamer/
$ wget https://gstreamer.freedesktop.org/data/pkg/android/1.18.0/gstreamer-1.0-android-universal-1.18.0.tar.xz
$ cd gstreamer-1.0-android-universal-1.18.0
$ tar xvf ../gstreamer-1.0-android-universal-1.18.0.tar.xz
$ pwd
/opt/work/gstreamer/gstreamer-1.0-android-universal-1.18.0
$ ls arm64/share/gst-android/ndk-build/
androidmedia  fontconfig  gstreamer-1.0.mk  gstreamer_android-1.0.c.in  GStreamer.java  gstreamer_prebuilt.mk  plugins.mk  tools  tools.mk
```

下载demo:
```
mkdir -p /opt/gstreamer/
cd /opt/gstreamer/
git clone https://gitlab.freedesktop.org/gstreamer/gst-docs
```

然后使用`Android Studio`打开工程:`gst-docs/examples/tutorials/android/`, 然后在`~/.gradle/gradle.properties`中添加:
```
gstAndroidRoot=/opt/work/gstreamer/gstreamer-1.0-android-universal-1.18.0/
```

然后编译工程即可.

## 采用源码编译的方式 - Cerbero(以ARM64为例)
拉取库:
```
$ cd /opt/work/
$ git clone https://gitlab.freedesktop.org/gstreamer/cerbero
$ cd cerbero/
$ ./cerbero-uninstalled -c config/cross-android-arm64.cbc bootstrap
Install prefix will be /opt/work/cerbero/build/dist/android_arm64
Install prefix will be /opt/work/cerbero/build/build-tools
WARNING: Could not recover status
Downloading https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip
--2020-09-22 10:49:01--  https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip
正在解析主机 dl.google.com (dl.google.com)... 203.208.50.97
正在连接 dl.google.com (dl.google.com)|203.208.50.97|:443... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度： 1043332542 (995M) [application/zip]
正在保存至: “/home/<NO_NAME>/.cache/cerbero-sources/android-ndk-r21-linux-x86_64.zip”

     0K ........ ........ ........ ........  3% 6.61M 2m26s
 32768K ........ ........ ........ ........  6% 7.39M 2m13s
... ...
您希望继续执行吗？ [Y/n] 
// 需要安装依赖, 此处需要输入密码以继续...
... ...
正在处理用于 man-db (2.9.1-1) 的触发器 ...
Building the following recipes: m4 autoconf gettext-m4 automake libtool pkg-config ninja meson orc-tool libffi zlib glib-tools intltool-m4
Building using 32 job(s) with the following job subdivisions: compile: 3, install: 1, extract: 1, fetch: 1, and 26 general job(s)
// 获取并编译所依赖的库
[(1/13) ninja -> built]
[(2/13) m4 -> built]
[(3/13) gettext-m4 -> built]
[(4/13) meson -> built]
[(5/13) autoconf -> built]
[(6/13) pkg-config -> built]
[(7/13) libffi -> built]
[(8/13) zlib -> built]
[(9/13) automake -> built]
[(10/13) libtool -> built]
[(11/13) orc-tool -> built]
[(12/13) intltool-m4 -> built]
[(13/13) glib-tools -> built]
All done!

$ ./cerbero-uninstalled -c config/cross-android-arm64.cbc package gstreamer-1.0
Install prefix will be /opt/work/cerbero/build/dist/android_arm64
WARNING: Could not recover status
Building the following recipes: gnustl libffi zlib proxy-libintl libiconv glib gstreamer-1.0 libogg libpng pixman expat bzip2 freetype fontconfig cairo fribidi harfbuzz pango libvorbis libtheora orc opus graphene libjpeg-turbo tremor gst-plugins-base-1.0 gst-shell speex tiff gdk-pixbuf libxml2 ca-certificates openssl glib-networking libpsl sqlite3 libsoup mpg123 lame wavpack flac taglib libvpx libdv gst-plugins-good-1.0 libass libkate openh264 librtmp libsrtp libdca libmms libnice soundtouch vo-aacenc libcroco librsvg openjpeg spandsp webrtc-audio-processing sbc ladspa srt zbar vulkan-android gst-plugins-bad-1.0 a52dec opencore-amr x264 gst-plugins-ugly-1.0 ffmpeg gst-libav-1.0 json-glib gst-rtsp-server-1.0 gst-devtools-1.0 gst-editing-services-1.0 gst-android-1.0
Building using 32 job(s) with the following job subdivisions: compile: 3, install: 1, extract: 1, fetch: 1, and 26 general job(s)
[(1/77) gnustl -> built]
[(2/77) zlib -> built]
... ...
-----> Contents of /opt/work/cerbero/build/logs/android_arm64/openssl-configure.log:
Running command 'sh -c 'perl ./Configure --prefix=/opt/work/cerbero/build/dist/android_arm64 --libdir=lib  no-makedepend  shared android-arm64''
no NDK aarch64-linux-android-gcc on $PATH at (eval 10) line 124.
Configuring OpenSSL version 1.1.1g (0x1010107fL) for android-arm64
Using os-specific seed configuration


Recipe 'openssl' failed at the build step 'configure'
Command Error: Running ['sh', '-c', 'perl ./Configure --prefix=/opt/work/cerbero/build/dist/android_arm64 --libdir=lib  no-makedepend  shared android-arm64'] returned 2
Output in logfile /opt/work/cerbero/build/logs/android_arm64/openssl-configure.log
Select an action to proceed:
[0] Enter the shell
[1] Rebuild the recipe from scratch
[2] Rebuild starting from the failed step
[3] Skip recipe
[4] Abort
// 输入4中止编译
4
***** Error running 'package' command
```

对于上面的报错不要慌张, 既然编译`openssl`遇到了错误, 先参考`OpenSSL`官方的文档[OpenSSL_1_1_1-stable/NOTES.ANDROID](https://github.com/openssl/openssl/blob/OpenSSL_1_1_1-stable/NOTES.ANDROID), 可以看到如下描述:
```
... ...
For example,
 to compile for Android 10 arm64 with a side-by-side NDK r20.0.5594570

	export ANDROID_NDK_HOME=/home/whoever/Android/android-sdk/ndk/20.0.5594570
	PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:$PATH
	./Configure android-arm64 -D__ANDROID_API__=29
	make

 Older versions of the NDK have GCC under their common prebuilt tools directory, so the bin path
 will be slightly different. EG: to compile for ICS on ARM with NDK 10d:

    export ANDROID_NDK_HOME=/some/where/android-ndk-10d
    PATH=$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin:$PATH
    ./Configure android-arm -D__ANDROID_API__=14
    make
... ...
```

又因为`cerbero`编译`openssl`的规则在文件`recipes/openssl.recipe`中, 因此做如下调整(假设NDK路径:`~/Android/Sdk/ndk/21.3.6528147/`):
```
diff --git a/recipes/openssl.recipe b/recipes/openssl.recipe
index e6305cce..6d6b38b9 100644
--- a/recipes/openssl.recipe
+++ b/recipes/openssl.recipe
@@ -176,7 +176,9 @@ class Recipe(recipe.Recipe):
                 raise FatalError('Configured Perl {!r} is {} which is too old, {}'
                                  ''.format(perl, found, m))
         # OpenSSL guesses the libdir incorrectly on x86_64
-        config_sh = 'perl ./Configure --prefix=' + self.config.prefix + \
+        env_settings = 'ANDROID_NDK_HOME=build/android-ndk-21/ '
+        env_settings += 'PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:$PATH '
+        config_sh = env_settings + 'perl ./Configure --prefix=' + self.config.prefix + \
             ' --libdir=lib' + self.config.lib_suffix + '  no-makedepend '
         if self.config.target_platform == Platform.IOS:
             # Note: disable 'no-devcryptoeng' when we finally target the
```

然后重新编译:
```
$ ./cerbero-uninstalled -c config/cross-android-arm64.cbc package gstreamer-1.0
... ...
[(11/77) bzip2 -> already built]
[(12/77) freetype -> already built]
[(13/77) libogg -> built]
[(14/77) fontconfig -> built]
// 此处表示opessl已编译完成
[(15/77) openssl -> built]
... ...
[(76/77) gst-shell -> already built]
[(77/77) gst-android-1.0 -> already built]
All done!
... ...
```

对于Android arm64的情况, 其输出路径为: `build/dist/android_arm64/`, 该路径中的主要部分会被打包成: `gstreamer-1.0-android-arm64-1.19.0.1.tar.xz`和`gstreamer-1.0-android-arm64-1.19.0.1-runtime.tar.xz`, 前者用于编译运行时的app, 后者用于集成到Anroid ROM的运行环境, 但实际上App的demo由于直接引用了`build/dist/android_arm64/share/gst-android/ndk-build/gstreamer-1.0.mk`, 所以不需要runtime的包了.

对于源码编译的情形, Android的demo编译中, `~/.gradle/gradle.properties`文件内容应做做调整, 首先需要对`build/dist/android_arm64/`进行重命名:
```
$ cd /opt/work/cerbero/
$ mkdir build/dist/android/
$ mv build/dist/android_arm64/ build/dist/android/arm64/
```

修改`~/.gradle/gradle.properties`文件:
```
gstAndroidRoot=/opt/work/cerbero/build/dist/android/
```

然后修改Android demo中的`examples/tutorials/android/android-tutorial-5/build.gradle`文件:
```
android {
    ... ...

    defaultConfig {
        ... ...

        externalNativeBuild {
            ndkBuild {
                ... ...
                // All archs except MIPS and MIPS64 are supported
                // abiFilters  'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
                abiFilters 'arm64-v8a'
            }
        }
    }
    ... ...
}
```

待续...
<!-- 
Sync系重新编译即可.

补充:
如果遇到报错, 在`gst-docs/examples/tutorials/android/`目录下尝试:
```
Android NDK: Module tutorial-1 depends on undefined modules: gstreamer_android    
Open File
Android NDK: Module tutorial-1 depends on undefined modules: gstreamer_android    
Open File
```

手动设置下项目的NDK路径. -->