# 编译gst-rtsp-server

## 拉取代码
```
$ git clone https://github.com/GStreamer/gst-rtsp-server.git
```

## 安装meson并编译
```
$ sudo apt-get install meson
$ cd gst-rtsp-server/
$ meson build
The Meson build system
Version: 0.53.2
Source dir: /home/nickli/desktop/gstreamer/gst-rtsp-server
Build dir: /home/nickli/desktop/gstreamer/gst-rtsp-server/build
Build type: native build

meson.build:1:0: ERROR: Meson version is 0.53.2 but project requires >= 0.54

A full log can be found at /home/nickli/desktop/gstreamer/gst-rtsp-server/build/meson-logs/meson-log.txt
```

原因: 不要用Ubuntu的源, 改用pip3安装:
```
$ sudo apt-get remove meson
$ pip3 install meson
```

在`~/.bashrc`中添加:
```
export PATH=$PATH:~/.local/bin/
```
然后生效环境变量:
```
$ source ~/.bashrc
```

执行编译:
```
$ meson build
... ...
Dependency gstreamer-1.0 found: NO found 1.16.2 but need: '>= 1.19.0'
Found CMake: /usr/bin/cmake (3.16.3)
Run-time dependency gstreamer-1.0 found: NO (tried pkgconfig and cmake)
Looking for a fallback subproject for the dependency gstreamer-1.0

meson.build:138:0: ERROR: Subproject directory not found and gstreamer.wrap file not found

A full log can be found at /home/nickli/desktop/gstreamer/gst-rtsp-server/build/meson-logs/meson-log.txt
```

Ubuntu源中的meson版本过低, 切换gst-rtsp-server的分支:
```
$ git checkout 1.16.0
$ meson build
... ...
Header <gst/gstconfig.h> has symbol "GST_DISABLE_GST_DEBUG" with dependency gstreamer-1.0: NO 
Message: GStreamer debug system is enabled
Program g-ir-scanner found: NO
Run-time dependency gstreamer-plugins-base-1.0 found: YES 1.16.2
Run-time dependency gstreamer-plugins-bad-1.0 found: YES 1.16.2
Found CMake: /usr/bin/cmake (3.16.3)
Run-time dependency libcgroup found: NO (tried pkgconfig and cmake)
Configuring gstreamer-rtsp-server-1.0.pc using configuration
Configuring gstreamer-rtsp-server-1.0-uninstalled.pc using configuration
Build targets in project: 35
```
安装缺失的包
```
$ sudo apt-get install libcgroup-dev
$ sudo apt-get install gobject-introspection
```

继续执行:
```
$ meson build
$ ninja -C build/
```

## 测试
在一个终端中执行: 
```
$ build/examples/test-video
stream ready at rtsp://127.0.0.1:8554/test
```

在另一个终端中执行:
```
$ ffplay rtsp://127.0.0.1:8554/test
... ...
  libswscale      5.  5.100 /  5.  5.100
  libswresample   3.  5.100 /  3.  5.100
  libpostproc    55.  5.100 / 55.  5.100
Input #0, rtsp, from 'rtsp://127.0.0.1:8554/test':sq=    0B f=0/0   
  Metadata:
    title           : Session streamed with GStreamer
    comment         : rtsp-server
  Duration: N/A, start: 0.000000, bitrate: N/A
    Stream #0:0: Video: h264 (Constrained Baseline), yuv420p(tv, bt470bg/smpte170m/bt709, progressive), 352x288 [SAR 1:1 DAR 11:9], 15 fps, 15 tbr, 90k tbn, 30 tbc
    Stream #0:1: Audio: pcm_alaw, 8000 Hz, 1 channels, s16, 64 kb/s
   2.01 A-V:  0.030 fd=   0 aq=    5KB vq=   96KB sq=    0B f=1/1  
```

可以看到测试画面则测试通过.

## 如何知道`gobject-introspection`在哪个包中?
执行命令:
```
$ dpkg -S g-ir-scanner
gobject-introspection: /usr/bin/g-ir-scanner
gobject-introspection: /usr/share/man/man1/g-ir-scanner.1.gz
```
可以看到`gobject-introspection`在`gobject-introspection`包中.

其实还有一个命令也是一样的效果:
```
$ sudo apt-get install apt-file
$ apt-file search g-ir-scanner
gobject-introspection: /usr/bin/g-ir-scanner
gobject-introspection: /usr/share/man/man1/g-ir-scanner.1.gz
```
`apt-file`提供了一些额外的功能, 可以从`$ man apt-file`中获得更多信息.