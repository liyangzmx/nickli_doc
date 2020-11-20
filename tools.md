- [常用工具](#常用工具)
- [C Libraries](#c-libraries)
  - [netfilter](#netfilter)
    - [libnfnetlink](#libnfnetlink)
  - [libiconv](#libiconv)
  - [libpcap](#libpcap)
  - [libnl](#libnl)
    - [libnl](#libnl-1)
    - [libnl-genl](#libnl-genl)
    - [libnl-route](#libnl-route)
    - [libnl-nf](#libnl-nf)
  - [libnanomsg](#libnanomsg)
  - [libcjson](#libcjson)
  - [libconfig](#libconfig)
  - [libxml2](#libxml2)
  - [libini-config](#libini-config)
  - [libfftw3](#libfftw3)
  - [libsox](#libsox)
  - [libtinyalsa](#libtinyalsa)
  - [libevent](#libevent)
  - [libusb](#libusb)
  - [libssl](#libssl)
  - [libpng16](#libpng16)
- [C++ Libraries](#c-libraries-1)
  - [curlpp](#curlpp)
  - [libjsoncpp](#libjsoncpp)

# 常用工具

|名称|链接|文档|
|:-|:-|:-|
|Anaconda|https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/|https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/|
|VSCode - plantuml|https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml|https://plantuml.com/|
|gource|https://github.com/acaudwell/Gource/releases/download/gource-0.51/gource-0.51.tar.gz|https://gource.io/|
|git-repo|https://mirrors.tuna.tsinghua.edu.cn/git/git-repo|https://mirrors.tuna.tsinghua.edu.cn/help/git-repo/|
|sdkmanager|https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip|https://developer.android.com/studio/command-line/sdkmanager|
|platform-tools|https://dl.google.com/android/repository/platform-tools_r30.0.4-linux.zip|https://developer.android.com/studio/releases/platform-tools|
|ninja-build|[APT]|https://ninja-build.org/manual.html|
|nginx|[APT]|http://nginx.org/en/docs/|


# C Libraries

## netfilter
official: https://www.netfilter.org/

### libnfnetlink
link: **-lnfnetlink**

---

## libiconv
official: https://www.gnu.org/software/libiconv/

doc: https://www.gnu.org/savannah-checkouts/gnu/libiconv/documentation/libiconv-1.15/

---

## libpcap
official: https://www.tcpdump.org/

github: https://github.com/the-tcpdump-group/libpcap

doc: https://github.com/the-tcpdump-group/libpcap/tree/master/doc

doc: https://sharkfestus.wireshark.org/sharkfest.11/presentations/McCanne-Sharkfest'11_Keynote_Address.pdf

---

## libnl
official: https://www.infradead.org/~tgr/libnl/
### libnl
### libnl-genl
### libnl-route
### libnl-nf

---

## libnanomsg
github: https://github.com/nanomsg/nanomsg

install:
```
sudo apt-get install libnanomsg-dev
```

include:
```
#include <nanomsg/nn.h>
#include <nanomsg/pipeline.h>
```

link: **-lnanomsg**

doc: https://nanomsg.org/gettingstarted/index.html

---

## libcjson
github: https://github.com/DaveGamble/cJSON

install:
```
sudo apt-get install libcjson-dev
```

include:
```
#include <cjson/cJSON.h>
```

link: **-lcjson**

doc: https://github.com/DaveGamble/cJSON#example

---

## libconfig
github: https://github.com/hyperrealm/libconfig

install:
```
sudo apt-get install libconfig-dev
```

include:
```
#include <libconfig.h>
```

doc: https://hyperrealm.github.io/libconfig/libconfig_manual.html

quick: https://github.com/hyperrealm/libconfig/tree/master/examples/c

link: **-lconfig**

---

## libxml2
github:

install:
```
sudo apt-get install libxml2-dev
```

link: **-lxml2**

doc: https://github.com/GNOME/libxml2/tree/master/doc/examples

## libini-config
source: https://pagure.io/SSSD/ding-libs

install:
```
sudo apt-get install libini-config-dev
```

link: **-lconfig**

---

## libfftw3

official: http://www.fftw.org/

doc: http://www.fftw.org/fftw3_doc/

tutorial: http://www.fftw.org/fftw3_doc/Complex-One_002dDimensional-DFTs.html#Complex-One_002dDimensional-DFTs

install:
```
sudo apt-get install libfftw3-dev
```

link: **-libfftw3 -lm**

quick: http://www2.math.uu.se/~figueras/Other/examples/
quick: https://rtoax.blog.csdn.net/article/details/99199083

---

## libsox

official:

github: https://github.com/dmkrepo/libsox

doc: http://sox.sourceforge.net/libsox.html

install:
```
sudo apt-get install sox libsox-dev
```

link: **-lsox**

quick: https://github.com/dmkrepo/libsox/blob/master/src/example0.c

---

## libtinyalsa
github: https://github.com/tinyalsa/tinyalsa

install:
```
git clone https://github.com/tinyalsa/tinyalsa
cd tinyalsa/
mkdir build
cd build/
cmake ..
make -j32
sudo make install
```

link: **-ltinyalsa**

---

## libevent

official: https://libevent.org/

github: https://github.com/libevent/libevent

doc: http://www.wangafu.net/~nickm/libevent-2.1/doxygen/html/

quick: https://github.com/libevent/libevent/tree/master/sample

---

## libusb
official: https://libusb.info/

github: https://github.com/libusb/libusb

doc: http://libusb.sourceforge.net/api-1.0/

install: 
```
sudo apt-get install libusb-dev
```

link: **-lusb-1.0**

quick: https://github.com/libusb/libusb/tree/master/examples  
quick: https://github.com/libusb/libusb/blob/master/examples/listdevs.c

---

## libssl

install:
```
sudo apt-get install libssl-dev
```

---

## libpng16
official: http://www.libpng.org/pub/png/libpng.html

doc: http://www.libpng.org/pub/png/libpng-manual.txt

github: https://github.com/glennrp/libpng

install: 
```
sudo apt-get install libpng-dev
```

quick: https://github.com/glennrp/libpng/blob/libpng16/example.c

---



---

# C++ Libraries

## curlpp
github:

install:
```
sudo apt-get install libcurl4-openssl-dev
sudo apt-get install libcurlpp-dev
```

link:
```
-Llib/x86_64-linux-gnu -lcurlpp -Wl,-Bsymbolic-functions -Wl,-z,relro -lcurl
```

doc: https://github.com/jpbarrette/curlpp/tree/master/examples

---

## libjsoncpp
github: https://github.com/open-source-parsers/jsoncpp

install:
```
sudo apt-get install libjsoncpp-dev
```

include:
```
#include <jsoncpp/json/json.h>
```

link: **-ljsoncpp**

doc: http://open-source-parsers.github.io/jsoncpp-docs/doxygen/index.html
quick: https://en.wikibooks.org/wiki/JsonCpp

---