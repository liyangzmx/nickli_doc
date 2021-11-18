# Ramoops

## 内核配置:
```
PSTORE=y
PSTORE_CONSOLE=y
PSTORE_RAM=y
FUNCTION_TRACER=y
PSTORE_FTRACE=y
```

修改dts文件`output/build/linux-5.10.7/arch/arm/boot/dts/vexpress-v2p-ca9.dts`, 添加:
```
/ {
    ...
    reserved-memory {
        #address-cells = <2>;
        #size-cells = <2>;
        ranges;

        ramoops@8000000 {
                compatible = "ramoops";
                reg = <0 0x8000000 0 0x100000>;
                record-size = <0x4000>;
                console-size = <0x4000>;
        };
    };
    ...
}
```

挂载内核 debug分区:
```
mount -t debugfs debugfs /sys/kernel/debug/
```

然后按照 256MB配置启动, 但是在`/sys/kernel/debug/`下没有看到`pstore`