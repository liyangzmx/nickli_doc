华硕路由器安装MerlinClash插件需要刷固件为其它版本, 这里我们选择Koolshare, 可以节省很多时间(官方的梅林固件已经不提供软件中心).

Merlin固件下载地址:  
[RT-AX68U_386.2_0_cferom_pureubi_koolshare.w](http://firmware.koolshare.cn/Koolshare_RMerl_New_Gen_386/RT-AX68U/RT-AX68U_386.2_0_cferom_pureubi_koolshare.w)

RT-AX68U是我的路由器的型号, 您可以选择Koolshare支持列表中的其它型号.

固件的升级非常简单, 直接在"系统管理"里上传".w"结尾的固件, 然后应用升级后, 路由器会自动升级并重启到新系统. 
注意: 新系统升级完成后, Koolshare系统会多一个"软件中心", 该板块非常重要, 后边安装MerlinClash就是如此进行的. 

MerlinClash插件从: https://t.me/merlinclashcat 获取, 选择: merlinclash_hnd_20210416.tar.gz即可

注意:
* 不要安装ss-merlin
* 不要安装trojan

配置注意: "系统管理" -> "系统设置":
* "Format JFFS partition at next boot	" : 是  (仅一次)
* "Enable JFFS custom scripts and configs	": 是

务必开启ssh登录, 登录命令一般是: ssh root@192.168.50.1(具体要视情况而定)
Windows下ssh客户端为putty, 使用方法需要自行百度.

为了防止离线安装国家法律不允许的插件而产生的报错, 请使用ssh登录到路由器后台, 并如下命令(不含```):
```
sed -i 's/\tdetect_package/\t# detect_package/g' /koolshare/scripts/ks_tar_install.sh
```

"软件中心" -> "离线安装" -> "选择文件" -> 选择: "merlinclash_hnd_20210416.tar.gz", 点击: "上传并安装"

这里是测试用的订阅地址: https://s.trojanflare.com/clashx/f693666f-9dd5-4ea8-aa14-9ce622122eda
