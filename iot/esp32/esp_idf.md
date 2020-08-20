# Esp32 IDF with VSCode
## 为什么使用**vscode-esp-idf-extension**?
* 官方支持的还可以...
* 方便编译/下载
* 图形化的配置
* 为后续的openocd做准备
* 其他有点, 参考官方的 [README.md](https://github.com/espressif/vscode-esp-idf-extension/blob/master/README.md)

## 插件官方库
[espressif/vscode-esp-idf-extension](https://github.com/espressif/vscode-esp-idf-extension)

按照步骤安装**Espressif IDF**插件, 然后插件会自动跳转到`IDF Onboarding`, 然后你将面临**两个选择:**

### **第一个选择:** 如果你没有安装过esp-idf, 那么恭喜你, 你可以使用插件提供的自动化安装方式(我没有采用这种方式).

---
### **第二个选择:** 如果你有一个现成的idf, 在安装完成插件后, `IDF Onboarding`这个步骤**可以考虑直接关闭**.
#### 如果你直接关闭了`IDF Onboarding`, 按照如下方式配置, 可能会节省一点时间
前提:
* 从[espressif/esp-idf](https://github.com/espressif/esp-idf)用git拉取了`master`的版本, 并且将它放在了: `~/esp-idf/`目录下
* 使用~/esp-idf/install.sh`脚本进行了安装, 此时你应该会发现一个新增的目录:`~/.espressif/`, 里面有些东西:
```
~/.espressif/
├── dist
├── python_env
└── tools
```
* 你确认过${HOME}/.vscode/extensions/espressif.esp-idf-extension-0.4.0/esp_debug_adapter/requirements.txt是存在的
* 本文的`master`节点:
```
commit c77c4ccf6c43ab09fd89e7c907bf5cf2a3499e3b (HEAD -> master, origin/master, origin/HEAD)
Merge: 570629dcc f790e0cc2
Author: Michael (XIAO Xufeng) <xiaoxufeng@espressif.com>
Date:   Thu Jul 30 18:09:50 2020 +0800

    Merge branch 'bugfix/twai_assert_program_logic' into 'master'
    
    TWAI: Remove asserts used for program logic
    
    Closes IDFGH-3729
    
    See merge request espressif/esp-idf!9834
```

**然后我们开始:**
1. 插件提供了一个python的检查文件, 那么先执行如下检查:
```
${HOME}/.espressif/python_env/idf4.3_py2.7_env/bin/python -m pip install -r ${HOME}/.vscode/extensions/espressif.esp-idf-extension-0.4.0/esp_debug_adapter/requirements.txt
```
2. 然后`<Ctrl>_<Shift>_P`输入`Preferense: Open Settings(JSON)`, 然后新增如下配置.
```
{
    "idf.showOnboardingOnInit": false, 
    "idf.espIdfPath": "${env:HOME}/esp-idf", 
    "idf.toolsPath": "${env:HOME}/.espressif", 
    // 可能会有变化, 根据实际的情况调整
    "idf.pythonBinPath": "${env:HOME}/.espressif/python_env/idf4.3_py2.7_env/bin/python",
    "idf.customExtraPaths": "${env:HOME}/.espressif/python_env/idf4.3_py2.7_env/bin:/usr/bin:${env:HOME}/.espressif/tools/xtensa-esp32-elf/esp-2020r2-8.2.0/xtensa-esp32-elf/bin:${env:HOME}/.espressif/tools/xtensa-esp32s2-elf/esp-2020r2-8.2.0/xtensa-esp32s2-elf/bin:${env:HOME}/.espressif/tools/esp32ulp-elf/2.28.51-esp-20191205/esp32ulp-elf-binutils/bin:${env:HOME}/.espressif/tools/esp32s2ulp-elf/2.28.51-esp-20191205/esp32s2ulp-elf-binutils/bin:${env:HOME}/.espressif/tools/openocd-esp32/v0.10.0-esp32-20200709/openocd-esp32/bin",
    "idf.customExtraVars": "{\"OPENOCD_SCRIPTS\":\"${env:HOME}/.espressif/tools/openocd-esp32/v0.10.0-esp32-20200709/openocd-esp32/share/openocd/scripts\"}"
}
```

---
#### 如果你不关闭`IDF Onboarding`(或者在关闭它后再使用`<Ctrl>_<Shift>_P`输入`ESP-IDF:Configure ESP-IDF extension`打开它继续走后面的流程), 那么可能会遇到些问题(Good Luck~), 下面是我处理问题的步骤:

直接点`Download ESP-IDF Tools`进行一遍"安装"  
或者点`Skip ESP-IDF Tools download`:  
Add your ESP-IDF virtual environment python executable absolute path. Example: /.espressif/python_env/idf4.0_py3.8_env/Scripts/python
填:
```
/home/nickli/.espressif/python_env/idf4.3_py2.7_env/bin/python
```

Please specify the directories containing executable binaries for required ESP-IDF Tools (Make sure to also include CMake and Ninja-build): 
| xtensa-esp32-elf | xtensa-esp32s2-elf | esp32ulp-elf | esp32s2ulp-elf | openocd-esp32 |填:
```
/home/nickli/.espressif/python_env/idf4.3_py2.7_env/bin:/usr/bin:/home/nickli/.espressif/tools/xtensa-esp32-elf/esp-2020r2-8.2.0/xtensa-esp32-elf/bin:/home/nickli/.espressif/tools/xtensa-esp32s2-elf/esp-2020r2-8.2.0/xtensa-esp32s2-elf/bin:/home/nickli/.espressif/tools/esp32ulp-elf/2.28.51-esp-20191205/esp32ulp-elf-binutils/bin:/home/nickli/.espressif/tools/esp32s2ulp-elf/2.28.51-esp-20191205/esp32s2ulp-elf-binutils/bin:/home/nickli/.espressif/tools/openocd-esp32/v0.10.0-esp32-20200709/openocd-esp32/bin
```

Replace any ${TOOL_PATH} with absolute path for each custom variable. 
填:
```
/home/nickli/.espressif/tools/openocd-esp32/v0.10.0-esp32-20200709/openocd-esp32/share/openocd/scripts
```
然后再点`Skip ESP-IDF Tools download`进入下一步配置.

此时`Verify ESP-IDF Tools`下的工具链应该都是对勾.

对于`Command failed: "/home/nickli/.espressif/python_env/idf4.3_py2.7_env/bin/python" "/home/nickli/esp-idf/tools/check_python_dependencies.py" -r "/home/nickli/.vscode/extensions/espressif.esp-idf-extension-0.4.0/esp_debug_adapter/requirements.txt"`的错误, 按照提示执行:
```
/home/nickli/.espressif/python_env/idf4.3_py2.7_env/bin/python -m pip install -r /home/nickli/.vscode/extensions/espressif.esp-idf-extension-0.4.0/esp_debug_adapter/requirements.txt
```

此时如果遇到报错:
```
ERROR: Command errored out with exit status 1: /home/nickli/.espressif/python_env/idf4.3_py2.7_env/bin/python -u -c 'import sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-ti2UT0/psutil/setup.py'"'"'; __file__='"'"'/tmp/pip-install-ti2UT0/psutil/setup.py'"'"';f=getattr(tokenize, '"'"'open'"'"', open)(__file__);code=f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' install --record /tmp/pip-record-7aIeFX/install-record.txt --single-version-externally-managed --compile --install-headers /home/nickli/.espressif/python_env/idf4.3_py2.7_env/include/site/python2.7/psutil Check the logs for full command output.       ^~~~~~~~~~
```
请执行如下命令:
```
sudo apt-get install python-dev 
```
然后再次尝试.

完成后, 再次点击检查即可进行到下一步.

点击`View ESP-IDF project examples!`