# Nuttx

# 官方
[Apache NuttX](http://nuttx.apache.org/)
[Apache NuttX Downloads](http://nuttx.apache.org/download/)
[NuttX Documentation](http://nuttx.apache.org/docs/latest/#)  

# 代码下载
[OS](https://downloads.apache.org/incubator/nuttx/9.1.0/apache-nuttx-9.1.0-incubating.tar.gz)/[Apps](https://downloads.apache.org/incubator/nuttx/9.1.0/apache-nuttx-apps-9.1.0-incubating.tar.gz)  

# Quickstart
参考: [Quickstart](http://nuttx.apache.org/docs/latest/quickstart/quickstart.html)
```
$ mkdir ~/work/nuttx
$ cd ~/work/nuttx/
$ mkdir gcc
$ cd gcc
$ wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
$ tar xf gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
$ echo "export PATH=~/work/nuttx/gcc/gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH" >> ~/.bashrc
$ cd ..

$ pwd
~/work/nuttx
$ git clone https://github.com/apache/incubator-nuttx.git nuttx
$ git clone https://github.com/apache/incubator-nuttx-apps apps
$ git clone https://bitbucket.org/nuttx/tools.git tools

$ sudo apt install kconfig-frontends

$ cd nuttx
$ ./tools/configure.sh -l stm32f3discovery:nsh
$ make 
```

# 安装到stm32f4-discovery
```
cd ~/work/nuttx/
$ sudo apt install \
bison flex gettext texinfo libncurses5-dev libncursesw5-dev \
gperf automake libtool pkg-config build-essential gperf genromfs \
libgmp-dev libmpc-dev libmpfr-dev libisl-dev binutils-dev libelf-dev \
libexpat-dev gcc-multilib g++-multilib picocom u-boot-tools util-linux

# 添加权限
$ sudo usermod -a -G dialout $USER
$ sudo apt install openocd
$ git clone git://git.code.sf.net/p/openocd/code openocd
$ cd openocd
$ ./bootstrap
$ mkdir install/
$ ./configure --prefix `pwd`/install/
$ make -j32
$ make install
$ echo "export PATH=~/work/nuttx/openocd/install/bin:$PATH" >> ~/.bashrc
$ source ~/.bashrc
$ cd ..

# 插上stm32f4-disocvery板子到主机, 然后执行
$ openocd -f /interface/stlink-v2.cfg -f target/stm32f1x.cfg -c 'init'   -c 'program nuttx/nuttx.bin verify reset' -c 'shutdown'

# 当然以下命令也是可以的
$ openocd -f openocd/tcl/interface/stlink-v2.cfg -f openocd/install/share/openocd/scripts/target/stm32f1x.cfg -c 'init'   -c 'program nuttx/nuttx.bin verify reset' -c 'shutdown'
```

# 编译Sphinx文档
参考: 
* [Sphinx - Welcome](https://www.sphinx-doc.org/en/master/)
* [Sphinx - Getting Started](https://www.sphinx-doc.org/en/master/usage/quickstart.html)
```
$ pip3 install -U Sphinx
Collecting Sphinx
|DNS-request| files.pythonhosted.org 
|S-chain|-<>-127.0.0.1:1080-<><>-4.2.2.2:53-<><>-OK
|DNS-response| files.pythonhosted.org is 151.101.41.63
|S-chain|-<>-127.0.0.1:1080-<><>-151.101.41.63:443-<><>-OK
  Downloading Sphinx-3.2.1-py3-none-any.whl (2.9 MB)
     |████████████████████████████████| 2.9 MB 255 kB/s
... ...
Installing collected packages: sphinxcontrib-applehelp, sphinxcontrib-serializinghtml, sphinxcontrib-devhelp, imagesize, sphinxcontrib-jsmath, Jinja2, sphinxcontrib-qthelp, sphinxcontrib-htmlhelp, snowballstemmer, alabaster, babel, docutils, Sphinx
Successfully installed Jinja2-2.11.2 Sphinx-3.2.1 alabaster-0.7.12 babel-2.8.0 docutils-0.16 imagesize-1.2.0 snowballstemmer-2.0.0 sphinxcontrib-applehelp-1.0.2 sphinxcontrib-devhelp-1.0.2 sphinxcontrib-htmlhelp-1.0.3 sphinxcontrib-jsmath-1.0.1 sphinxcontrib-qthelp-1.0.3 sphinxcontrib-serializinghtml-1.1.4

$ cd nuttx/Documentation/
$ $ make html
正在运行 Sphinx v3.2.1

Extension error:
无法导入扩展 sphinx_rtd_theme (exception: No module named 'sphinx_rtd_theme')
make: *** [Makefile:42：html] 错误 2

$ pip3 install sphinx_rtd_theme
  Downloading sphinx_rtd_theme-0.5.0-py2.py3-none-any.whl (10.8 MB)
     |████████████████████████████████| 10.8 MB 396 kB/s
... ...
Installing collected packages: sphinx-rtd-theme
Successfully installed sphinx-rtd-theme-0.5.0

$ make html
正在运行 Sphinx v3.2.1

Extension error:
无法导入扩展 m2r2 (exception: No module named 'm2r2')
make: *** [Makefile:42：html] 错误 2

$ pip3 install m2r2
Collecting m2r2
  Downloading m2r2-0.2.5-py3-none-any.whl (10 kB)
Collecting mistune
  Downloading mistune-0.8.4-py2.py3-none-any.whl (16 kB)
Requirement already satisfied: docutils in /home/nickli/.local/lib/python3.8/site-packages (from m2r2) (0.16)
Installing collected packages: mistune, m2r2
Successfully installed m2r2-0.2.5 mistune-0.8.4

$ make html
正在运行 Sphinx v3.2.1

Extension error:
无法导入扩展 sphinx_tabs.tabs (exception: No module named 'sphinx_tabs')
make: *** [Makefile:42：html] 错误 2

$ pip3 install sphinx_tabs
Collecting sphinx_tabs
  Downloading sphinx_tabs-1.3.0-py3-none-any.whl (22 kB)
... ...
Installing collected packages: sphinx-tabs
Successfully installed sphinx-tabs-1.3.0

$ make html
正在运行 Sphinx v3.2.1
创建输出目录... 完成
构建 [mo]： 0 个 po 文件的目标文件已过期
构建 [html]： 116 个源文件的目标文件已过期
更新环境: [新配置] 已添加 116，0 已更改，0 已移除
阅读源... [  2%] applications/index .. applications/nsh/commands 
阅读源... [  5%] applications/nsh/config .. applications/nsh/index                                                           阅读源... [  7%] applications/nsh/installation .. applications/nsh/nsh  
... ...
等待工作线程……
generating indices...  genindex完成
writing additional pages...  search完成
复制图像... [  8%] components/nxgraphics/NuttXScreenShot.jpg                                                                 复制图像... [ 16%] components/nxgraphics/NXOrganization.gif 
... ...
HTML 页面保存在 _build/html 目录。
Copying tabs assets

$ google-chrome _build/html/index.html
# 此步骤过后应该可以在浏览器中看到网页了.
```

其它的部分, api等, 看文档就行...