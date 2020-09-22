# SQLCipher build in Ubuntu

按照官方文档, 需要的文件为`libcrypto.a`, 检索该文件所在的包:
```
$ apt-file search libcrypto.a
libssl-dev: /usr/lib/x86_64-linux-gnu/libcrypto.a
```

安装对应的包:
```
sudo apt-get install -y libssl-dev
正在读取软件包列表... 完成
正在分析软件包的依赖关系树       
正在读取状态信息... 完成       
libssl-dev 已经是最新版 (1.1.1f-1ubuntu2)
```

检索`libcrypto.a`在文件系统总的位置:
```
$ find /usr/ -name libcrypto.a
/usr/lib/x86_64-linux-gnu/libcrypto.a
```

因此配置命令为:
```
$ cd /tmp/
$ git clone https://github.com/sqlcipher/sqlcipher
$ cd sqlcipher/
$ ./configure --enable-tempstore=yes CFLAGS="-DSQLITE_HAS_CODEC" LDFLAGS="/usr/lib/x86_64-linux-gnu/libcrypto.a"

checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking how to print strings... printf
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking how to convert x86_64-pc-linux-gnu file names to x86_64-pc-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-pc-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking for gawk... gawk
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for a working dd... /usr/bin/dd
checking how to truncate binary pipes... /usr/bin/dd bs=4096 count=1
checking for mt... mt
checking if mt is a manifest tool... no
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking for a BSD-compatible install... /usr/bin/install -c
checking for special C compiler options needed for large files... no
checking for _FILE_OFFSET_BITS value needed for large files... no
checking for int8_t... yes
checking for int16_t... yes
checking for int32_t... yes
checking for int64_t... yes
checking for intptr_t... yes
checking for uint8_t... yes
checking for uint16_t... yes
checking for uint32_t... yes
checking for uint64_t... yes
checking for uintptr_t... yes
checking for sys/types.h... (cached) yes
checking for stdlib.h... (cached) yes
checking for stdint.h... (cached) yes
checking for inttypes.h... (cached) yes
checking malloc.h usability... yes
checking malloc.h presence... yes
checking for malloc.h... yes
checking for fdatasync... yes
checking for gmtime_r... yes
checking for isnan... yes
checking for localtime_r... yes
checking for localtime_s... no
checking for malloc_usable_size... yes
checking for strchrnul... yes
checking for usleep... yes
checking for utime... yes
checking for pread... yes
checking for pread64... yes
checking for pwrite... yes
checking for pwrite64... yes
checking for tclsh8.7... no
checking for tclsh8.6... tclsh8.6
configure: Version set to 3.31
configure: Release set to 3.31.0
configure: Version number set to 3031000
checking whether to support threadsafe operation... yes
checking for library containing pthread_create... -lpthread
checking for library containing pthread_mutexattr_init... none required
checking for crypto library to use... openssl
checking for HMAC_Init_ex in -lcrypto... yes
checking whether to allow connections to be shared across threads... no
checking whether to support shared library linked as release mode or not... no
checking whether to use an in-ram database for temporary tables... yes
checking if executables have the .exe suffix... unknown
checking for Tcl configuration... configure: WARNING: Can't find Tcl configuration definitions
configure: WARNING: *** Without Tcl the regression tests cannot be executed ***
configure: WARNING: *** Consider using --with-tcl=... to define location of Tcl ***
checking for library containing readline... no
checking for library containing tgetent... -lncurses
checking for readline in -lreadline... no
checking readline.h usability... no
checking readline.h presence... no
checking for readline.h... no
checking for /usr/include/readline.h... no
checking for /usr/include/readline/readline.h... no
checking for /usr/local/include/readline.h... no
checking for /usr/local/include/readline/readline.h... no
checking for /usr/local/readline/include/readline.h... no
checking for /usr/local/readline/include/readline/readline.h... no
checking for /usr/contrib/include/readline.h... no
checking for /usr/contrib/include/readline/readline.h... no
checking for /mingw/include/readline.h... no
checking for /mingw/include/readline/readline.h... no
checking for library containing fdatasync... none required
checking zlib.h usability... yes
checking zlib.h presence... yes
checking for zlib.h... yes
checking for library containing deflate... -lz
checking for library containing dlopen... -ldl
checking whether to support MEMSYS5... no
checking whether to support MEMSYS3... no
configure: creating ./config.status
config.status: creating Makefile
config.status: creating sqlcipher.pc
config.status: creating config.h
config.status: executing libtool commands
```

执行编译:
```
gcc  -DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL -o mksourceid /tmp/sqlcipher/tool/mksourceid.c
gcc  -DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL -o mkkeywordhash   /tmp/sqlcipher/tool/mkkeywordhash.c
gcc  -DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL -o lemon /tmp/sqlcipher/tool/lemon.c
tclsh8.6 /tmp/sqlcipher/tool/mkshellc.tcl >shell.c
./mkkeywordhash >keywordhash.h
tclsh8.6 /tmp/sqlcipher/tool/mksqlite3h.tcl /tmp/sqlcipher >sqlite3.h
cp /tmp/sqlcipher/tool/lempar.c .
cp /tmp/sqlcipher/src/parse.y .
cp /tmp/sqlcipher/ext/fts5/fts5parse.y .
./lemon   -S parse.y
rm -f fts5parse.h
... ...

*** Warning: Linking the shared library libsqlcipher.la against the
*** static library /usr/lib/x86_64-linux-gnu/libcrypto.a is not portable!
libtool: link: gcc -shared  -fPIC -DPIC  .libs/sqlite3.o   /usr/lib/x86_64-linux-gnu/libcrypto.a -ldl -lz -lcrypto -lpthread    -Wl,-soname -Wl,libsqlcipher.so.0 -o .libs/libsqlcipher.so.0.8.6
libtool: link: (cd ".libs" && rm -f "libsqlcipher.so.0" && ln -s "libsqlcipher.so.0.8.6" "libsqlcipher.so.0")
libtool: link: (cd ".libs" && rm -f "libsqlcipher.so" && ln -s "libsqlcipher.so.0.8.6" "libsqlcipher.so")
libtool: link: ar cru .libs/libsqlcipher.a /usr/lib/x86_64-linux-gnu/libcrypto.a  sqlite3.o
ar: `u' modifier ignored since `D' is the default (see `U')
libtool: link: ranlib .libs/libsqlcipher.a
libtool: link: ( cd ".libs" && rm -f "libsqlcipher.la" && ln -s "../libsqlcipher.la" "libsqlcipher.la" )
```

安装到本地的`__install/`, 并检查编译输出:
```
$ mkdir __install
$ make DESTDIR=`pwd`/__install/ install
$ tree __install/
__install/
└── usr
    └── local
        ├── bin
        │   └── sqlcipher
        ├── include
        │   └── sqlcipher
        │       ├── sqlite3ext.h
        │       └── sqlite3.h
        └── lib
            ├── libsqlcipher.a
            ├── libsqlcipher.la
            ├── libsqlcipher.so -> libsqlcipher.so.0.8.6
            ├── libsqlcipher.so.0 -> libsqlcipher.so.0.8.6
            ├── libsqlcipher.so.0.8.6
            └── pkgconfig
                └── sqlcipher.pc

7 directories, 9 files
```