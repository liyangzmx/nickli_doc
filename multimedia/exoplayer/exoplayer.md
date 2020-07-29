# ExoPlayer - Hello World

## 官方参考
* [ExoPlayer Development Guid](https://exoplayer.dev/)
* [ExoPlayer - Hello World](https://exoplayer.dev/hello-world.html)
  
## 开始
Gradle(**app**)中添加:
```
implementation 'com.google.android.exoplayer:exoplayer:2.X.X'
```
其中`2.x.x`是版本号, 在[Release notes](https://github.com/google/ExoPlayer/blob/release-v2/RELEASENOTES.md)中有说明, 写本文时, 最新版本是: 2.11.7, 因此可以写成:
```
implementation 'com.google.android.exoplayer:exoplayer:2.11.7'
```

还要在**build.gradle**中添加Java 8的支持:
```
android {
    ... ...
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```
以上部分参考自: [使用 Java 8 语言功能](https://developer.android.com/studio/write/java8-support)

新建一个AndroidStudio项目, 在布局文件**activity_main.xml**中添加**PlayerView**:
```
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity">

    <com.google.android.exoplayer2.ui.PlayerView
        android:id="@+id/player_view"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        />

</androidx.constraintlayout.widget.ConstraintLayout>
```

代码实例:
```
public class MainActivity extends AppCompatActivity {
    private SimpleExoPlayer mSimpleExoPlayer;
    private PlayerView mPlayerView;
    Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mContext = getApplicationContext();

        mPlayerView = findViewById(R.id.player_view);
        mSimpleExoPlayer = new SimpleExoPlayer.Builder(mContext).build();
        mPlayerView.setPlayer(mSimpleExoPlayer);
        DataSource.Factory dataSourceFactory = new DefaultDataSourceFactory(mContext, Util.getUserAgent(mContext, "MainActivity"));
        Uri mp4VideoUri = Uri.parse("http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4");
        MediaSource videoSource = new ProgressiveMediaSource.Factory(dataSourceFactory).createMediaSource(mp4VideoUri);
        mSimpleExoPlayer.prepare(videoSource);
    }
}
```