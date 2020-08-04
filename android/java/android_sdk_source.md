# 关于"Source for 'Android API 30 Platform' not found"

获取sdk源码:
```
export PATH=$PATH:~/Android/Sdk/tools/bin/
sdkmanager "platform-tools" "sources;android-30"
```
得到:
```
Warning: File /home/nickli/.android/repositories.cfg could not be loaded.       
Warning: Failed to find package sources;android-30 
```
创建缺失的文件
```
touch ~/.android/repositories.cfg
```

再次执行`sdkmanager "platform-tools" "sources;android-30"`得到提示:
```
Warning: Failed to find package sources;android-30
```

更改命令为:
```
sdkmanager "platform-tools" "sources;android-29"
```

修改`build.gradle`, 把`compileSdkVersion`降为`29`, 重新同步即可.

此时sdk的源码位于`~/Android/Sdk/sources/android-29`