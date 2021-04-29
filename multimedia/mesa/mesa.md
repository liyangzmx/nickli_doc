# mesa

## Install meson
直接下载就行, 假设路径: `~/download/meson-0.58.0rc1`

```
$ git clone --depth=1 https://gitlab.freedesktop.org/mesa/mesa.git -b 20.1
$ ~/download/meson-0.58.0rc1/meson.py build ..


WARNING: Ignoring LLVM CMake dependency because dynamic was requested
llvm-config found: NO need '>= 8.0.0'
Run-time dependency LLVM found: NO (tried cmake and config-tool)
Looking for a fallback subproject for the dependency llvm (modules: bitwriter, engine, mcdisassembler, mcjit, core, executionengine, scalaropts, transformutils, instcombine, amdgpu, native, bitreader, ipo, asmparser)

../meson.build:1419:2: ERROR: Neither a subproject directory nor a llvm.wrap file was found.
```

安装`llvm-8-dev`
```
$ sudo apt install llvm-8-dev
$ ~/download/meson-0.58.0rc1/meson.py build ..

llvm-config found: YES (/usr/bin/llvm-config-8) 8.0.0
Run-time dependency LLVM (modules: amdgpu, asmparser, bitreader, bitwriter, core, engine, executionengine, instcombine, ipo, mcdisassembler, mcjit, native, scalaropts, transformutils, coroutines) found: YES 8.0.0
Run-time dependency libelf found: NO (tried pkgconfig and cmake)

../meson.build:1475:4: ERROR: C shared or static library 'elf' not found
```

安装`libelf-dev`
```
$ sudo apt install libelf-dev
$ ~/download/meson-0.58.0rc1/meson.py build ..

Run-time dependency wayland-protocols found: NO (tried pkgconfig and cmake)

../meson.build:1578:2: ERROR: Dependency "wayland-protocols" not found, tried pkgconfig and cmake

A full log can be found at /home/liyang/srcs/mesa/build/build/meson-logs/meson-log.txt
```

安装`wayland-protocols`:
```
$ sudo apt install wayland-protocols
$ ~/download/meson-0.58.0rc1/meson.py build ..

Run-time dependency wayland-egl-backend found: NO (tried pkgconfig and cmake)

../meson.build:1582:4: ERROR: Dependency "wayland-egl-backend" not found, tried pkgconfig and cmake

A full log can be found at /home/liyang/srcs/mesa/build/build/meson-logs/meson-log.txt
```

安装`libwayland-egl-backend-dev`:
```
$ sudo apt install libwayland-egl-backend-dev
$ ~/download/meson-0.58.0rc1/meson.py build ..
$ cd build/
$ sudo apt install ninja
$ ninja
```