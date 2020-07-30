# FFmpeg基础

## AVFormat
`AVFormatContext *avformat_alloc_context(void);`  
用于分配一个`AVFormatContext`对象  

`int avformat_open_input(AVFormatContext **ps, const char *url, ff_const59 AVInputFormat *fmt, AVDictionary **options);`  
用于打开一个媒体

`int avformat_find_stream_info(AVFormatContext *ic, AVDictionary **options);`  
从媒体中查找可用的流, 执行上述方法后:  
* 可以通过`AVFormatContext`的`streams[i]->codecpar->codec_type`属性判断查找到的流的类型
* 可以通过`AVFormatContext`的`streams[videoStream]->codecpar->codec_id`的属性判断查找到的流对应的解码器

## AVCodec
`AVCodec *avcodec_find_decoder(enum AVCodecID id);`  
根据`AVCodecID`查找一个合适的解码器`AVCodec`

`AVCodecContext *avcodec_alloc_context3(const AVCodec *codec);`  
根据上面得到的`AVCodec`创建一个解码器上下文`AVCodecContext`

`int avcodec_open2(AVCodecContext *avctx, const AVCodec *codec, AVDictionary **options);`  
打开解码器, 打开后会更新`AVCodecContext`对应的信息

`int avcodec_send_packet(AVCodecContext *avctx, const AVPacket *avpkt);`  
解码一帧数据, 需要的参数为`AVPacket`, 可以用`av_read_frame()`函数从`AVFormatContext`中取得

`int avcodec_receive_frame(AVCodecContext *avctx, AVFrame *frame);`  
读取一帧解码后的数据, 返回一个`AVFrame`, 如果没有解码后的数据可读取, 则返回`AVERROR_EOF`, 也有可能返回一个`EAGAIN`, 此种情况可能是没有通过`avcodec_send_packet`发送足够的`AVPacket`, 数据不足导致的.

## AVFrame
`AVFrame *av_frame_alloc(void);`  
用于创建解码后的缓冲区

`int av_image_get_buffer_size(enum AVPixelFormat pix_fmt, int width, int height, int align);`  
用于计算对应格式的图片, 在长宽确定\对齐等条件确定的情况下, 需要的尺寸, 以byte计

`int av_image_fill_arrays(uint8_t *dst_data[4], int dst_linesize[4],
                         const uint8_t *src,
                         enum AVPixelFormat pix_fmt, int width, int height, int align);`  
用于填充一个`AVFrame`的数据区域, 一般用于输出`AVFrame`的初始化

`int av_read_frame(AVFormatContext *s, AVPacket *pkt);`  
从解码器中读取一个`AVPacket`, 也就是一帧数据

## Swscale
`struct SwsContext *sws_getContext(int srcW, int srcH, enum AVPixelFormat srcFormat,
                                  int dstW, int dstH, enum AVPixelFormat dstFormat,
                                  int flags, SwsFilter *srcFilter,
                                  SwsFilter *dstFilter, const double *param);`  
图像格式转换方法, 可以把`srcFormat`格式转换为`dstFormat`格式, 支持长宽设置, 只是设置转换参数等

## AvUtil
`int av_opt_set_int     (void *obj, const char *name, int64_t     val, int search_flags);`  
设置各种AvClass的参数

## Swresample
`struct SwrContext *swr_alloc(void);`  
分配一个重采样上下文

调用`av_opt_set_int()`设置`SwrContext`的参数, 例如:
```
av_opt_set_int(resampleContext, "in_channel_layout",  channelLayout, 0);
av_opt_set_int(resampleContext, "out_channel_layout", channelLayout, 0);
av_opt_set_int(resampleContext, "in_sample_rate", sampleRate, 0);
av_opt_set_int(resampleContext, "out_sample_rate", sampleRate, 0);
av_opt_set_int(resampleContext, "in_sample_fmt", sampleFormat, 0);
// The output format is always the requested format.
av_opt_set_int(resampleContext, "out_sample_fmt", context->request_sample_fmt, 0);
```

`int swr_init(struct SwrContext *s);`  
初始化重采样器, 要求用`av_opt_set_int()`设置好参数

在重采样前需要计算重采样后输出的数据的大小
`int av_get_bytes_per_sample(enum AVSampleFormat sample_fmt);`  
可以用来获取`AVSampleFormat`对应的每个sample对应的字节的大小

`int swr_get_out_samples(struct SwrContext *s, int in_samples);`  
获得重采样输出的sample数, 在设置完`SwrContext`后, 该函数才能返回正确的输出

此时重采样的输出可以从如下计算中得到:
$$
\begin{aligned}
    bufferOutSize = &av\_get\_bytes\_per\_sample(AVCodecContext_{request\_sample\_fmt})  \ \times \\ 
    &AVCodecContext_{channels} \times\ \\
    &swr\_get\_out\_samples(SwrContext, AVFrame_{nb\_samples})
\end{aligned}
$$
上述目的也可以用如下函数完成:  
`int av_samples_get_buffer_size(int *linesize, int nb_channels, int nb_samples,
                               enum AVSampleFormat sample_fmt, int align);
`

## COPY
`void *memcpy(void *__a, const void *__b, size_t __c)`  
在使用`memcpy`拷贝底层数据的时候注意:
* 对于`AVFrame`每行起始地址应该是:  
  $AVFrame_{data[0]} + AVCodecContext_{height} \times AVCodecContext_{linesize[0]}$

* 对于`AVFrame`每行起始地址应该是:  
  $ANativeWindow_{bits} + AVCodecContext_{height} \times ANativeWindow_{stride} \times 4$
这也是每一行数据都需要单独复制的原因

## 如何解码uint_8 *所指向的数据?
首先使用`void av_init_packet(AVPacket *pkt);`初始化一个`AVPacket`, 然后设置`AVPacket`的`uint8_t *data;`的成员, `int   size;`, 然后调用`int avcodec_send_packet(AVCodecContext *avctx, const AVPacket *avpkt);`正常走后面的流程即可.