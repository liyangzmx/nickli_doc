# DsLogic Ubuntu 安装

下载
```
wget https://codeload.github.com/DreamSourceLab/DSView/tar.gz/v1.12 DSView_v1.12.tar.gz
tar xvf /download/DSView_v1.12.tar.gz
cd DSView-1.12/
```

编译libsigrok4DSL
```
cd libsigrok4DSL
./autogen.sh
sudo apt install libzip-dev
./configure
make -j64
sudo make install
cd ..
```

编译libsigrokdecode4DSL
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