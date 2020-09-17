# esp-idf踩坑记录

## unable to open ftdi device with vid 0403, pid 6010, description
命令: 
```
$ openocd -f board/esp32-wrover-kit-3.3v.cfg
Open On-Chip Debugger  v0.10.0-esp32-20200709 (2020-07-09-08:54)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : Configured 2 cores
Error: libusb_open() failed with LIBUSB_ERROR_ACCESS
Error: no device found
Error: unable to open ftdi device with vid 0403, pid 6010, description '*', serial '*' at bus location '*'
Error: no device found
Error: unable to open ftdi device with vid 0403, pid 6014, description '*', serial '*' at bus location '*'
** OpenOCD init failed **
shutdown command invoked

openocd: src/jtag/core.c:343: jtag_checks: Assertion `jtag_trst == 0' failed.
```

解决:
sudo chmod -R 777 /dev/bus/usb/


## 动不动无法下载的问题
```
> Executing task: /home/nickli/.espressif/python_env/idf4.3_py2.7_env/bin/python /home/nickli/esp-idf/components/esptool_py/esptool/esptool.py -p /dev/ttyUSB3 -b 115200 --after hard_reset write_flash --flash_mode dio --flash_freq 40m --flash_size detect 0x8000 partition_table/partition-table.bin 0x1000 bootloader/bootloader.bin 0x10000 template-app.bin <

esptool.py v3.0-dev
Serial port /dev/ttyUSB3
Connecting........_____....._____....._____....._____....._____....._____....._____

A fatal error occurred: Failed to connect to Espressif device: Timed out waiting for packet header
The terminal process "/bin/bash '-c', '/home/nickli/.espressif/python_env/idf4.3_py2.7_env/bin/python /home/nickli/esp-idf/components/esptool_py/esptool/esptool.py -p /dev/ttyUSB3 -b 115200 --after hard_reset write_flash --flash_mode dio --flash_freq 40m --flash_size detect 0x8000 partition_table/partition-table.bin 0x1000 bootloader/bootloader.bin 0x10000 template-app.bin'" terminated with exit code: 2.
```

解决:
ESP32的硬件设计非常的差, 这导致了很多问题, 比如下载超时等各种问题, 此时唯一的办法就是移除板子上所有的外设, 否则就会一直这样.

## 移动项目路径导致的编译错误
```
CMake Error: The current CMakeCache.txt directory /home/nickli/work/esp/template-app/build/CMakeCache.txt is different than the directory /home/nickli/work/esp/template-app/template-app/build where CMakeCache.txt was created. This may result in binaries being created in the wrong place. If you are not sure, reedit the CMakeCache.txt
CMake Error: The source "/home/nickli/work/esp/template-app/CMakeLists.txt" does not match the source "/home/nickli/work/esp/template-app/template-app/CMakeLists.txt" used to generate cache.  Re-run cmake with a different source directory.
The terminal process "/bin/bash '-c', 'cmake -G Ninja ..'" failed to launch (exit code: 1).
```

解决:
```
rm -fr build
```

## VSCode启动OpenOCD报错
```
Traceback (most recent call last):
  File "/home/nickli/.vscode/extensions/espressif.esp-idf-extension-0.4.0/esp_debug_adapter/debug_adapter_main.py", line 26, in <module>
    from debug_adapter import cli
  File "/home/nickli/.vscode/extensions/espressif.esp-idf-extension-0.4.0/esp_debug_adapter/debug_adapter/__init__.py", line 25, in <module>
    from .debug_adapter import DebugAdapter, DaArgs, A2VSC_READY2CONNECT_STRING, A2VSC_STOPPED_STRING, A2VSC_STARTED_STRING
  File "/home/nickli/.vscode/extensions/espressif.esp-idf-extension-0.4.0/esp_debug_adapter/debug_adapter/debug_adapter.py", line 32, in <module>
    from typing import List, Dict, Any
ImportError: No module named typing
[Stopped] : ESP-IDF Debug Adapter

```
解决:
```
sudo apt install python-typing
```