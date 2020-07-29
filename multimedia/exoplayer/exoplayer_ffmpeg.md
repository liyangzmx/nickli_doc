# ExoPlayer 解码器扩展

## SimpleDecoderVideoRenderer的子类实现

实现类`SimpleDecoderVideoRenderer`的子类, 例如`FFmpegDecoderVideoRenderer`, 然后实现构造函数, 对于父类的构造函数, `drmSessionManager`和`playClearSamplesWithoutKeys`可以根据实际情况填写成`null`和`false`

然后实现方法:`supportsFormatInternal()`, `createDecoder()`, `renderOutputBufferToSurface()`和`setDecoderOutputMode()`, 其中:  
* `protected int supportsFormatInternal(@Nullable DrmSessionManager<ExoMediaCrypto> drmSessionManager, Format format) {}`  
  
    调用`RendererCapabilities.create()`方法返回是否支持要求的类型, 其中:
    * 如果不支持, 则`return RendererCapabilities.create(FORMAT_UNSUPPORTED_TYPE);`
    * 如果支持, 则需要根据情况, 调用`RendererCapabilities` 的  
        `static int create( @FormatSupport int formatSupport, @AdaptiveSupport int adaptiveSupport, @TunnelingSupport int tunnelingSupport)`  
        方法, 表示对要求的类型的支持情况
* `protected SimpleDecoder<VideoDecoderInputBuffer, ? extends VideoDecoderOutputBuffer, ? extends VideoDecoderException> createDecoder(Format format, @Nullable ExoMediaCrypto mediaCrypto) throws VideoDecoderException {}`
    
    需要返回一个SimpleDecoder的子类, 例如:`FFmpegDecoder`, 其基本写法:  
    `public class FFmpegDecoder extends SimpleDecoder<VideoDecoderInputBuffer, VideoDecoderOutputBuffer, FFmpegDecoderException>{}`  
    其中: `FFmpegDecoderException` 是`VideoDecoderException`的子类, 需要实现其两种形式的构造函数:  
    * `public FFmpegDecoderException(String message)`
    * `public FFmpegDecoderException(String message, Throwable cause)`  
    推荐在`FFmpegDecoder`类中加载需要的so库文件, 例如:
    ```
        public class FFmpegDecoder extends ... {
            static {
                System.loadLibrary("avutil");
                System.loadLibrary("swresample");
                System.loadLibrary("avformat");
                System.loadLibrary("avcodec");
                System.loadLibrary("swscale");
                System.loadLibrary("avfilter");
                System.loadLibrary("avresample");
                System.loadLibrary("avdevice");
            }
            ...
        }
    ```
  
    然后实现其构造函数  
    `public FFmpegDecoder(VideoDecoderInputBuffer[] inputBuffers, VideoDecoderOutputBuffer[] outputBuffers, long ffmpeg_ctx)`

    分别重写以下方法:  
    * `protected VideoDecoderInputBuffer createInputBuffer()`  
        此方法可以直接返回`return new VideoDecoderInputBuffer();`, 例如:
        ```
        @Override
        protected VideoDecoderInputBuffer createInputBuffer() {
            return new VideoDecoderInputBuffer();
        }
        ```
    * `protected VideoDecoderOutputBuffer createOutputBuffer()`  
        同上, 例如:
        ```
        @Override
        protected VideoDecoderOutputBuffer createOutputBuffer() {
            return new VideoDecoderOutputBuffer(this::releaseOutputBuffer);
        }
        ```
        注意`return new VideoDecoderOutputBuffer(this::releaseOutputBuffer);`时有一个参数, 这个参数可以是重写后的`this::releaseOutputBuffer`, 负责释放输出的Buffer.
    * `protected FFmpegDecoderException createUnexpectedDecodeException(Throwable error)` 
        用于创建`VideoDecoderException`的子类`FFmpegDecoderException`, 例如:
        ```
        @Override
        protected VpxDecoderException createUnexpectedDecodeException(Throwable error) {
            return new VpxDecoderException("Unexpected decode error", error);
        }
        ```
    * `protected FFmpegDecoderException decode(VideoDecoderInputBuffer   inputBuffer, VideoDecoderOutputBuffer outputBuffer, boolean reset)`
        实现实际的解码功能, 此处返回的是`FFmpegDecoderException`, 对于没有异常的情况, 返回`NULL`,
    * `public String getName()`  
        返回解码器的名称
    * `protected void releaseOutputBuffer(VideoDecoderOutputBuffer outputBuffer)`  
        释放解码器的输出Buffer
* `protected void renderOutputBufferToSurface(VideoDecoderOutputBuffer outputBuffer, Surface surface) throws VideoDecoderException {}`  
  
  完成渲染数据到Surface的工作

* `protected void setDecoderOutputMode(int outputMode)`  

  设置输出模式, 输出模式有三种:  
    ```
    /** Video decoder output mode is not set. */
    public static final int VIDEO_OUTPUT_MODE_NONE = -1;
    /** Video decoder output mode that outputs raw 4:2:0 YUV planes. */
    public static final int VIDEO_OUTPUT_MODE_YUV = 0;
    /** Video decoder output mode that renders 4:2:0 YUV planes directly to a surface. */
    public static final int VIDEO_OUTPUT_MODE_SURFACE_YUV = 1;
    ```

## VideoDecoderInputBuffer.data 到 Native
`VideoDecoderInputBuffer`中的数据是放在其父类`DecoderInputBuffer`中的:  
```
/** The buffer's data, or {@code null} if no data has been set. */
  @Nullable public ByteBuffer data;
```
所以一般情况下到达Native层的`ByteBuffer`会表现为: `jobject`, 此时:
使用`JNIEnv`的`GetDirectBufferAddress()`方法可以得到`ByteBuffer`的数据指针, 类型为:`void*`, 然后用`reinterpret_cast<const uint8_t*>(<指针>)`对`void*`进行转换, 比如可得到`const uint8_t* const buffer`

然后调用ffmpeg进行解码后, 得到的数据指针.

## VideoDecoderOutputBuffer 到 Native
对于`VideoDecoderOutputBuffer`直接到Native的情况:
1. 通过`JNIEnv`的`jclass FindClass(const char* name)`方法获得`VideoDecoderOutputBuffer`对应的`jclass`, 例如:
```
    // Populate JNI References.
    const jclass outputBufferClass = env->FindClass(
        "com/google/android/exoplayer2/video/VideoDecoderOutputBuffer");
```
2. 然后通过`JNIEnv`的`jfieldID GetFieldID(jclass clazz, "data", "I")`方法得到`data`成员的`jfieldID`, 例如:
```
    jfieldID dataField = env->GetFieldID(outputBufferClass, "data",
                              "Ljava/nio/ByteBuffer;");
```
3. 最后通过`JNIEnv`的`GetObjectField()`方法, 通过传入`data`成员的`jfieldID`, 这样可以得到对应的`jobject`, 最后通过`JNIEnv`的`Get`方法得到`byte *`指针, 例如:
```
    const jobject dataObject = env->GetObjectField(jOutputBuffer, dataField);
    jbyte* const data =
        reinterpret_cast<jbyte*>(env->GetDirectBufferAddress(dataObject));
```
4. 使用`memcpy()`向data拷贝数据, 但是请注意拷贝的数据长度