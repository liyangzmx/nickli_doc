# 强制ExoPlayer调用ffmpeg实现G711的解码支持

## FFmpeg for ExoPlayer的基本编译
```
$ git clone https://github.com/google/ExoPlayer.git
$ cd ExoPlayer
$ git checkout -b release-v2 origin/release-v2
$ export NDK_PATH=~/Android/Sdk/ndk/21.3.6528147/
$ export HOST_PLATFORM="linux-x86_64"
$ git clone git://source.ffmpeg.org/ffmpeg
$ cd ffmpeg
$ git checkout release/4.2
$ export FFMPEG_PATH="$(pwd)"
$ cd ..
$ export ENABLED_DECODERS=(vorbis opus flac pcm_alaw)
$ export EXOPLAYER_ROOT="$(pwd)"
$ export FFMPEG_EXT_PATH="${EXOPLAYER_ROOT}/extensions/ffmpeg/src/main"
$ cd "${FFMPEG_EXT_PATH}/jni"
```
修改`build_ffmpeg.sh`脚本以支持静态库的链接方式:
```
$ git diff
diff --git a/extensions/ffmpeg/src/main/jni/build_ffmpeg.sh b/extensions/ffmpeg/src/main/jni/build_ffmpeg.sh
index 4660669a3..6e47eda3d 100755
--- a/extensions/ffmpeg/src/main/jni/build_ffmpeg.sh
+++ b/extensions/ffmpeg/src/main/jni/build_ffmpeg.sh
@@ -19,10 +19,25 @@ FFMPEG_EXT_PATH=$1
 NDK_PATH=$2
 HOST_PLATFORM=$3
 ENABLED_DECODERS=("${@:4}")
+# COMMON_OPTIONS="
+#     --target-os=android
+#     --disable-static
+#     --enable-shared
+#     --disable-doc
+#     --disable-programs
+#     --disable-everything
+#     --disable-avdevice
+#     --disable-avformat
+#     --disable-swscale
+#     --disable-postproc
+#     --disable-avfilter
+#     --disable-symver
+#     --disable-avresample
+#     --enable-swresample
+#     --extra-ldexeflags=-pie
+#     "
 COMMON_OPTIONS="
     --target-os=android
-    --disable-static
-    --enable-shared
     --disable-doc
     --disable-programs
     --disable-everything
@@ -49,6 +64,8 @@ cd "${FFMPEG_EXT_PATH}/jni/ffmpeg"
     --cross-prefix="${TOOLCHAIN_PREFIX}/armv7a-linux-androideabi16-" \
     --nm="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-nm" \
     --strip="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-strip" \
+    --ar="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-ar" \
+    --ranlib="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-ranlib" \
     --extra-cflags="-march=armv7-a -mfloat-abi=softfp" \
     --extra-ldflags="-Wl,--fix-cortex-a8" \
     ${COMMON_OPTIONS}
@@ -62,6 +79,8 @@ make clean
     --cross-prefix="${TOOLCHAIN_PREFIX}/aarch64-linux-android21-" \
     --nm="${TOOLCHAIN_PREFIX}/aarch64-linux-android-nm" \
     --strip="${TOOLCHAIN_PREFIX}/aarch64-linux-android-strip" \
+    --ar="${TOOLCHAIN_PREFIX}/aarch64-linux-android-ar" \
+    --ranlib="${TOOLCHAIN_PREFIX}/aarch64-linux-android-ranlib" \
     ${COMMON_OPTIONS}
 make -j4
 make install-libs
@@ -73,6 +92,8 @@ make clean
     --cross-prefix="${TOOLCHAIN_PREFIX}/i686-linux-android16-" \
     --nm="${TOOLCHAIN_PREFIX}/i686-linux-android-nm" \
     --strip="${TOOLCHAIN_PREFIX}/i686-linux-android-strip" \
+    --ar="${TOOLCHAIN_PREFIX}/i686-linux-android-ar" \
+    --ranlib="${TOOLCHAIN_PREFIX}/i686-linux-android-ranlib" \
     --disable-asm \
     ${COMMON_OPTIONS}
 make -j4
@@ -85,6 +106,8 @@ make clean
     --cross-prefix="${TOOLCHAIN_PREFIX}/x86_64-linux-android21-" \
     --nm="${TOOLCHAIN_PREFIX}/x86_64-linux-android-nm" \
     --strip="${TOOLCHAIN_PREFIX}/x86_64-linux-android-strip" \
+    --ar="${TOOLCHAIN_PREFIX}/x86_64-linux-android-ar" \
+    --ranlib="${TOOLCHAIN_PREFIX}/x86_64-linux-android-ranlib" \
     --disable-asm \
     ${COMMON_OPTIONS}
 make -j4
```

然后执行编译
```
$ ln -s "$FFMPEG_PATH" ffmpeg
$ ./build_ffmpeg.sh "${FFMPEG_EXT_PATH}" "${NDK_PATH}" "${HOST_PLATFORM}" "${ENABLED_DECODERS[@]}"
```

此时在目录`ffmpeg/android-libs/`下应该生成了静态库:
```
$ tree ffmpeg/android-libs/
ffmpeg/android-libs/
├── arm64-v8a
│   ├── libavcodec.a
│   ├── libavutil.a
│   └── libswresample.a
├── armeabi-v7a
│   ├── libavcodec.a
│   ├── libavutil.a
│   └── libswresample.a
├── x86
│   ├── libavcodec.a
│   ├── libavutil.a
│   └── libswresample.a
└── x86_64
    ├── libavcodec.a
    ├── libavutil.a
    └── libswresample.a

4 directories, 12 files
```

将静态库的`arm64-v8a`, `armeabi-v7a`, `x86`, 和`x86_64`分别拷贝到`app/libs/`下:
```
$ tree app/libs/
app/libs/
├── arm64-v8a
│   ├── libavcodec.a
│   ├── libavutil.a
│   └── libswresample.a
├── armeabi-v7a
│   ├── libavcodec.a
│   ├── libavutil.a
│   └── libswresample.a
├── x86
│   ├── libavcodec.a
│   ├── libavutil.a
│   └── libswresample.a
└── x86_64
    ├── libavcodec.a
    ├── libavutil.a
    └── libswresample.a
```

然后配置`app/build.gradle`:
```
android {
    compileSdkVersion 30
    buildToolsVersion "30.0.2"
    ... ...
    externalNativeBuild {
        cmake {
            path = 'src/main/cpp/CMakeLists.txt'
            version = '3.7.1+'
        }
    }
}

dependencies {
    implementation fileTree(dir: "libs", include: ["*.jar"])
    implementation 'androidx.appcompat:appcompat:1.1.0'
    ... ...

    // exo播放器
    api 'com.google.android.exoplayer:exoplayer:2.12.1'
    api 'com.google.android.exoplayer:exoplayer-core:2.12.1'
    api 'com.google.android.exoplayer:exoplayer-dash:2.12.1'
}
```

然后分别拷贝:
`extensions/ffmpeg/src/main/jni/CMakeLists.txt` -> `app/src/main/cpp/CMakeLists.txt`
`extensions/ffmpeg/src/main/jni/ffmpeg_jni.cc` -> `app/src/main/cpp/ffmpeg_jni.cc`
`extensions/ffmpeg/src/main/java/com/` -> `app/src/main/java/com/`

需要注意在`app/src/main/cpp/CMakeLists.txt`中:
```
... ...
project(libffmpeg_jni C CXX)

# ffmpeg_location需要重新配置为ffmpeg的真实路径
set(ffmpeg_location "${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg")
... ...
```

然后实现`DefaultRenderersFactory`的子类, 例如叫:`XXXRenderersFactory`, 则在`app/src/main/java/com/google/android/exoplayer2/ext/ffmpeg/`下创建`XXXRenderersFactory.java`文件, 然后重写`buildAudioRenderers()`方法:
```
package com.xxx.ffmpeg;

import android.content.Context;
import android.os.Handler;

import com.google.android.exoplayer2.DefaultRenderersFactory;
import com.google.android.exoplayer2.Renderer;
import com.google.android.exoplayer2.audio.AudioRendererEventListener;
import com.google.android.exoplayer2.audio.AudioSink;
import com.google.android.exoplayer2.mediacodec.MediaCodecSelector;
import com.google.android.exoplayer2.util.Log;

import java.lang.reflect.Constructor;
import java.util.ArrayList;

public class XXXRenderersFactory extends DefaultRenderersFactory {
    private static final String TAG = "XXXRenderersFactory";

    public XXXRenderersFactory(Context context) {
        super(context);
    }

    @Override
    protected void buildAudioRenderers(Context context, int extensionRendererMode, MediaCodecSelector mediaCodecSelector, boolean enableDecoderFallback, AudioSink audioSink, Handler eventHandler, AudioRendererEventListener eventListener, ArrayList<Renderer> out) {
        try {
            // 此类名应保持与jni层的cc文件中的接口名一致
            Class<?> clazz =
                    Class.forName("com.XXX.ffmpeg.XXXFfmpegAudioRenderer");
            Constructor<?> constructor =
                    clazz.getConstructor(
                            android.os.Handler.class,
                            com.google.android.exoplayer2.audio.AudioRendererEventListener.class,
                            com.google.android.exoplayer2.audio.AudioSink.class);
            Renderer renderer =
                    (Renderer) constructor.newInstance(eventHandler, eventListener, audioSink);
            out.add(0, renderer);
            // 将XXXFfmpegAudioRenderer设置为首选音频解码器, 优先使用软解码
            Log.i(TAG, "Loaded FfmpegAudioRenderer.");
        } catch (ClassNotFoundException e) {
            // Expected if the app was built without the extension.
        } catch (Exception e) {
            // The extension is present, but instantiation failed.
            throw new RuntimeException("Error instantiating FFmpeg extension", e);
        }
        // 从父类继续构造
        super.buildAudioRenderers(context, extensionRendererMode, mediaCodecSelector, enableDecoderFallback, audioSink, eventHandler, eventListener, out);
    }
}
```

使用时:
```
... ...
public class MainActivity extends AppCompatActivity {
    private SimpleExoPlayer mSimpleExoPlayer;
    private PlayerView mPlayerView;
    Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mContext = getApplicationContext();

        String dataPath = getApplication().getExternalCacheDir().getPath();

        mPlayerView = findViewById(R.id.player_view);
//        如果需要使用默认的解码工厂, 请使用如下注释中的代码, 并且可以省略libffmpeg_jni.so的编译.
//        mSimpleExoPlayer = new SimpleExoPlayer.Builder(mContext,
//                new DefaultRenderersFactory(mContext)).build()
        mSimpleExoPlayer = new SimpleExoPlayer.Builder(mContext,
                new XXXRenderersFactory(mContext)).build();
        mPlayerView.setPlayer(mSimpleExoPlayer);
        DataSource.Factory dataSourceFactory = new DefaultDataSourceFactory(mContext, Util.getUserAgent(mContext, "MainActivity"));
//        本demo中, dataPath对应的目录为: /storage/emulated/0/Android/data/com.example.exoext/cache
//        Uri mp4VideoUri = Uri.parse(dataPath + "/efg.mp4");
        Uri mp4VideoUri = Uri.parse(dataPath + "/abcd.mp4");
        MediaSource videoSource = new ProgressiveMediaSource.Factory(dataSourceFactory).createMediaSource(mp4VideoUri);
        mSimpleExoPlayer.prepare(videoSource);
    }
}
```