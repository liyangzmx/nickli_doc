# Ubuntu如何完成对Android手机的抓包

## Ubuntu新建热点
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

## Wireshark安装与捕获
使用如下命令确认WiFi网卡的设备名称:
```
$ ifconfig -a
... ...
wlp5s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.42.0.1  netmask 255.255.255.0  broadcast 10.42.0.255
        inet6 fe80::9822:34c2:7b8:c386  prefixlen 64  scopeid 0x20<link>
        ether 14:f6:d8:32:74:ae  txqueuelen 1000  (以太网)
        RX packets 263102  bytes 31407568 (31.4 MB)
        RX errors 0  dropped 1  overruns 0  frame 0
        TX packets 68965  bytes 10108014 (10.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
安装并以root权限启动Wireshark:
```
$ sudo apt install wireshark
$ sudo wireshark
```
启动wireshark后点选"wlp5s0"(根据你无线网卡实际的名称而定), 然后点击"捕获" -> "开始"即可开始捕获.

## Wireshark解码RTP包
右键点击捕获的UDP包选择"解码为", 弹出"Wireshark . Decode As...", 点选"当前"字段中的"(none)", 输入"RTP"或者手动点选也可, 即可解码为RTP包. 