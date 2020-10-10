# bootchart 命令

## Google官方资料
* [bootchart](https://source.android.com/devices/tech/perf/boot-times#bootchart)  
* [pybootchartgui](https://code.google.com/archive/p/pybootchartgui/)

设置adb:
```
$ adb shell 'touch /data/bootchart/enabled'
$ adb reboot
$ cd ~/work/aosp/
$ source build/envsetup.sh
$ lunch aosp_marlin-userdebug
$ system/core/init/grab-bootchart.sh
system/core/init/grab-bootchart.sh: 20: pybootchartgui: not found
gio: file:///home/nickli/work/aosp/bootchart.png: Error when getting information for file “/home/nickli/work/aosp/bootchart.png”: 没有那个文件或目录
Clean up /tmp/android-bootchart/ and ./bootchart.png when done

```

更具Google官方的提示, 安装bootchart:
```
$ mkdir -p ~/work/gnu/
$ cd ~/work/gnu/
$ git clone --depth=1 https://github.com/xrmx/bootchart.git
$ cd bootchart/
$ make
$ sudo make install
$ system/core/init/grab-bootchart.sh
Traceback (most recent call last):
  File "/usr/bin/pybootchartgui", line 20, in <module>
    from pybootchartgui.main import main
ImportError: No module named pybootchartgui.main
gio: file:///home/nickli/work/aosp/bootchart.png: Error when getting information for file “/home/nickli/work/aosp/bootchart.png”: 没有那个文件或目录
Clean up /tmp/android-bootchart/ and ./bootchart.png when done
```

做如下修改:
```
$ cd system/core/init/
$ git diff
diff --git a/init/grab-bootchart.sh b/init/grab-bootchart.sh
index 2c56698a1..6048a5694 100755
--- a/init/grab-bootchart.sh
+++ b/init/grab-bootchart.sh
@@ -17,6 +17,7 @@ for f in $FILES; do
     adb "${@}" pull $LOGROOT/$f $TMPDIR/$f 2>&1 > /dev/null
 done
 (cd $TMPDIR && tar -czf $TARBALL $FILES)
-pybootchartgui ${TMPDIR}/${TARBALL}
+# pybootchartgui ${TMPDIR}/${TARBALL}
+~/work/gnu/bootchart/pybootchartgui.py ${TMPDIR}/${TARBALL}
 xdg-open ${TARBALL%.tgz}.png
 echo "Clean up ${TMPDIR}/ and ./${TARBALL%.tgz}.png when done
```

再次尝试:
```
$ cd -
$ system/core/init/grab-bootchart.sh
Traceback (most recent call last):
  File "/home/nickli/work/gnu/bootchart/pybootchartgui.py", line 20, in <module>
    from pybootchartgui.main import main
  File "/home/nickli/work/gnu/bootchart/pybootchartgui/main.py", line 26, in <module>
    from . import batch
  File "/home/nickli/work/gnu/bootchart/pybootchartgui/batch.py", line 16, in <module>
    import cairo
ImportError: No module named cairo
gio: file:///home/nickli/work/aosp/bootchart.png: Error when getting information for file “/home/nickli/work/aosp/bootchart.png”: 没有那个文件或目录
Clean up /tmp/android-bootchart/ and ./bootchart.png when done
```

安装缺失的包:
```
$ sudo apt-get install python-cairo
正在读取软件包列表... 完成
正在分析软件包的依赖关系树       
正在读取状态信息... 完成       
下列【新】软件包将被安装：
  python-cairo
升级了 0 个软件包，新安装了 1 个软件包，要卸载 0 个软件包，有 40 个软件包未被升级。
需要下载 57.1 kB 的归档。
解压缩后会消耗 270 kB 的额外空间。
获取:1 http://mirrors.aliyun.com/ubuntu focal/universe amd64 python-cairo amd64 1.16.2-2ubuntu2 [57.1 kB]
已下载 57.1 kB，耗时 1秒 (109 kB/s) 
正在选中未选择的软件包 python-cairo:amd64。
(正在读取数据库 ... 系统当前共安装有 381213 个文件和目录。)
准备解压 .../python-cairo_1.16.2-2ubuntu2_amd64.deb  ...
正在解压 python-cairo:amd64 (1.16.2-2ubuntu2) ...
正在设置 python-cairo:amd64 (1.16.2-2ubuntu2) ...
```

再次执行:
```
$ system/core/init/grab-bootchart.sh
parsing '/tmp/android-bootchart/bootchart.tgz'
parsing 'header'
parsing 'proc_stat.log'
parsing 'proc_ps.log'
parsing 'proc_diskstats.log'
merged 0 logger processes
pruned 173 process, 0 exploders, 66 threads, and 1 runs
bootchart written to 'bootchart.png'
Clean up /tmp/android-bootchart/ and ./bootchart.png when done
```