# QEMU 调试Linux内核

## 下载源码

官网:[Buildroot Making Embedded Linux Easy](https://buildroot.org/)  
本例:[buildroot-2021.02.4.tar.bz2](https://buildroot.org/downloads/buildroot-2021.02.4.tar.bz2)  
我稍后会打包一份(配置且编译好的)上传到网盘并共享出来, 我的buildroot所在路径为: `/media/sangfor/vdb/buildroot-2021.02.4`

## 准备
```
sudo apt install -y libncurses-dev flex bison libelf-dev libssl-dev
```

## 配置并编译
```
make qemu_aarch64_virt_defconfig
```

## GDB的编译配置
执行`make menuconfig`配置主机端的交叉调试器, 或者在`.config`配置中添加:
```
BR2_PACKAGE_HOST_GDB_ARCH_SUPPORTS=y
```

## Kernel配置
修改内核配置选项:
```
DEBUG_INFO=y
GDB_SCRIPTS=y
```

## 编译
```
make -j8
```

输出在`output/`下

## VSCode 配置
下载最新的VSCode(使用国内CDN):
[code_1.62.0-1635954068_amd64.deb](https://vscode.cdn.azure.cn/stable/b3318bc0524af3d74034b8bb8a64df0ccf35549a/code_1.62.0-1635954068_amd64.deb)

在buildroot的`output/build/linux-5.10.7/.vscode/launch.json`中进行如下配置
```
{
    // 使用 IntelliSense 了解相关属性。 
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(gdb) 启动",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/vmlinux",
            "args": [],
            "miDebuggerServerAddress": "localhost:12345",
            "stopAtEntry": true,
            "cwd": "${workspaceFolder}/",
            "environment":[],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "${workspaceFolder}/../../host/bin/aarch64-buildroot-linux-uclibc-gdb",
            "setupCommands": [
                {
                    "description": "为 gdb 启用整齐打印",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
}
```
特别注意的是 **GDB路径** 的配置和 **GDB Server端口** 的配置.

## QEMU启动脚本
编译生成的是: `./output/images/start-qemu.sh`没有GDB的参数, 因此我们稍微修改一下:
```
#!/bin/sh
(
BINARIES_DIR="${0%/*}/"
cd ${BINARIES_DIR}

if [ "${1}" = "serial-only" ]; then
    EXTRA_ARGS='-nographic'
else
    EXTRA_ARGS=''
fi

export PATH="/media/sangfor/vdb/buildroot-2021.02.4/output/host/bin:${PATH}"
exec qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 1 -kernel Image -append "rootwait root=/dev/vda console=ttyAMA0" -netdev user,id=eth0 -device virtio-net-device,netdev=eth0 -drive file=rootfs.ext4,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -gdb tcp::12345 -S ${EXTRA_ARGS}
)
```
实际上我们只是在`exec qemu-system-aarch64`后边附加了`-gdb tcp::12345 -S`来等待VSCode调用的`aarch64-buildroot-linux-uclibc-gdb`链接过来

大体步骤:
* 执行`code output/build/linux-5.10.7/`启动VSCode
* 确保VSCode已经安装`C/C++相关插件`
* 按下` CTRL+` `打开终端, 然后执行`./output/images/start-qemu.sh`, 此时终端会阻塞住。
* 点击VSCode左侧的`运行与调试`, 然后点击配置好的`(gdb) 启动`可以看到终端开始启动
* 在代码`kernel/module.c:4031`处, 也就是`SYSCALL_DEFINE3(init_module...`函数中下断点
* 登录启动的qemu, 密码时`root`, 然后在板子上执行:`# insmod /lib/modules/5.10.7/kernel/net/802/stp.ko`
* 此时VSCode可停在对应的断电处.
