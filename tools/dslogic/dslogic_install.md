# DsLogic Ubuntu 20.04 安装

## 特别说明
如果想学习如何写插件, 最好clone官方的代码库:
```
git clone https://github.com/DreamSourceLab/DSView
```
应特别关注的目录:`libsigrokdecode4DSL/decoders/`  

另外关于`libsigrokdecode4DSL`, README有编译相关的信息, 其它信息可以从[sigrok](https://sigrok.org/wiki/Main_Page) 上获取, 对于开发, 应该关注的页面:  
* [**Protocol decoder HOWTO**](https://sigrok.org/wiki/Protocol_decoder_HOWTO)
* [**Protocol decoder API**](https://sigrok.org/wiki/Protocol_decoder_API)
* [libsigrokdecode](https://sigrok.org/wiki/Libsigrokdecode)
* [Protocol decoders](https://sigrok.org/wiki/Protocol_decoders)

## 下载
```
wget https://codeload.github.com/DreamSourceLab/DSView/tar.gz/v1.12 DSView_v1.12.tar.gz
tar xvf /download/DSView_v1.12.tar.gz
cd DSView-1.12/
```

## 编译libsigrok4DSL
```
cd libsigrok4DSL
./autogen.sh
sudo apt install libzip-dev
./configure
make -j64
sudo make install
cd ..
```

## 编译libsigrokdecode4DSL
```
cd libsigrokdecode4DSL/
sudo apt-get install qt5-default
sudo apt-get install libfftw3-dev
mkdir build
cd build
cmake ..
make -j64
sudo make install
```

然后开始使用吧~~