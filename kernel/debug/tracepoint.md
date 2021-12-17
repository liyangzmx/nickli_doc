# Tracepoints Analysis

参考资料: [Notes on Analysing Behaviour Using Events and Tracepoints](https://www.kernel.org/doc/html/latest/trace/tracepoint-analysis.html)

注: 大多数命令需要使用`root`因此所以`$`开始的命令都是普通用户, 所以以`#`开始的命令都是`root`

查找当前系统的Tracepoint: `find /sys/kernel/debug/tracing/events -type d`

安装linux工具:
```
$ sudo apt install linux-tools-common
$ sudo apt install linux-tools-5.4.0-90-generic linux-cloud-tools-5.4.0-90-generic linux-tools-generic linux-cloud-tools-generic
```
使用如下命令列出所有的调试点: `perf list 2>&1 | grep Tracepoint`

启用所有的调试点: 
```
for i in `find /sys/kernel/debug/tracing/events -name "enable" | grep mm_`; do echo 1 > $i; done
```

