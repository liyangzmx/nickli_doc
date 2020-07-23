# Nginx + RTMP

安装nginx和libnginx-mod-rtmp:
```
sudo apt install nginx
sudo apt install libnginx-mod-rtmp
```

/etc/nginx/nginx.conf 添加
```
rtmp {
	server {
		listen 1935;
		application live {
			live on;
		}
	}
}
```

启动nginx服务
```
sudo service nginx restart
```

下载测试视频:
```
wget http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
```

安装ffmpeg
```
sudo apt install ffmpeg
```

执行本地推流测试
```
ffmpeg -re -i big_buck_bunny.mp4 -f flv rtmp://127.0.0.1:1935/live
```