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

## cjson
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

doc: 

install:
```
sudo apt-get install libini-config-dev
```




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

doc: https://github.com/jpbarrette/curlpp/tree/master/examples`

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

quick: https://github.com/hyperrealm/libconfig/tree/master/examples/c

---