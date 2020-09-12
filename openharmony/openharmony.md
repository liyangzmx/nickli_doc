# Openharmony
官方参考资料:
* [OpenHarmony - 项目介绍](https://openharmony.gitee.com/openharmony)
* [HarmonyOS Device - 如何快速入门](https://device.harmonyos.com/cn/docs/start/introduce/oem_start_guide-0000001054913231)


## 源码下载:
参考: [源码获取](https://openharmony.gitee.com/openharmony/docs/blob/master/get-code/%E6%BA%90%E7%A0%81%E8%8E%B7%E5%8F%96.md)

命令:
```
mkdir -p /opt/openharmony/
cd /opt/openharmony/
repo init -u https://gitee.com/openharmony/manifest.git -b master
repo sync -j16
mkdir dl/
cd dl/
axel -n 10 https://repo.huaweicloud.com/harmonyos/compiler/gcc_riscv32/7.3.0/linux/gcc_riscv32-linux-7.3.0.tar.gz
axel -n 10 https://repo.huaweicloud.com/harmonyos/compiler/gn/1523/linux/gn.1523.tar
axel -n 10 https://repo.huaweicloud.com/harmonyos/compiler/ninja/1.9.0/linux/ninja.1.9.0.tar
cd ..
tar xvf dl/gcc_riscv32-linux-7.3.0.tar.gz
tar xvf dl/gn.1523.tar
tar xvf dl/ninja.1.9.0.tar
```

## 搭建环境
参考: [搭建环境](https://device.harmonyos.com/cn/docs/start/introduce/oem_quickstart_3861_build-0000001054781998)  

配置变量`export.sh`:
```
#!/bin/bash

export PATH=/opt/openharmony/gcc_riscv32/bin:/opt/openharmony/gn:/opt/openharmony/ninja:$PATH
```

开始编译:
```
python3 build.py wifiiot
--- < OUTPUT > ---

=== start build ===

Done. Made 57 targets from 53 files in 140ms
ninja: Entering directory `/opt/openharmony/out/wifiiot'
[1/197] STAMP obj/applications/sample/wifi-iot/app/startup/startup.stamp
[2/197] cross compiler obj/base/hiviewdfx/frameworks/hilog_lite/mini/hiview_log_limit.o
...
./build.sh: line 111: scons: command not found
Traceback (most recent call last):
  File "../../build/lite/build_ext_components.py", line 64, in <module>
    sys.exit(main())
  File "../../build/lite/build_ext_components.py", line 58, in main
    cmd_exec(args.command)
  File "../../build/lite/build_ext_components.py", line 32, in cmd_exec
    raise Exception("{} failed, return code is {}".format(cmd, ret_code))
Exception: ['sh', 'hm_build.sh'] failed, return code is 127
ninja: build stopped: subcommand failed.
you can check build log in /opt/openharmony/out/wifiiot/build.log
/opt/openharmony/ninja/ninja -w dupbuild=warn -C /opt/openharmony/out/wifiiot failed, return code is 1
```

`scons`是一个开源的编译框架, 安装该工具:
```
sudo apt-get install -y scons
python3 build.py wifiiot
--- < OUTPUT > ---

[196/197] ACTION //vendor/hisi/hi3861/hi3861:run_wifiiot_scons(//build/lite/toolchain:linux_x86_64_riscv32_gcc)
FAILED: obj/vendor/hisi/hi3861/hi3861/run_wifiiot_scons_build_ext_components.txt 
python ../../build/lite/build_ext_components.py --path=../../vendor/hisi/hi3861/hi3861 --command=sh\ hm_build.sh
...
ModuleNotFoundError: No module named 'Crypto'

During handling of the above exception, another exception occurred:

...
Exception: ['sh', 'hm_build.sh'] failed, return code is 1
ninja: build stopped: subcommand failed.
you can check build log in /opt/openharmony/out/wifiiot/build.log
/opt/openharmony/ninja/ninja -w dupbuild=warn -C /opt/openharmony/out/wifiiot failed, return code is 1
```

安装缺失的库:
```
sudo apt install python3-crypto
python3 build.py wifiiot
--- < OUTPUT > ---

...
ModuleNotFoundError: No module named 'ecdsa
...
```

安装缺失的库:
```
sudo apt install python3-ecdsa
python3 build.py wifiiot
--- < OUTPUT > ---

...
[section_count=0x1]
[section0_compress=0x1][section0_offset=0x3c0][section0_len=0x69448]
[section1_compress=0x0][section1_offset=0x0][section1_len=0x0]
-------------output/bin/Hi3861_wifiiot_app_ota.bin image info print end--------------

< ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ >
                              BUILD SUCCESS                              
< ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ >

See build log from: /opt/openharmony/vendor/hisi/hi3861/hi3861/build/build_tmp/logs/build_kernel.log
[197/197] STAMP obj/vendor/hisi/hi3861/hi3861/run_wifiiot_scons.stamp
```

