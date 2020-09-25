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

### 配置registry
```
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
$ git checkout v3
$ cd server
$ npm install
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.13 (node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.13: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})

up to date in 6.491s

30 packages are looking for funding
  run `npm fund` for details

$ npm start

> mediasoup-demo-server@3.0.0 start /home/nickli/mediasoup-demo/server
> DEBUG=${DEBUG:='*mediasoup* *INFO* *WARN* *ERROR*'} INTERACTIVE=${INTERACTIVE:='true'} node server.js

internal/modules/cjs/loader.js:896
  throw err;
  ^

Error: Cannot find module './config'
Require stack:
- /home/nickli/mediasoup-demo/server/server.js
    at Function.Module._resolveFilename (internal/modules/cjs/loader.js:893:15)
    at Function.Module._load (internal/modules/cjs/loader.js:743:27)
    at Module.require (internal/modules/cjs/loader.js:965:19)
    at require (internal/modules/cjs/helpers.js:88:18)
    at Object.<anonymous> (/home/nickli/mediasoup-demo/server/server.js:6:16)
    at Module._compile (internal/modules/cjs/loader.js:1076:30)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:1097:10)
    at Module.load (internal/modules/cjs/loader.js:941:32)
    at Function.Module._load (internal/modules/cjs/loader.js:782:14)
    at Function.executeUserEntryPoint [as runMain] (internal/modules/run_main.js:72:12) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [ '/home/nickli/mediasoup-demo/server/server.js' ]
}
npm ERR! code ELIFECYCLE
npm ERR! errno 1
npm ERR! mediasoup-demo-server@3.0.0 start: `DEBUG=${DEBUG:='*mediasoup* *INFO* *WARN* *ERROR*'} INTERACTIVE=${INTERACTIVE:='true'} node server.js`
npm ERR! Exit status 1
npm ERR! 
npm ERR! Failed at the mediasoup-demo-server@3.0.0 start script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.

npm ERR! A complete log of this run can be found in:
npm ERR!     /home/nickli/.npm/_logs/2020-09-25T06_52_58_663Z-debug.log
```

原因, 可能是安装过程中遇到了错误, 比如网络不好等原因, 做一些处理和重试:
```
$ npm cache clean --force
$ rm -rf node_modules package-lock.json
$ npm install
npm WARN deprecated chokidar@2.1.8: Chokidar 2 will break on node v14+. Upgrade to chokidar 3 with 15x less dependencies.
npm WARN deprecated fsevents@1.2.13: fsevents 1 will break on node v14+ and could be using insecure binaries. Upgrade to fsevents 2.
npm WARN deprecated resolve-url@0.2.1: https://github.com/lydell/resolve-url#deprecated
npm WARN deprecated har-validator@5.1.5: this library is no longer supported
[        ..........] / extract:xtend: sill extract xtend@~2.1.1 extracted to /home/nickli/mediasoup-demo/server/node_modules/.staging/xtend-1ebf6c97 (28037ms)
npm ERR! code ECONNRESET
npm ERR! errno ECONNRESET
npm ERR! network request to https://registry.npm.taobao.org/validate-npm-package-name/download/validate-npm-package-name-3.0.0.tgz failed, reason: Client network socket disconnected before secure TLS connection was established
npm ERR! network This is a problem related to network connectivity.
npm ERR! network In most cases you are behind a proxy or have bad network settings.
npm ERR! network 
npm ERR! network If you are behind a proxy, please make sure that the
npm ERR! network 'proxy' config is set properly.  See: 'npm help config'

npm ERR! A complete log of this run can be found in:
npm ERR!     /home/nickli/.npm/_logs/2020-09-25T07_01_24_960Z-debug.log
```

网络问题... 反复重试:
```
$ npm cache clean --force
$ rm -rf node_modules package-lock.json
$ npm install
... ...
unziping /home/nickli/.clang-tools/clang-tools-r298696-linux.tgz

gzip: stdin: unexpected end of file
tar: 归档文件中异常的 EOF
tar: 归档文件中异常的 EOF
tar: Error is not recoverable: exiting now
... ...

make -j32 BUILDTYPE=Release -C out
make[1]: 进入目录“/home/nickli/mediasoup-demo/server/node_modules/mediasoup/worker/out”
  CC(target) /home/nickli/mediasoup-demo/server/node_modules/mediasoup/worker/out/Release/obj.target/libsrtp/deps/libsrtp/srtp/srtp/ekt.o
  CC(target) /home/nickli/mediasoup-demo/server/node_modules/mediasoup/worker/out/Release/obj.target/libsrtp/deps/libsrtp/srtp/srtp/srtp.o
  CC(target) /home/nickli/mediasoup-demo/server/node_modules/mediasoup/worker/out/Release/obj.target/libsrtp/deps/libsrtp/srtp/crypto/cipher/aes.o
... ...

make[1]: 离开目录“/home/nickli/mediasoup-demo/server/node_modules/mediasoup/worker/out”
make: 离开目录“/home/nickli/mediasoup-demo/server/node_modules/mediasoup/worker”
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.13 (node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.13: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})

added 935 packages from 464 contributors in 2027.092s

30 packages are looking for funding
  run `npm fund` for details
```

无休止的报错, 待续...