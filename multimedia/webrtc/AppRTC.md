### Coturn安装
```
$ sudo apt-get install libssl-dev -y
$ sudo apt-get install libevent-dev -y
$ git clone https://github.com/coturn/coturn
$ cd coturn/
$ ./configure
$ make
$ make install
$ sudo nohup turnserver -L 0.0.0.0 -a -u liayng:liyangsw -v -f -r nort.gov &
```

### AppRTC安装
命令:
```
$ git clone https://github.com/webrtc/apprtc.git
$ sudo apt install npm
$ cd apprtc/
$ sudo apt install python-pip
$ pip install -r requirements.txt
Requirement already satisfied: requests in /usr/local/lib/python2.7/dist-packages (from -r requirements.txt (line 1))
Collecting webtest (from -r requirements.txt (line 2))

  Downloading http://us1.mirrors.cloud.aliyuncs.com/pypi/packages/fd/8c/3d36c39f458d986ee3aaea7683f186613df1225818dc076e75c5002eca81/WebTest-2.0.35-py2.py3-none-any.whl
Requirement already satisfied: urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1 in /usr/local/lib/python2.7/dist-packages (from requests->-r requirements.txt (line 1))
Requirement already satisfied: chardet<4,>=3.0.2 in /usr/local/lib/python2.7/dist-packages (from requests->-r requirements.txt (line 1))
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python2.7/dist-packages (from requests->-r requirements.txt (line 1))
Requirement already satisfied: idna<3,>=2.5 in /usr/lib/python2.7/dist-packages (from requests->-r requirements.txt (line 1))
Requirement already satisfied: six in /usr/lib/python2.7/dist-packages (from webtest->-r requirements.txt (line 2))
Collecting waitress>=0.8.5 (from webtest->-r requirements.txt (line 2))
  Downloading http://us1.mirrors.cloud.aliyuncs.com/pypi/packages/26/d1/5209fb8c764497a592363c47054436a515b47b8c3e4970ddd7184f088857/waitress-1.4.4-py2.py3-none-any.whl (58kB)
    100% |████████████████████████████████| 61kB 317kB/s 
Collecting WebOb>=1.2 (from webtest->-r requirements.txt (line 2))
  Downloading http://us1.mirrors.cloud.aliyuncs.com/pypi/packages/18/3c/de37900faff3c95c7d55dd557aa71bd77477950048983dcd4b53f96fde40/WebOb-1.8.6-py2.py3-none-any.whl (114kB)
    100% |████████████████████████████████| 122kB 265kB/s 
Collecting beautifulsoup4 (from webtest->-r requirements.txt (line 2))
  Downloading http://us1.mirrors.cloud.aliyuncs.com/pypi/packages/43/2e/1cd0a1bc2faae7dc446b0cf8caf22900e64b9295fe01183c0d8fabf0667f/beautifulsoup4-4.9.2-py2-none-any.whl (115kB)
    100% |████████████████████████████████| 122kB 265kB/s 
Collecting soupsieve<2.0,>1.2; python_version < "3.0" (from beautifulsoup4->webtest->-r requirements.txt (line 2))
  Downloading http://us1.mirrors.cloud.aliyuncs.com/pypi/packages/39/36/f35056eb9978a622bbcedc554993d10777e3c6ff1ca24cde53f4be9c5fc4/soupsieve-1.9.6-py2.py3-none-any.whl
Collecting backports.functools-lru-cache; python_version < "3" (from soupsieve<2.0,>1.2; python_version < "3.0"->beautifulsoup4->webtest->-r requirements.txt (line 2))
  Downloading http://us1.mirrors.cloud.aliyuncs.com/pypi/packages/da/d1/080d2bb13773803648281a49e3918f65b31b7beebf009887a529357fd44a/backports.functools_lru_cache-1.6.1-py2.py3-none-any.whl
Installing collected packages: waitress, WebOb, backports.functools-lru-cache, soupsieve, beautifulsoup4, webtest
Successfully installed WebOb-1.8.6 backports.functools-lru-cache-1.6.1 beautifulsoup4-4.9.2 soupsieve-1.9.6 waitress-1.4.4 webtest-2.0.35


$ npm install
loadDevDep:webrtc-adapter ▐ ╢██████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟
loadDep:rimraf → headers  ▌ ╢████████████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟
npm WARN deprecated urix@0.1.0: Please see https://github.com/lydell/urix#deprecated
npm WARN deprecated resolve-url@0.2.1: https://github.com/lydell/resolve-url#deprecated
loadDep:colors            ▀ ╢█████████████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟
loadDep:lodash → afterAdd ▀ ╢█████████████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟
npm WARN deprecated iltorb@2.4.5: The zlib module provides APIs for brotli compression/decompression starting with Node.js v10.16.0, please use it over iltorb
loadDep:callsites → 200   ▄ ╢████████████████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟
loadDep:chokidar          ▌ ╢██████████████████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟
loadDep:spdx-exceptions → ▄ ╢███████████████████████████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟

> iltorb@2.4.5 install /root/apprtc/node_modules/iltorb
> node ./scripts/install.js || node-gyp rebuild

info looking for cached prebuild @ /root/.npm/_prebuilds/488314-iltorb-v2.4.5-node-v57-linux-x64.tar.gz
http request GET https://github.com/nstepien/iltorb/releases/download/v2.4.5/iltorb-v2.4.5-node-v57-linux-x64.tar.gz
http 200 https://github.com/nstepien/iltorb/releases/download/v2.4.5/iltorb-v2.4.5-node-v57-linux-x64.tar.gz
info downloading to @ /root/.npm/_prebuilds/488314-iltorb-v2.4.5-node-v57-linux-x64.tar.gz.16146-2260c0d253404.tmp
info renaming to @ /root/.npm/_prebuilds/488314-iltorb-v2.4.5-node-v57-linux-x64.tar.gz
info unpacking @ /root/.npm/_prebuilds/488314-iltorb-v2.4.5-node-v57-linux-x64.tar.gz
info unpack resolved to /root/apprtc/node_modules/iltorb/build/bindings/iltorb.node
info unpack required /root/apprtc/node_modules/iltorb/build/bindings/iltorb.node successfully
info install Successfully installed iltorb binary!

> travis-multirunner@4.6.0 postinstall /root/apprtc/node_modules/travis-multirunner
> node bin/travis-sync

apprtc@1.0.0 /root/apprtc
├── eslint-config-webrtc@1.0.0 
├─┬ grunt@1.3.0 
│ ├── dateformat@3.0.3 
... ...
│ ├── djo-shell@1.7.0 
│ ├── formatter@0.4.1 
│ └─┬ normalize-package-data@2.5.0 
│   ├── hosted-git-info@2.8.8 
│   ├── semver@5.7.1 
│   └─┬ validate-npm-package-license@3.0.4 
│     ├─┬ spdx-correct@3.1.1 
│     │ └── spdx-license-ids@3.0.6 
│     └─┬ spdx-expression-parse@3.0.1 
│       └── spdx-exceptions@2.3.0 
└─┬ webrtc-adapter@7.7.0 
  ├── rtcpeerconnection-shim@1.2.15 
  └── sdp@2.12.0 
npm WARN optional Skipping failed optional dependency /chokidar/fsevents:
npm WARN notsup Not compatible with your operating system or architecture: fsevents@2.1.3

$ sudo apt install node-grunt-cli
$ grunt build
Running "shell:buildAppEnginePackage" (shell) task

Running "shell:genJsEnums" (shell) task
src >>> src/web_app/js

Running "shell:copyAdapter" (shell) task

Running "shell:copyJsFiles" (shell) task

Done.
```

### 安装Google App SDK
参考[快速入门：开始使用 Cloud SDK](https://cloud.google.com/sdk/docs/quickstart)和[设置开发环境](https://cloud.google.com/appengine/docs/standard/python/setting-up-environment)安装:
```
$ cd
$ wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-309.0.0-linux-x86_64.tar.gz
$ tar xvf google-cloud-sdk-309.0.0-linux-x86_64.tar.gz
$ cd google-cloud-sdk
$ ./google-cloud-sdk/install.sh
Welcome to the Google Cloud SDK!
WARNING: You appear to be running this script as root. This may cause 
the installation to be inaccessible to users other than the root user.

To help improve the quality of this product, we collect anonymized usage data
and anonymized stacktraces when crashes are encountered; additional information
is available at <https://cloud.google.com/sdk/usage-statistics>. This data is
handled in accordance with our privacy policy
<https://policies.google.com/privacy>. You may choose to opt in this
collection now (by choosing 'Y' at the below prompt), or at any time in the
future by running the following command:

    gcloud config set disable_usage_reporting false

Do you want to help improve the Google Cloud SDK (y/N)?  N


Your current Cloud SDK version is: 309.0.0
The latest available version is: 311.0.0

┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   Components                                                  │
├──────────────────┬──────────────────────────────────────────────────────┬──────────────────────────┬──────────┤
│      Status      │                         Name                         │            ID            │   Size   │
├──────────────────┼──────────────────────────────────────────────────────┼──────────────────────────┼──────────┤
│ Update Available │ Cloud SDK Core Libraries                             │ core                     │ 15.9 MiB │
│ Not Installed    │ App Engine Go Extensions                             │ app-engine-go            │  4.9 MiB │
│ Not Installed    │ Appctl                                               │ appctl                   │ 21.0 MiB │
│ Not Installed    │ Cloud Bigtable Command Line Tool                     │ cbt                      │  7.7 MiB │
│ Not Installed    │ Cloud Bigtable Emulator                              │ bigtable                 │  6.6 MiB │
│ Not Installed    │ Cloud Datalab Command Line Tool                      │ datalab                  │  < 1 MiB │
│ Not Installed    │ Cloud Datastore Emulator                             │ cloud-datastore-emulator │ 18.4 MiB │
│ Not Installed    │ Cloud Firestore Emulator                             │ cloud-firestore-emulator │ 41.0 MiB │
│ Not Installed    │ Cloud Pub/Sub Emulator                               │ pubsub-emulator          │ 34.9 MiB │
│ Not Installed    │ Cloud SQL Proxy                                      │ cloud_sql_proxy          │  7.5 MiB │
│ Not Installed    │ Cloud Spanner Emulator                               │ cloud-spanner-emulator   │ 21.4 MiB │
│ Not Installed    │ Emulator Reverse Proxy                               │ emulator-reverse-proxy   │ 14.5 MiB │
│ Not Installed    │ Google Cloud Build Local Builder                     │ cloud-build-local        │  6.0 MiB │
│ Not Installed    │ Google Container Registry's Docker credential helper │ docker-credential-gcr    │  1.8 MiB │
│ Not Installed    │ Kind                                                 │ kind                     │  4.5 MiB │
│ Not Installed    │ Kustomize                                            │ kustomize                │ 25.9 MiB │
│ Not Installed    │ Minikube                                             │ minikube                 │ 24.1 MiB │
│ Not Installed    │ Nomos CLI                                            │ nomos                    │ 17.7 MiB │
│ Not Installed    │ Skaffold                                             │ skaffold                 │ 14.5 MiB │
│ Not Installed    │ anthos-auth                                          │ anthos-auth              │ 16.0 MiB │
│ Not Installed    │ gcloud Alpha Commands                                │ alpha                    │  < 1 MiB │
│ Not Installed    │ gcloud Beta Commands                                 │ beta                     │  < 1 MiB │
│ Not Installed    │ gcloud app Java Extensions                           │ app-engine-java          │ 59.5 MiB │
│ Not Installed    │ gcloud app Python Extensions                         │ app-engine-python        │  6.1 MiB │
│ Not Installed    │ gcloud app Python Extensions (Extra Libraries)       │ app-engine-python-extras │ 27.1 MiB │
│ Not Installed    │ kpt                                                  │ kpt                      │ 11.1 MiB │
│ Not Installed    │ kubectl                                              │ kubectl                  │  < 1 MiB │
│ Installed        │ BigQuery Command Line Tool                           │ bq                       │  < 1 MiB │
│ Installed        │ Cloud Storage Command Line Tool                      │ gsutil                   │  3.5 MiB │
└──────────────────┴──────────────────────────────────────────────────────┴──────────────────────────┴──────────┘
To install or remove components at your current SDK version [309.0.0], run:
  $ gcloud components install COMPONENT_ID
  $ gcloud components remove COMPONENT_ID

To update your SDK installation to the latest version [311.0.0], run:
  $ gcloud components update


Modify profile to update your $PATH and enable shell command 
completion?

Do you want to continue (Y/n)?  

The Google Cloud SDK installer will now prompt you to update an rc 
file to bring the Google Cloud CLIs into your environment.

Enter a path to an rc file to update, or leave blank to use 
[/root/.bashrc]:  
Backing up [/root/.bashrc] to [/root/.bashrc.backup].
[/root/.bashrc] has been updated.

==> Start a new shell for the changes to take effect.


For more information on how to get started, please visit:
  https://cloud.google.com/sdk/docs/quickstarts

$ source ~/.bashrc
$ gcloud components install app-engine-python
Your current Cloud SDK version is: 309.0.0
Installing components from version: 309.0.0

┌───────────────────────────────────────────────────┐
│        These components will be installed.        │
├──────────────────────────────┬─────────┬──────────┤
│             Name             │ Version │   Size   │
├──────────────────────────────┼─────────┼──────────┤
│ Cloud Datastore Emulator     │   2.1.0 │ 18.4 MiB │
│ gRPC python library          │  1.20.0 │          │
│ gRPC python library          │  1.20.0 │  2.1 MiB │
│ gcloud app Python Extensions │  1.9.91 │  6.1 MiB │
└──────────────────────────────┴─────────┴──────────┘

For the latest full release notes, please visit:
  https://cloud.google.com/sdk/release_notes

Do you want to continue (Y/n)? Y
╔════════════════════════════════════════════════════════════╗
╠═ Creating update staging area                             ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: Cloud Datastore Emulator                     ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: gRPC python library                          ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: gRPC python library                          ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: gcloud app Python Extensions                 ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Creating backup and activating new installation          ═╣
╚════════════════════════════════════════════════════════════╝
Performing post processing steps...done.                                                                                                                                         

Update done!
```

### AppRTC服务配置
```
diff --git a/src/app_engine/constants.py b/src/app_engine/constants.py
index 682331b..07ef481 100644
--- a/src/app_engine/constants.py
+++ b/src/app_engine/constants.py
@@ -22,40 +22,36 @@ LOOPBACK_CLIENT_ID = 'LOOPBACK_CLIENT_ID'
 # directly rather than retrieving them from an ICE server provider.
 ICE_SERVER_OVERRIDE = None
 # Enable by uncomment below and comment out above, then specify turn and stun
-# ICE_SERVER_OVERRIDE  = [
-#   {
-#     "urls": [
-#       "turn:hostname/IpToTurnServer:19305?transport=udp",
-#       "turn:hostname/IpToTurnServer:19305?transport=tcp"
-#     ],
-#     "username": "TurnServerUsername",
-#     "credential": "TurnServerCredentials"
-#   },
-#   {
-#     "urls": [
-#       "stun:hostname/IpToStunServer:19302"
-#     ]
-#   }
-# ]
-
-ICE_SERVER_BASE_URL = 'https://appr.tc'
+ICE_SERVER_OVERRIDE  = [
+  {
+    "urls": [
+      "turn:198.11.179.227:3478?transport=udp",
+      "turn:198.11.179.227:3478?transport=tcp"
+    ],
+    "username": "liyang",
+    "credential": "liyangsw"
+  },
+  {
+    "urls": [
+      "stun:198.11.179.227:3478"
+    ]
+  }
+]
+
+ICE_SERVER_BASE_URL = 'http://198.11.179.227:8080'
 ICE_SERVER_URL_TEMPLATE = '%s/v1alpha/iceconfig?key=%s'
 ICE_SERVER_API_KEY = os.environ.get('ICE_SERVER_API_KEY')
 HEADER_MESSAGE = os.environ.get('HEADER_MESSAGE')
 ICE_SERVER_URLS = [url for url in os.environ.get('ICE_SERVER_URLS', '').split(',') if url]
 
 # Dictionary keys in the collider instance info constant.
-WSS_INSTANCE_HOST_KEY = 'host_port_pair'
+WSS_INSTANCE_HOST_KEY = '198.11.179.227:8080'
 WSS_INSTANCE_NAME_KEY = 'vm_name'
 WSS_INSTANCE_ZONE_KEY = 'zone'
 WSS_INSTANCES = [{
-    WSS_INSTANCE_HOST_KEY: 'apprtc-ws.webrtc.org:443',
+    WSS_INSTANCE_HOST_KEY: '198.11.179.227:8080',
     WSS_INSTANCE_NAME_KEY: 'wsserver-std',
     WSS_INSTANCE_ZONE_KEY: 'us-central1-a'
-}, {
-    WSS_INSTANCE_HOST_KEY: 'apprtc-ws-2.webrtc.org:443',
-    WSS_INSTANCE_NAME_KEY: 'wsserver-std-2',
-    WSS_INSTANCE_ZONE_KEY: 'us-central1-f'
 }]
 
 WSS_HOST_PORT_PAIRS = [ins[WSS_INSTANCE_HOST_KEY] for ins in WSS_INSTANCES]
```

### 启动AppRTC服务
```
$ cd apprtc/
$ dev_appserver.py --host 198.11.179.227 --enable_host_checking false ./out/app_engine
This action requires the installation of components: [app-engine-
python-extras]


Your current Cloud SDK version is: 309.0.0
Installing components from version: 309.0.0

┌─────────────────────────────────────────────────────────────────────┐
│                 These components will be installed.                 │
├────────────────────────────────────────────────┬─────────┬──────────┤
│                      Name                      │ Version │   Size   │
├────────────────────────────────────────────────┼─────────┼──────────┤
│ gcloud app Python Extensions (Extra Libraries) │  1.9.90 │ 27.1 MiB │
└────────────────────────────────────────────────┴─────────┴──────────┘

For the latest full release notes, please visit:
  https://cloud.google.com/sdk/release_notes

Do you want to continue (Y/n)?  

╔════════════════════════════════════════════════════════════╗
╠═ Creating update staging area                             ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: gcloud app Python Extensions (Extra Libra... ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Creating backup and activating new installation          ═╣
╚════════════════════════════════════════════════════════════╝
Performing post processing steps...done.                                                                                                                                         

Update done!

Restarting command:
  $ dev_appserver.py --host 198.11.179.227 --enable_host_checking false ./out/app_engine

INFO     2020-09-28 09:52:37,895 devappserver2.py:289] Skipping SDK update check.
INFO     2020-09-28 09:52:37,937 api_server.py:282] Starting API server at: http://localhost:39459
INFO     2020-09-28 09:52:37,943 dispatcher.py:267] Starting module "default" running at: http://0.0.0.0:8080
INFO     2020-09-28 09:52:37,944 admin_server.py:150] Starting admin server at: http://localhost:8000
INFO     2020-09-28 09:52:39,965 instance.py:294] Instance PID: 24515
```

参考的链接日志:
```
INFO     2020-09-28 09:52:37,895 devappserver2.py:289] Skipping SDK update check.
INFO     2020-09-28 09:52:37,937 api_server.py:282] Starting API server at: http://localhost:39459
INFO     2020-09-28 09:52:37,943 dispatcher.py:267] Starting module "default" running at: http://0.0.0.0:8080
INFO     2020-09-28 09:52:37,944 admin_server.py:150] Starting admin server at: http://localhost:8000
INFO     2020-09-28 09:52:39,965 instance.py:294] Instance PID: 24515
INFO     2020-09-28 09:52:57,460 apprtc.py:393] Added client 02488705 in room 11111111, retries = 0
INFO     2020-09-28 09:52:57,460 apprtc.py:95] Applying media constraints: {'video': True, 'audio': True}
WARNING  2020-09-28 09:52:57,461 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:52:57,461 apprtc.py:536] User 02488705 joined room 11111111
INFO     2020-09-28 09:52:57,461 apprtc.py:537] Room 11111111 has state ['02488705']
INFO     2020-09-28 09:52:57,464 module.py:865] default: "POST /join/11111111 HTTP/1.1" 200 894
INFO     2020-09-28 09:52:58,687 apprtc.py:393] Added client 66602191 in room 11111111, retries = 0
WARNING  2020-09-28 09:52:58,687 analytics.py:38] Unable to build BigQuery API object. Logging disabled.
INFO     2020-09-28 09:52:58,687 analytics.py:95] Event: {'rows': [{'json': {u'event_type': u'ROOM_SIZE_2', u'room_id': '11111111', u'timestamp': '2020-09-28T09:52:58.687454', u'host': '198.11.179.227:8080'}}]}
INFO     2020-09-28 09:52:58,687 apprtc.py:95] Applying media constraints: {'video': True, 'audio': True}
WARNING  2020-09-28 09:52:58,688 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:52:58,689 apprtc.py:536] User 66602191 joined room 11111111
INFO     2020-09-28 09:52:58,689 apprtc.py:537] Room 11111111 has state ['02488705', '66602191']
INFO     2020-09-28 09:52:58,691 module.py:865] default: "POST /join/11111111 HTTP/1.1" 200 895
INFO     2020-09-28 09:52:58,972 apprtc.py:479] Forwarding message to collider for room 11111111 client 02488705
WARNING  2020-09-28 09:52:58,973 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:52:59,159 apprtc.py:479] Forwarding message to collider for room 11111111 client 02488705
WARNING  2020-09-28 09:52:59,161 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:52:59,164 apprtc.py:479] Forwarding message to collider for room 11111111 client 02488705
WARNING  2020-09-28 09:52:59,165 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:52:59,176 apprtc.py:479] Forwarding message to collider for room 11111111 client 02488705
WARNING  2020-09-28 09:52:59,177 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:52:59,496 module.py:865] default: "POST /message/11111111/02488705 HTTP/1.1" 200 21
INFO     2020-09-28 09:52:59,559 module.py:865] default: "POST /message/11111111/02488705 HTTP/1.1" 200 21
INFO     2020-09-28 09:52:59,560 module.py:865] default: "POST /message/11111111/02488705 HTTP/1.1" 200 21
INFO     2020-09-28 09:52:59,562 module.py:865] default: "POST /message/11111111/02488705 HTTP/1.1" 200 21
INFO     2020-09-28 09:55:02,922 apprtc.py:431] Removed client 66602191 from room 11111111, retries=0
INFO     2020-09-28 09:55:02,922 apprtc.py:470] Room 11111111 has state ['02488705']
INFO     2020-09-28 09:55:02,925 module.py:865] default: "POST /leave/11111111/66602191 HTTP/1.1" 200 -
INFO     2020-09-28 09:55:02,989 apprtc.py:431] Removed client 02488705 from room 11111111, retries=0
INFO     2020-09-28 09:55:02,989 apprtc.py:470] Room 11111111 has state None
INFO     2020-09-28 09:55:02,991 module.py:865] default: "POST /leave/11111111/02488705 HTTP/1.1" 200 -
INFO     2020-09-28 09:55:10,906 apprtc.py:393] Added client 55324424 in room 11111111, retries = 0
INFO     2020-09-28 09:55:10,906 apprtc.py:95] Applying media constraints: {'video': True, 'audio': True}
WARNING  2020-09-28 09:55:10,907 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:55:10,907 apprtc.py:536] User 55324424 joined room 11111111
INFO     2020-09-28 09:55:10,908 apprtc.py:537] Room 11111111 has state ['55324424']
INFO     2020-09-28 09:55:10,909 module.py:865] default: "POST /join/11111111 HTTP/1.1" 200 894
INFO     2020-09-28 09:55:12,106 apprtc.py:393] Added client 54970191 in room 11111111, retries = 0
INFO     2020-09-28 09:55:12,106 analytics.py:95] Event: {'rows': [{'json': {u'event_type': u'ROOM_SIZE_2', u'room_id': '11111111', u'timestamp': '2020-09-28T09:55:12.106594', u'host': '198.11.179.227:8080'}}]}
INFO     2020-09-28 09:55:12,106 apprtc.py:95] Applying media constraints: {'video': True, 'audio': True}
WARNING  2020-09-28 09:55:12,108 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 09:55:12,108 apprtc.py:536] User 54970191 joined room 11111111
INFO     2020-09-28 09:55:12,108 apprtc.py:537] Room 11111111 has state ['54970191', '55324424']
INFO     2020-09-28 09:55:12,110 module.py:865] default: "POST /join/11111111 HTTP/1.1" 200 895
INFO     2020-09-28 10:04:29,315 apprtc.py:95] Applying media constraints: {'video': {'mandatory': {}, 'optional': [{'minWidth': '1280'}, {'minHeight': '720'}]}, 'audio': True}
WARNING  2020-09-28 10:04:29,316 apprtc.py:139] Invalid or no value returned from memcache, using fallback: null
INFO     2020-09-28 10:04:29,326 module.py:865] default: "GET / HTTP/1.1" 200 8742
INFO     2020-09-28 10:04:29,584 module.py:865] default: "GET /css/main.css HTTP/1.1" 304 -
^CINFO     2020-09-28 10:08:00,162 shutdown.py:50] Shutting down.
INFO     2020-09-28 10:08:00,162 stub_util.py:377] Applying all pending transactions and saving the datastore
INFO     2020-09-28 10:08:00,162 stub_util.py:380] Saving search indexes
```