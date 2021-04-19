# Build GStreamer with cerbero

## 参考
* [Building from source using Cerbero](https://gstreamer.freedesktop.org/documentation/installing/building-from-source-using-cerbero.html?gi-language=c)

## 命令
```
$ mkdir /opt/gstreamer
$ cd /opt/gstreamer
$ git clone https://gitlab.freedesktop.org/gstreamer/cerbero
$ cd cerbero/
$ git checkout 1.18
$ ./cerbero-uninstalled -c config/cross-android-arm64.cbc bootstrap

--- < OUTPUT > ---
Install prefix will be /opt/gstreamer/cerbero/build/dist/android_arm64
Install prefix will be /opt/gstreamer/cerbero/build/build-tools
Downloading https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip
--2020-09-20 16:00:59--  https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip
Resolving dl.google.com (dl.google.com)... 203.208.43.97
Connecting to dl.google.com (dl.google.com)|203.208.43.97|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1043332542 (995M) [application/zip]
Saving to: ‘/home/liyang/.cache/cerbero-sources/android-ndk-r21-linux-x86_64.zip’

     0K ........ ........ ........ ........  3% 11.0M 88s
 32768K ........ ........ ........ ........  6% 11.0M 85s
 65536K ........ ........ ........ ........  9% 11.1M 82s
 98304K ........ ........ ........ ........ 12% 10.4M 80s
131072K ........ ........ ........ ........ 16% 11.1M 76s
163840K ........ ........ ........ ........ 19% 11.2M 73s
196608K ........ ........ ........ ........ 22% 11.1M 70s
229376K ........ ........ ........ ........ 25% 11.1M 67s
262144K ........ ........ ........ ........ 28% 11.0M 64s
294912K ........ ........ ........ ........ 32% 10.3M 62s
327680K ........ ........ ........ ........ 35% 11.1M 59s
360448K ........ ........ ........ ........ 38% 11.1M 56s
393216K ........ ........ ........ ........ 41% 10.9M 53s
425984K ........ ........ ........ ........ 45% 11.1M 50s
458752K ........ ........ ........ ........ 48% 11.1M 47s
491520K ........ ........ ........ ........ 51% 11.1M 44s
524288K ........ ........ ........ ........ 54% 10.5M 41s
557056K ........ ........ ........ ........ 57% 11.0M 38s
589824K ........ ........ ........ ........ 61% 11.1M 35s
622592K ........ ........ ........ ........ 64% 11.1M 32s
655360K ........ ........ ........ ........ 67% 10.5M 29s
688128K ........ ........ ........ ........ 70% 11.1M 27s
720896K ........ ........ ........ ........ 73% 10.9M 24s
753664K ........ ........ ........ ........ 77% 11.1M 21s
786432K ........ ........ ........ ........ 80% 11.1M 18s
819200K ........ ........ ........ ........ 83% 10.5M 15s
851968K ........ ........ ........ ........ 86% 11.1M 12s
884736K ........ ........ ........ ........ 90% 11.1M 9s
917504K ........ ........ ........ ........ 93% 11.0M 6s
950272K ........ ........ ........ ........ 96% 11.1M 3s
983040K ........ ........ ........ ........ 99% 11.1M 0s
1015808K ..                                 100% 11.2M=91s

2020-09-20 16:02:30 (11.0 MB/s) - ‘/home/liyang/.cache/cerbero-sources/android-ndk-r21-linux-x86_64.zip’ saved [1043332542/1043332542]
Unpacking /home/liyang/.cache/cerbero-sources/android-ndk-r21-linux-x86_64.zip in /opt/gstreamer/cerbero/build/android-ndk-21
Running command 'sudo apt-get install autotools-dev automake autoconf libtool g++ autopoint make cmake bison flex nasm pkg-config libxv-dev libx11-dev libx11-xcb-dev libpulse-dev python3-dev gettext build-essential pkg-config libxext-dev libxi-dev x11proto-record-dev libxrender-dev libgl1-mesa-dev libxfixes-dev libxdamage-dev libxcomposite-dev libasound2-dev build-essential gperf wget libxtst-dev libxrandr-dev libglu1-mesa-dev libegl1-mesa-dev git xutils-dev intltool ccache python3-setuptools libssl-dev'
ERROR: ld.so: object 'libproxychains.so.3' from LD_PRELOAD cannot be preloaded (cannot open shared object file): ignored.
Reading package lists... Done
Building dependency tree       
Reading state information... Done
autoconf is already the newest version (2.69-11.1).
automake is already the newest version (1:1.16.1-4ubuntu6).
... ...
libx11-dev is already the newest version (2:1.6.9-2ubuntu1.1).
libx11-xcb-dev is already the newest version (2:1.6.9-2ubuntu1.1).
The following packages were automatically installed and are no longer required:
  arduino-core avr-libc avrdude binutils-avr gcc-avr libfprint-2-tod1 libftdi1 libftdi1-2 libhidapi-hidraw0 libhidapi-libusb0 libjaylink0 libjim0.79 libjna-java libjna-jni libllvm9
  libllvm9:i386 librxtx-java libusb-0.1-4
Use 'sudo apt autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 26 not upgraded.
Building the following recipes: m4 autoconf gettext-m4 automake libtool pkg-config ninja meson orc-tool libffi zlib gettext-tools glib-tools intltool-m4
Building using 64 job(s) with the following job subdivisions: compile: 3, install: 1, extract: 1, fetch: 1, and 58 general job(s)
[(1/14) ninja -> built]
[(2/14) gettext-m4 -> built]
[(3/14) meson -> built]
[(4/14) intltool-m4 -> built]
[(5/14) zlib -> built]
[(6/14) libffi -> built]
[(7/14) orc-tool -> built]
[(8/14) pkg-config -> built]
[(9/14) m4 -> built]
[(10/14) autoconf -> built]
[(11/14) automake -> built]
[(12/14) libtool -> built]
[(13/14) gettext-tools -> built]
[(14/14) glib-tools -> built]
All done!
--- < OUTPUT End > ---

$ proxychains ./cerbero-uninstalled -c config/cross-android-arm64.cbc package gstreamer-1.0
--- < OUTPUT > ---

Running command ['git', 'am', '--ignore-whitespace', '/opt/gstreamer/cerbero/recipes/openssl/0001-Load-ca-certificate.crt-from-PREFIX-etc-ssl-on-macOS.patch']
Applying: Load ca-certificate.crt from PREFIX/etc/ssl on macOS and Windows
Running command ['git', 'am', '--ignore-whitespace', '/opt/gstreamer/cerbero/recipes/openssl/0001-windows-makefile.tmpl-Generate-and-install-pkgconfig.patch']
Applying: windows-makefile.tmpl: Generate and install pkgconfig files
Running command ['git', 'am', '--ignore-whitespace', '/opt/gstreamer/cerbero/recipes/openssl/0002-windows-makefile.tmpl-Fix-ONECORE-build.patch']
Applying: windows-makefile.tmpl: Fix ONECORE build
Running command ['git', 'am', '--ignore-whitespace', '/opt/gstreamer/cerbero/recipes/openssl/0003-windows-makefile.tmpl-Do-not-prefix-import-libraries.patch']
Applying: windows-makefile.tmpl: Do not prefix import libraries with 'lib'
Running command ['git', 'am', '--ignore-whitespace', '/opt/gstreamer/cerbero/recipes/openssl/0001-crypto-win-Don-t-use-disallowed-APIs-on-UWP.patch']
Applying: crypto/win: Don't use disallowed APIs on UWP
Running command ['git', 'am', '--ignore-whitespace', '/opt/gstreamer/cerbero/recipes/openssl/0002-win-onecore-Build-with-APPCONTAINER-for-UWP-compat.patch']
Applying: win-onecore: Build with /APPCONTAINER for UWP compat

-----> Contents of /opt/gstreamer/cerbero/build/logs/android_arm64/openssl-configure.log:
Running command 'sh -c 'perl ./Configure --prefix=/opt/gstreamer/cerbero/build/dist/android_arm64 --libdir=lib  no-makedepend  shared android-arm64''
no NDK aarch64-linux-android-gcc on $PATH at (eval 10) line 124.
Configuring OpenSSL version 1.1.1g (0x1010107fL) for android-arm64
Using os-specific seed configuration


Recipe 'openssl' failed at the build step 'configure'
Command Error: Running ['sh', '-c', 'perl ./Configure --prefix=/opt/gstreamer/cerbero/build/dist/android_arm64 --libdir=lib  no-makedepend  shared android-arm64'] returned 2
Output in logfile /opt/gstreamer/cerbero/build/logs/android_arm64/openssl-configure.log
Select an action to proceed:
[0] Enter the shell
[1] Rebuild the recipe from scratch
[2] Rebuild starting from the failed step
[3] Skip recipe
[4] Abort
...


```

这是由于openssl.recipe规则对openssl的Android版本编译存在一些问题, 需要稍作修改:  
```
diff --git a/recipes/openssl.recipe b/recipes/openssl.recipe
index e6305cce..15d72f4c 100644
--- a/recipes/openssl.recipe
+++ b/recipes/openssl.recipe
@@ -176,7 +176,7 @@ class Recipe(recipe.Recipe):
                 raise FatalError('Configured Perl {!r} is {} which is too old, {}'
                                  ''.format(perl, found, m))
         # OpenSSL guesses the libdir incorrectly on x86_64
-        config_sh = 'perl ./Configure --prefix=' + self.config.prefix + \
+        config_sh = 'pwd; export ANDROID_NDK_HOME=`pwd`/../../../android-ndk-21/; export PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:$PATH; perl ./Configure -D__ANDROID_API__=29 --prefix=' + self.config.prefix + \
             ' --libdir=lib' + self.config.lib_suffix + '  no-makedepend '
         if self.config.target_platform == Platform.IOS:
             # Note: disable 'no-devcryptoeng' when we finally target the
```

然后继续:
```
$ proxychains ./cerbero-uninstalled -c config/cross-android-arm64.cbc package gstreamer-1.0
--- < OUTPUT > ---

Install prefix will be /opt/gstreamer/cerbero/build/dist/android_arm64
Building the following recipes: gnustl libffi zlib proxy-libintl libiconv glib gstreamer-1.0 libogg libpng pixman expat bzip2 freetype fontconfig cairo fribidi harfbuzz pango libvorbis libtheora libvisual orc opus graphene libjpeg-turbo tremor gst-plugins-base-1.0 gst-shell speex tiff gdk-pixbuf libxml2 ca-certificates openssl glib-networking libpsl sqlite3 libsoup mpg123 lame wavpack flac taglib libvpx libdv gst-plugins-good-1.0 libass libkate openh264 librtmp libsrtp libdca libmms libnice soundtouch vo-aacenc libcroco librsvg openjpeg spandsp webrtc-audio-processing sbc ladspa srt zbar vulkan-android gst-plugins-bad-1.0 a52dec opencore-amr x264 gst-plugins-ugly-1.0 ffmpeg gst-libav-1.0 json-glib gst-rtsp-server-1.0 gst-devtools-1.0 gst-editing-services-1.0 gst-android-1.0
Building using 64 job(s) with the following job subdivisions: compile: 3, install: 1, extract: 1, fetch: 1, and 58 general job(s)
[(1/78) gnustl -> already built]
[(2/78) zlib -> already built]
[(3/78) proxy-libintl -> already built]
[(4/78) ca-certificates -> already built]
[(5/78) libffi -> built]
[(7/78) libpng -> built]
[(8/78) pixman -> built]ibdca CONFIGURE: libiconv, libogg, libjpeg-turbo, libvisual, libxml2, vo-aacenc, sbc, libmms, freetype, openjpeg COMPILE: openssl, webrtc-audio-processing, expa[(11/78) expat -> built]
... ...
[(76/78) gst-devtools-1.0 -> built]
[(77/78) gst-editing-services-1.0 -> built]
[(78/78) gst-android-1.0 -> built]
All done!
-----> Creating package for gstreamer-1.0
WARNING: No specific packager available for the distro version android_21_lollipop, using generic packager for distro android
-----> Package successfully created in /opt/gstreamer/cerbero/gstreamer-1.0-android-arm64-1.19.0.1-runtime.tar.xz /opt/gstreamer/cerbero/gstreamer-1.0-android-arm64-1.19.0.1.tar.xz
```

编译完成.



## 问题
```
-----> Contents of /opt/gstreamer/cerbero/build/logs/linux_x86_64/openjpeg-extract.log:
-----> Extracting tarball to /opt/gstreamer/cerbero/build/sources/linux_x86_64/openjpeg-2.3.1/_builddir
Unpacking /home/liyang/.cache/cerbero-sources/openjpeg-2.3.1/v2.3.1.tar.gz in /opt/gstreamer/cerbero/build/sources/linux_x86_64
Running command ['git', 'init']
Reinitialized existing Git repository in /opt/gstreamer/cerbero/build/sources/linux_x86_64/openjpeg-2.3.1/.git/
Running command ['git', 'config', 'user.email']
liyangzmx@163.com
Running command ['git', 'config', 'user.name']
Li Yang
Running command ['git', 'add', '--force', '-A', '.']
Running command ['git', 'commit', '-m', 'Initial commit']
On branch master
nothing to commit, working tree clean


Recipe 'openjpeg' failed at the build step 'extract'
Select an action to proceed:
[0] Enter the shell
[1] Rebuild the recipe from scratch
[2] Rebuild starting from the failed step
[3] Skip recipe
[4] Abort
Interrupted
```

删除`/opt/gstreamer/cerbero/build/sources/linux_x86_64/openjpeg-2.3.1/.git/`后重试.


```
[(4/78) libffi -> built]
-----> Contents of /opt/gstreamer/cerbero/build/logs/android_arm64/taglib-fetch.log:
-----> Checksum failed, tarball /home/liyang/.cache/cerbero-sources/taglib-1.11.1/taglib-1.11.1.tar.gz moved to /home/liyang/.cache/cerbero-sources/taglib-1.11.1/taglib-1.11.1.tar.gz.failed-checksum


Recipe 'taglib' failed at the build step 'fetch'
Fatal Error: Checksum for /home/liyang/.cache/cerbero-sources/taglib-1.11.1/taglib-1.11.1.tar.gz is '2a90663dfed363dd088583f6d82bacfdec1f7c9cd7dd5a3b3ef4d4bcdcf8e44a' instead of 'b6d1a5a610aae6ff39d93de5efd0fdc787aa9e9dc1e7026fa4c961b26563526b'
Select an action to proceed:
[0] Enter the shell
[1] Rebuild the recipe from scratch
[2] Rebuild starting from the failed step
[3] Skip recipe
[4] Abort
```
删除`rm -rf /home/liyang/.cache/cerbero-sources/taglib-1.11.1/`后重试.


