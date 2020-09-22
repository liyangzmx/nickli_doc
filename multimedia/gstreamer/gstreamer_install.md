# 在Ubuntu上安装GStreamer并编译demo

## 参考资料
* [Install GStreamer on Ubuntu or Debian](https://gstreamer.freedesktop.org/documentation/installing/on-linux.html#install-gstreamer-on-ubuntu-or-debian)

## 安装
```
$ sudo apt-get install libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
```

## 使用GStreamer编译应用
使用gcc即可完成编译, 为了链接到GStreamer的库, 应使用如下命令获取这些参数:
```
$ pkg-config --cflags --libs gstreamer-1.0
```
通常你将得到:
```
-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0
```

## 关于官方提及的`gstreamer-video-1.0`
官方提及在使用`gstreamer-video-1.0`时, 可以使用对应的命令:
```
$ pkg-config --cflags --libs gstreamer-video-1.0
```
如果发现没有找到该库, 那么需要使用对应的命令安装缺失的包:
```
sudo apt-get install libgstreamer-plugins-base1.0-dev
sudo apt-get install libgstreamer-plugins-good1.0-dev
```

可选的:  
|选项|输出|
|:-:|:-:|
|`gstreamer-1.0`|`-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lgstreamer-1.0 -lgobject-2.0 -lglib-2.`|
|`gstreamer-base-1.0`|`-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lgstbase-1.0 -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0`|
|`gstreamer-controller-1.0`|`-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lgstcontroller-1.0 -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0`|
|`gstreamer-net-1.0`|`-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lgstnet-1.0 -lgstreamer-1.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0`|
|`gstreamer-check-1.0`|`-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lgstcheck-1.0 -lm -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0`|
|||

以上选项可以从`/usr/lib/x86_64-linux-gnu/pkgconfig/`下的`gstreamer-*.pc`的文件一一对应;

## 获取教程的源代码
可以将源码从教程中直接复制到C程序源文件中, 但为了饭便起见, 对应的代码也位于教程源码库`gst-docs`的`examples/tutorials`路径中.
可以使用如下命令获取教程源码GIT库:
```
$ git clone https://gitlab.freedesktop.org/gstreamer/gst-docs
```

## demo的编译

对于国内的环境, demo中的地址可能无法正常观看, 可以酌情做如下调整:
```
$ git diff
diff --git a/examples/tutorials/basic-tutorial-1.c b/examples/tutorials/basic-tutorial-1.c
index dfd449b..eb073fa 100644
--- a/examples/tutorials/basic-tutorial-1.c
+++ b/examples/tutorials/basic-tutorial-1.c
@@ -13,7 +13,7 @@ main (int argc, char *argv[])
   /* Build the pipeline */
   pipeline =
       gst_parse_launch
-      ("playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm",
+      ("playbin uri=http://vfx.mtime.cn/Video/2019/03/19/mp4/190319212559089721.mp4",
       NULL);
 
   /* Start playing */
```

编译demo:
```
$ cd gst-docs/examples/tutorials/
$ gcc basic-tutorial-1.c -o basic-tutorial-1 `pkg-config --cflags --libs gstreamer-1.0`
$ ./basic-tutorial-1
```

在Ubuntu上效果如图所示:
![](basic-tutorial-1.png)

## 使用cmake进行编译&链接
作为补充说明,在`gst-docs/examples/tutorials/`下新建`CMakeLists.txt`可完成demo的编译, 文件内容如下:
```
cmake_minimum_required(VERSION 3.8.1)

project(basic-tutorial-1)

find_package(PkgConfig REQUIRED)

pkg_check_modules(gstreamer-1.0
    REQUIRED
    IMPORTED_TARGET
    GLOBAL
    gstreamer-1.0
)

add_executable(basic-tutorial-1 basic-tutorial-1.c)
target_link_libraries(basic-tutorial-1
    PkgConfig::gstreamer-1.0
)
```

## 配置VSCode的头文件
对于使用VSCode的用户, 可能会因为头文件路径无法确定的影响补全效果, 推荐配置`gst-docs/examples/tutorials/.vscode/settings.json`:
```
{
    ... ...
    "C_Cpp.default.includePath": [
        "/usr/include/gstreamer-1.0/",
        "/usr/include/glib-2.0/",
        "/usr/lib/x86_64-linux-gnu/glib-2.0/include/",
    ],
}
```

## 关于basic-tutorial-5的特别说明
### 关于缺失`gtk/gtk.h`的报错
报错:
```
[build] FAILED: CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o 
[build] /bin/gcc-9  -isystem /usr/include/gstreamer-1.0 -isystem /usr/include/glib-2.0 -isystem /usr/lib/x86_64-linux-gnu/glib-2.0/include -g   -pthread -MD -MT CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o -MF CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o.d -o CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o   -c ../basic-tutorial-5.c
[build] ../basic-tutorial-5.c:3:10: fatal error: gtk/gtk.h: 没有那个文件或目录
[build]     3 | #include <gtk/gtk.h>
[build]       |          ^~~~~~~~~~~
[build] compilation terminated.
```
由于该库需要安装`gtk+-3.0`, 所以确保该库已经安装:
```
sudo apt install gtk+-3.0-dev
```
并且配置`CMakeLists.txt`:
```
cmake_minimum_required(VERSION 3.8.1)

project(basic-tutorial)

find_package(PkgConfig REQUIRED)

pkg_check_modules(gstreamer-1.0
    REQUIRED
    IMPORTED_TARGET
    GLOBAL
    gstreamer-1.0
)

pkg_check_modules(gtk+-3.0
    REQUIRED
    IMPORTED_TARGET
    GLOBAL
    gtk+-3.0
)
add_executable(basic-tutorial-5 basic-tutorial-5.c)
target_link_libraries(basic-tutorial-5
    PkgConfig::gstreamer-1.0
    PkgConfig::gtk+-3.0
)
```

### 关于缺失`gst/video/videooverlay.h`的报错
报错:
```
[build] FAILED: CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o 
[build] /bin/gcc-9  -isystem /usr/include/gstreamer-1.0 -isystem /usr/include/glib-2.0 -isystem /usr/lib/x86_64-linux-gnu/glib-2.0/include -isystem /usr/include/gtk-3.0 -isystem /usr/include/at-spi2-atk/2.0 -isystem /usr/include/at-spi-2.0 -isystem /usr/include/dbus-1.0 -isystem /usr/lib/x86_64-linux-gnu/dbus-1.0/include -isystem /usr/include/gio-unix-2.0 -isystem /usr/include/cairo -isystem /usr/include/pango-1.0 -isystem /usr/include/fribidi -isystem /usr/include/harfbuzz -isystem /usr/include/atk-1.0 -isystem /usr/include/pixman-1 -isystem /usr/include/uuid -isystem /usr/include/freetype2 -isystem /usr/include/libpng16 -isystem /usr/include/gdk-pixbuf-2.0 -isystem /usr/include/libmount -isystem /usr/include/blkid -g   -pthread -MD -MT CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o -MF CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o.d -o CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o   -c ../basic-tutorial-5.c
[build] ../basic-tutorial-5.c:5:10: fatal error: gst/video/videooverlay.h: 没有那个文件或目录
[build]     5 | #include <gst/video/videooverlay.h>
[build]       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~
[build] compilation terminated.
```
这是由于缺少对应的gstreamer插件导致的, 安装:
```
sudo apt-get install libgstreamer-plugins-base1.0-dev
```

### 关于找不到`gst_video_overlay_get_type`符号的报错
报错:
```
[build] FAILED: basic-tutorial-5 
[build] : && /bin/gcc-9 -g   CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o  -o basic-tutorial-5  /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so  /usr/lib/x86_64-linux-gnu/libgtk-3.so  /usr/lib/x86_64-linux-gnu/libgdk-3.so  /usr/lib/x86_64-linux-gnu/libpangocairo-1.0.so  /usr/lib/x86_64-linux-gnu/libpango-1.0.so  /usr/lib/x86_64-linux-gnu/libharfbuzz.so  /usr/lib/x86_64-linux-gnu/libatk-1.0.so  /usr/lib/x86_64-linux-gnu/libcairo-gobject.so  /usr/lib/x86_64-linux-gnu/libcairo.so  /usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so  /usr/lib/x86_64-linux-gnu/libgio-2.0.so  /usr/lib/x86_64-linux-gnu/libgobject-2.0.so  /usr/lib/x86_64-linux-gnu/libglib-2.0.so && :
[build] /usr/bin/ld: CMakeFiles/basic-tutorial-5.dir/basic-tutorial-5.c.o: in function `realize_cb':
[build] /home/nickli/desktop/gstreamer/gst-docs/examples/tutorials/build/../basic-tutorial-5.c:50: undefined reference to `gst_video_overlay_get_type'
[build] /usr/bin/ld: /home/nickli/desktop/gstreamer/gst-docs/examples/tutorials/build/../basic-tutorial-5.c:50: undefined reference to `gst_video_overlay_set_window_handle'
[build] collect2: error: ld returned 1 exit status
[build] ninja: build stopped: subcommand failed.
```


### 最终的CMakeLists.txt
```
cmake_minimum_required(VERSION 3.8.1)

project(basic-tutorial)

find_package(PkgConfig REQUIRED)

pkg_check_modules(gstreamer-1.0
    REQUIRED
    IMPORTED_TARGET
    GLOBAL
    gstreamer-1.0
)

pkg_check_modules(gstreamer-video-1.0
    REQUIRED
    IMPORTED_TARGET
    GLOBAL
    gstreamer-video-1.0
)

pkg_check_modules(gtk+-3.0
    REQUIRED
    IMPORTED_TARGET
    GLOBAL
    gtk+-3.0
)

add_executable(basic-tutorial-5 basic-tutorial-5.c)
target_link_libraries(basic-tutorial-5
    PkgConfig::gstreamer-video-1.0
    PkgConfig::gstreamer-1.0
    PkgConfig::gtk+-3.0
)
```