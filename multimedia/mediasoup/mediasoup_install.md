# Ubuntu 20.04.1 LTS安装Mediasoup

## 安装Node.js和NPM
### 参考资料
[Node.js - Installation instructions](https://github.com/nodesource/distributions/blob/master/README.md)

注意Ubuntu和Debian两个系统命令上略有区别.

### 命令
```
$ curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
$ sudo apt-get update
$ sudo apt-get install -y nodejs
```

### 代理设置
```
$ npm -g config set proxy http://127.0.0.1:8118
npm ERR! code EACCES
npm ERR! syscall mkdir
npm ERR! path /usr/etc
npm ERR! errno -13
npm ERR! Error: EACCES: permission denied, mkdir '/usr/etc'
npm ERR!  [Error: EACCES: permission denied, mkdir '/usr/etc'] {
npm ERR!   errno: -13,
npm ERR!   code: 'EACCES',
npm ERR!   syscall: 'mkdir',
npm ERR!   path: '/usr/etc'
npm ERR! }
npm ERR! 
npm ERR! The operation was rejected by your operating system.
npm ERR! It is likely you do not have the permissions to access this file as the current user
npm ERR! 
npm ERR! If you believe this might be a permissions issue, please double-check the
npm ERR! permissions of the file and its containing directories, or try running
npm ERR! the command again as root/Administrator.

npm ERR! A complete log of this run can be found in:
npm ERR!     /home/nickli/.npm/_logs/2020-09-24T05_45_39_609Z-debug.log

# 配置registry
$ npm config set registry https://registry.npm.taobao.org
$ sudo npm config get registry
https://registry.npm.taobao.org/
```

## 安装Mediasoup
### 参考资料
[mediasoup](https://mediasoup.org/)

### 命令
```
$ npm install mediasoup

[..................] - rollbackFailedOptional: verb npm-session 7aaee2172ae95f4b
...

```

### 安装demo
```
$ git clone https://github.com/versatica/mediasoup-demo.git
$ cd mediasoup-demo
```