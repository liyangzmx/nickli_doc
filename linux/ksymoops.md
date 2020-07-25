# Ksymoops(编译报错)

## 来源
Linux官方文档中[https://www.kernel.org/doc/html/latest/admin-guide/README.html#if-something-goes-wrong](https://www.kernel.org/doc/html/latest/admin-guide/README.html#if-something-goes-wrong)的章节有提及到**ksymoops**这个工具, 尝试对齐进行本地(**X86**)的编译.

## 资料
* [ksymoops - download](https://mirrors.edge.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/)

## 源码&编译
```
wget https://mirrors.edge.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/ksymoops-2.4.11.tar.gz
tar xvf ksymoops-2.4.11.tar.gz
cd ksymoops-2.4.11/
make
```
报错:
```
gcc -Dlinux -Wall -Wno-conversion -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -DINSTALL_PREFIX="\"/usr\"" -DCROSS="\"\""  -DDEF_KSYMS=\"/proc/ksyms\" -DDEF_LSMOD=\"/proc/modules\" -DDEF_OBJECTS=\"/lib/modules/*r/\" -DDEF_MAP=\"/usr/src/linux/System.map\"   -c -o ksymoops.o ksymoops.c
In file included from ksymoops.c:14:
ksymoops.h:9:10: fatal error: bfd.h: No such file or directory
    9 | #include <bfd.h>
      |          ^~~~~~~
compilation terminated.
make: *** [<builtin>: ksymoops.o] Error 1
```
解决:
```
apt-file search bfd.h
sudo apt install binutils-dev
make
```
继续报错
```
oops.c:121:10: error: too many arguments to function 'bfd_set_section_alignment'
  121 |     if (!bfd_set_section_alignment(obfd, osec,
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ksymoops.h:9,
                 from oops.c:11:
/usr/include/bfd.h:1273:1: note: declared here
 1273 | bfd_set_section_alignment (asection *sec, unsigned int val)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
```
修改(fix_error.patch):
```
diff --git a/oops.c b/oops.c
index 75438fc..c23b491 100644
--- a/oops.c
+++ b/oops.c
@@ -113,12 +113,12 @@ static int Oops_write_bfd_data(const bfd *ibfd, bfd *obfd,
 	Oops_bfd_perror("make_section");
 	return(0);
     }
-    if (!bfd_set_section_flags(obfd, osec,
+    if (!bfd_set_section_flags(osec,
 	bfd_get_section_flags(ibfd, isec))) {
 	Oops_bfd_perror("set_section_flags");
 	return(0);
     }
-    if (!bfd_set_section_alignment(obfd, osec,
+    if (!bfd_set_section_alignment(osec,
 	bfd_get_section_alignment(ibfd, isec))) {
 	Oops_bfd_perror("set_section_alignment");
 	return(0);
@@ -136,11 +136,11 @@ static int Oops_write_bfd_data(const bfd *ibfd, bfd *obfd,
 	Oops_bfd_perror("set_symtab");
 	return(0);
     }
-    if (!bfd_set_section_size(obfd, osec, size)) {
+    if (!bfd_set_section_size(osec, size)) {
 	Oops_bfd_perror("set_section_size");
 	return(0);
     }
-    if (!bfd_set_section_vma(obfd, osec, 0)) {
+    if (!bfd_set_section_vma(osec, 0)) {
 	Oops_bfd_perror("set_section_vma");
 	return(0);
     }
```
继续报错:
```
/usr/bin/ld: cannot find -liberty
collect2: error: ld returned 1 exit status
make: *** [Makefile:111: ksymoops] Error 1
```
安装缺失的库:
```
sudo apt install libiberty-dev
make
```
继续报错:
```
/usr/bin/ld: oops.o: in function `Oops_write_bfd_data':
oops.c:(.text+0x490): undefined reference to `bfd_get_section_flags'
/usr/bin/ld: oops.c:(.text+0x4d2): undefined reference to `bfd_get_section_alignment'
/usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/9/../../../x86_64-linux-gnu/libbfd.a(plugin.o): in function `try_load_plugin':
/build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/plugin.c:273: undefined reference to `dlopen'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/plugin.c:347: undefined reference to `dlclose'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/plugin.c:305: undefined reference to `dlsym'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/plugin.c:273: undefined reference to `dlopen'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/plugin.c:276: undefined reference to `dlerror'
/usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/9/../../../x86_64-linux-gnu/libbfd.a(compress.o): in function `decompress_contents':
/build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/compress.c:51: undefined reference to `inflateInit_'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/compress.c:61: undefined reference to `inflateReset'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/compress.c:58: undefined reference to `inflate'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/compress.c:63: undefined reference to `inflateEnd'
/usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/9/../../../x86_64-linux-gnu/libbfd.a(compress.o): in function `bfd_compress_section_contents':
/build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/compress.c:127: undefined reference to `compressBound'
/usr/bin/ld: /build/binutils-hUoZyF/binutils-2.34/builddir-single/bfd/../../bfd/compress.c:174: undefined reference to `compress'
collect2: error: ld returned 1 exit status
make: *** [Makefile:111: ksymoops] Error 1
```

修改:
```
diff --git a/Makefile b/Makefile
index 0814b58..f78afef 100644
--- a/Makefile
+++ b/Makefile
@@ -108,7 +108,7 @@ all: $(PROGS)
 $(OBJECTS): $(DEFS)
 
 $(PROGS): %: %.o $(DEFS) $(OBJECTS)
-       $(CC) $(OBJECTS) $(CFLAGS) $(LDFLAGS) $(STATIC) -lbfd -liberty $(DYNAMIC) -o $@
+       $(CC) $(OBJECTS) $(CFLAGS) $(LDFLAGS) $(STATIC) -lbfd $(DYNAMIC) -ldl -lz -liberty -o $@
        -@size $@
 
 clean:
```

继续:
```
make
```
报错:
```
/usr/bin/ld: oops.o: in function `Oops_write_bfd_data':
oops.c:(.text+0x490): undefined reference to `bfd_get_section_flags'
/usr/bin/ld: oops.c:(.text+0x4d2): undefined reference to `bfd_get_section_alignment'
collect2: error: ld returned 1 exit status
make: *** [Makefile:111: ksymoops] Error 1
```

但是`binutils-dev`包总的`bfd.h`中确实没有`bfd_get_section_flags()`的定义, 这个问题无解决, 但是官方仍然提供了x86架构的二进制版本, 在官方下载渠道的中的rpm包中可提取这个二进制文件.