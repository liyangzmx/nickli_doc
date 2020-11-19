# Gource

## go
```
$ git clone https://github.com/acaudwell/Gource.git
正克隆到 'Gource'...
remote: Enumerating objects: 52, done.
remote: Counting objects: 100% (52/52), done.
remote: Compressing objects: 100% (27/27), done.
remote: Total 5251 (delta 32), reused 40 (delta 25), pack-reused 5199
接收对象中: 100% (5251/5251), 3.81 MiB | 47.00 KiB/s, 完成.
处理 delta 中: 100% (3657/3657), 完成.

$ ./autogen.sh
autoreconf ran successfully.
Initializing submodules...
Updating submodules...
正克隆到 '/opt/work/Gource/src/core'...
子模组路径 'src/core'：检出 'a1abbaa18dfdbe43d92e9af3ee9bbc6022f5793b'
Run './configure && make' to continue.

$ ./configure 
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
... ...
checking for SDL2... configure: error: Package requirements (sdl2 SDL2_image) were not met:

No package 'SDL2_image' found

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

Alternatively, you may set the environment variables SDL2_CFLAGS
and SDL2_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.

$ sudo apt-get install libsdl2-image-dev

$ ./configure 
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
... ... 
checking for glm/glm.hpp... no
configure: error: GLM headers are required. Please see INST

$ sudo apt-get install libglm-dev
$ ./configure 
$ make -j32
$ make install
```