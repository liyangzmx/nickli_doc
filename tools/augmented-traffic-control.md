# Augmented Traffic Control

## 参考
* [Github - facebookarchive/augmented-traffic-control](https://github.com/facebookarchive/augmented-traffic-control)


## ATC的安装与配置
```
# 清理
$ pip3 uninstall django atc_thrift atcd django-atc-api django-atc-demo-ui django-atc-profile-storage
$ pip uninstall django atc_thrift atcd django-atc-api django-atc-demo-ui django-atc-profile-storage

# 安装
$ sudo pip install atc_thrift atcd django-atc-api django-atc-demo-ui django-atc-profile-storage
$ django-admin startproject atcui
$ cd atcui
```

修改配置文件:`atcui/settings.py`:
```
INSTALLED_APPS = (
    ...
    # Django ATC API
    'rest_framework',
    'atc_api',
    # Django ATC Demo UI
    'bootstrap_themes',
    'django_static_jquery',
    'atc_demo_ui',
    # Django ATC Profile Storage
    'atc_profile_storage',
)
```

修改配置文件`atcui/urls.py`:
```
...
...
from django.views.generic.base import RedirectView
from django.conf.urls import include

urlpatterns = [
    ...
    # Django ATC API
    url(r'^api/v1/', include('atc_api.urls')),
    # Django ATC Demo UI
    url(r'^atc_demo_ui/', include('atc_demo_ui.urls')),
    # Django ATC profile storage
    url(r'^api/v1/profiles/', include('atc_profile_storage.urls')),
    url(r'^$', RedirectView.as_view(url='/atc_demo_ui/', permanent=False)),
]
```

执行配置合并:
```
$ python manage.py migrate
```

## Ubuntu 20.04 LTS下的热点配置
打开终端, 输入:
```
$ nm-connection-editor
```
启动"网络链接"设置界面, 点击"+"创建一个链接, 进行如下设置:
* "Wi-Fi"选项卡:
  * SSID: "TestAP"(根据需要填写)
  * 模式: "热点"
  * 波段: "自动"
  * 频道: "默认"(不可选择)
  * 设备: ""(留空)
  * 克隆MAC地址: ""(留空)
  * MTU: 自动

* "Wi-Fi"安全性选项卡:
  * 安全: "WPA及WPA2个人"
  * 密码: "11111111"(根据需要填写, 不少于8个字符)

* "IPv4设置"
  * 方法: "与其它计算机共享"

然后的点击"保存".

打开"设置" -> "Wi-Fi", 点选打开按钮旁边的选项按钮, 点选"打开Wi-Fi热点", 点选后提示会断开当前网络, 点击"确定", 将自动启用"TestAP"热点.

## 启动ATC服务
启动ATC服务:
```
$ sudo atcd --atcd-lan wlp5s0 --atcd-wan enp6s0
```
注意, `wlp5s0`和`enp6s0`根据电脑的实际情况而定. 特别的:
** `wlp5s0`应是您计算机提供热点的网卡, 此处对应的是"TestAP"热点的网卡
** `enp6s0`应是您计算机接入外网的网卡, 此处对应的是提供ATC服务的计算机的有线网卡

启动Django服务:
```
$ python manage.py runserver 0.0.0.0:8000
```

导入facebook写好的配置:
```
$ git clone https://github.com/facebookarchive/augmented-traffic-control.git

$ cd augmented-traffic-control/
$ ./utils/restore-profiles.sh localhost:8000
```
如此配置将导入到服务当中;

电脑配置热点并使用手机链接, 假设链接后, 手机IP为:`10.42.0.233`, 电脑LAN的IP为: `10.42.0.1`, 则:  
使用手机访问: [http://0.0.0.0:8000/](http://0.0.0.0:8000/)

此时您可以段则对应的配置,如:`3G - Good`, 然后选择"Trun On"或者"Update Shapping"(在"Turn On"以后), 此时网络限制将仅用于您的手机. 

**注意** : 在整个过程中, 需要保持`sudo atcd --atcd-lan wlp5s0 --atcd-wan enp6s0`和`python manage.py runserver 0.0.0.0:8000`的运行, 考虑可以写成开机运行的方式, 该方式对应的配置文档后续再补上.