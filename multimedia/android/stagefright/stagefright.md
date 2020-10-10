# StageFright 命令

## 编译stagefright
```
$ cd ~/work/aosp/
$ lunch build/envsetup.sh
$ lunch aosp_marlin-userdebug
$ m stagefright
============================================
PLATFORM_VERSION_CODENAME=REL
PLATFORM_VERSION=10
TARGET_PRODUCT=aosp_marlin
TARGET_BUILD_VARIANT=userdebug
... ...
OUT_DIR=out
PRODUCT_SOONG_NAMESPACES=device/google/marlin vendor/google/camera hardware/google/pixel
============================================
[100% 4/4] Install: out/target/product/marlin/system/bin/stagefright

#### build completed successfully (3 seconds) ####

$ adb root
$ adb disable-verity
$ adb remount
$ adb sync system
$ adb shell stagefright -o -a /data/media/0/Download/MOM.mp3
could not create extractor.
```
查看logcat日志:
```
0-02 18:04:37.671   773  3560 I ServiceManager: Waiting for service 'media.extractor' on '/dev/binder'...
10-02 18:04:38.078  4073  4073 W ServiceManager: Service media.extractor didn't start. Returning NULL
10-02 18:04:38.079  4073  4073 E MediaExtractorFactory: extractor service not running
10-02 18:04:38.673   773  3560 I ServiceManager: Waiting for service 'media.extractor' on '/dev/binder'...
10-02 18:04:40.941  4077  4077 F linker  : CANNOT LINK EXECUTABLE "/system/bin/mediaextractor": library "libavservices_minijail.so" not found
10-02 18:04:40.676   773  3560 I chatty  : uid=1013(media) Binder:773_2 identical 2 lines
10-02 18:04:41.679   773  3560 I ServiceManager: Waiting for service 'media.extractor' on '/dev/binder'...
10-02 18:04:42.681   773  3560 W ServiceManager: Service media.extractor didn't start. Returning NULL
10-02 18:04:42.681   773  3560 E MediaExtractorFactory: extractor service not running
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: Ignoring troubled file: /system/product/media/audio/ui/NFCTransferInitiated.ogg
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: java.io.IOException: java.lang.RuntimeException: setDataSource failed: status = 0x80000000
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner.scanItemAudio(ModernMediaScanner.java:647)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner.scanItem(ModernMediaScanner.java:498)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner.access$500(ModernMediaScanner.java:118)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner$Scan.visitFile(ModernMediaScanner.java:406)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner$Scan.visitFile(ModernMediaScanner.java:207)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at java.nio.file.Files.walkFileTree(Files.java:2670)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at java.nio.file.Files.walkFileTree(Files.java:2742)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner$Scan.walkFileTree(ModernMediaScanner.java:267)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner$Scan.run(ModernMediaScanner.java:245)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner.scanDirectory(ModernMediaScanner.java:166)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.MediaService.onScanVolume(MediaService.java:150)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.MediaService.onScanVolume(MediaService.java:131)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.MediaService.onHandleIntent(MediaService.java:86)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at android.app.IntentService$ServiceHandler.handleMessage(IntentService.java:78)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at android.os.Handler.dispatchMessage(Handler.java:107)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at android.os.Looper.loop(Looper.java:214)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at android.os.HandlerThread.run(HandlerThread.java:67)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: Caused by: java.lang.RuntimeException: setDataSource failed: status = 0x80000000
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at android.media.MediaMetadataRetriever.setDataSource(Native Method)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at android.media.MediaMetadataRetriever.setDataSource(MediaMetadataRetriever.java:142)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	at com.android.providers.media.scan.ModernMediaScanner.scanItemAudio(ModernMediaScanner.java:614)
10-02 18:04:42.688  2312  2531 W ModernMediaScanner: 	... 16 more
10-02 18:04:42.712   773  3560 I ServiceManager: Waiting for service 'media.extractor' on '/dev/binder'...
```

发现确实`libavservices_minijail.so`, 编译该文件:
```
$ m libavservices_minijail
============================================
PLATFORM_VERSION_CODENAME=REL
PLATFORM_VERSION=10
TARGET_PRODUCT=aosp_marlin
TARGET_BUILD_VARIANT=userdebug
... ...
OUT_DIR=out
PRODUCT_SOONG_NAMESPACES=device/google/marlin vendor/google/camera hardware/google/pixel
============================================
[100% 14/14] Copy: out/target/product/marlin/obj/SHARED_LIBRARIES/libavservices_minijail_intermediates/libavservices_minijail.so.toc

#### build completed successfully (3 seconds) ####

$ adb -s HT69N0201861 sync system
/home/nickli/work/aosp/out/target/product/marlin/system/: 2 files pushed. 3028 files skipped. 0.1 MB/s (39404 bytes in 0.295s)
$ adb shell stagefright -o -a /data/media/0/Download/MOM.mp3
```

如果还有报错, 同步后重启手机.