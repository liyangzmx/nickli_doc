# Ftrace

参考资料: [ftrace - Function Tracer](https://www.kernel.org/doc/html/latest/trace/ftrace.html)

挂载tracefs: `# mount -t tracefs nodev /sys/kernel/tracing`
快速访问建符号链接: `# ln -s /sys/kernel/tracing /tracing`

例子:
```
# cd /tracing
# echo 0 > options/function-trace
# echo irqsoff > current_tracer
bash: echo: 写错误: 无效的参数

# echo 1 > tracing_on
# echo 0 > tracing_max_latency
# ls -ltr
```
`bash: echo: 写错误: 无效的参数`是因为没有可用的名字为`irqsoff`的跟踪器
查看可用的跟踪器:
```
# cat available_tracers 
hwlat blk mmiotrace function_graph wakeup_dl wakeup_rt wakeup function nop
```
重新执行:
```
# cd /tracing
# echo 0 > options/function-trace
# echo function_graph > current_tracer
# echo 1 > tracing_on
# echo 0 > tracing_max_latency
# ls -ltr
# echo 0 > tracing_on
# cat trace
# tracer: function_graph
```