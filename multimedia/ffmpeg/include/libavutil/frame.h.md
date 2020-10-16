# AVFrame

```
typedef struct AVFrame {
    // ----- [共用] ----- 
    // 解码后原始数据（对视频来说是YUV，RGB，对音频来说是PCM
    uint8_t *data[AV_NUM_DATA_POINTERS];
    // data中“一行”数据的大小。注意：未必等于图像的宽，一般大于图像的宽
    int linesize[AV_NUM_DATA_POINTERS];
    uint8_t **extended_data;
    // 品质, 从1到FF_LAMBDA_MAX
    int quality;
    // 私有数据
    void *opaque;
    // 解码后原始数据类型（AVPixelFormat和AVSampleFormat）
    int format;
    int64_t reordered_opaque;
    AVBufferRef *buf[AV_NUM_DATA_POINTERS];
    AVBufferRef **extended_buf;
    int        nb_extended_buf;
    // 辅助数据结构
    AVFrameSideData **side_data;
    int            nb_side_data;
    // 旗语
    // AV_FRAME_FLAG_CORRUPT - 帧数据可能已损坏，例如 由于解码错误。
    // AV_FRAME_FLAG_DISCARD - 一个标志，用于标记需要解码但不应输出的帧。
    int flags;
    // 在流时基中使用各种启发式方法估计的帧时间戳
    int64_t best_effort_timestamp;
    // 从已输入解码器的最后一个AVPacket重新排序pos
    int64_t pkt_pos;
    // 相应数据包的持续时间，以AVStream->time_base单位表示，如果未知，则为0。
    int64_t pkt_duration;
    AVDictionary *metadata;
    // 解码帧的错误标志，如果解码器生成了一个帧，则将其设置为FF_DECODE_ERROR_xxx标志的组合，但是在解码过程中会出现错误。
    int decode_error_flags;
    // 包含压缩帧的相应数据包的大小。
    int pkt_size;
    // API用户自由使用的AVBufferRef
    AVBufferRef *opaque_ref;
    // AVBufferRef供单个libav *库内部使用。
    AVBufferRef *private_ref;

    // ----- [音频] ----- 
    // 音频的一个AVFrame中可能包含多个音频帧，在此标记包含了几个
    int nb_samples;
    // 音频采样率
    int sample_rate;
    // 音频数据layout方式, 参考AV_CH_LAYOUT_*
    uint64_t channel_layout;
    // 音频通道数，仅用于音频。
    int channels;

    // ----- [视频] ----- 
    // 显示时间戳
    int64_t pts;
    int64_t pkt_dts;
    // 编码帧序号
    int coded_picture_number;
    // 显示帧序号
    int display_picture_number;
    // 视频帧宽和高（1920x1080,1280x720...）
    int width, height;
    // 是否是关键帧
    int key_frame;
    // 帧类型（I,B,P,S,SI,SP,BI...）
    enum AVPictureType pict_type;
    // 宽高比（16:9，4:3...）
    AVRational sample_aspect_ratio;
    // 解码时延迟多少图片
    int repeat_pict;
    // 图像的内容是否是隔行扫描的
    int interlaced_frame;
    // 如果内容是隔行扫描的，则首先显示顶部字段。
    int top_field_first;
    // 告诉用户应用程序调色板已从上一帧更改。
    int palette_has_changed;
    // MPEG vs JPEG YUV范围FF_DECODE_ERROR_
    enum AVColorRange color_range;
    // YUV色度坐标
    enum AVColorPrimaries color_primaries;
    // 颜色转移特性
    enum AVColorTransferCharacteristic color_trc;
    // YUV色彩空间类型。
    enum AVColorSpace colorspace;
    // 色度样本位置
    enum AVChromaLocation chroma_location;
    // 对于hwaccel格式的帧，这应该是对描述该帧的AVHWFramesContext的引用。
    AVBufferRef *hw_frames_ctx;
    // 仅视频帧。 为了获得要呈现的帧子矩形，从帧的顶部/底部/左侧/右侧边界要舍弃的像素数。
    size_t crop_top;
    size_t crop_bottom;
    size_t crop_left;
    size_t crop_right;
} AVFrame;
```

`const char *av_get_colorspace_name(enum AVColorSpace val);`  
获取色彩空间的名字

`AVFrame *av_frame_alloc(void);`  
分配一个AVFrame并将其字段设置为默认值。 必须使用av_frame_free（）释放生成的结构。

`void av_frame_free(AVFrame **frame);`  
释放 `AVFrame`以及其中动态分配的数据结构

`int av_frame_ref(AVFrame *dst, const AVFrame *src);`  
设置对源框架描述的数据的新引用。

`AVFrame *av_frame_clone(const AVFrame *src);`  
深拷贝一阵AVFrame

`void av_frame_unref(AVFrame *frame);`  
取消引用帧引用的所有缓冲区，并重置帧字段。

`void av_frame_move_ref(AVFrame *dst, AVFrame *src);`  
将src中包含的所有内容移至dst并重置src。

`int av_frame_get_buffer(AVFrame *frame, int align);`  
为音频或视频数据分配新的缓冲区

`int av_frame_is_writable(AVFrame *frame);`  
检查帧数据是否可写。

`int av_frame_make_writable(AVFrame *frame);`  
确保帧数据可写，并尽可能避免复制数据。

`int av_frame_copy(AVFrame *dst, const AVFrame *src)`  
将帧数据从src复制到dst。

`int av_frame_copy_props(AVFrame *dst, const AVFrame *src);`  
仅将“元数据”字段从src复制到dst。

`AVBufferRef *av_frame_get_plane_buffer(AVFrame *frame, int plane);`  
获取存储给定数据平面的缓冲区引用。

`AVFrameSideData *av_frame_new_side_data(AVFrame *frame,
                                        enum AVFrameSideDataType type,
                                        int size);`  
将新的辅助数据添加到AVFrame。

`AVFrameSideData *av_frame_new_side_data_from_buf(AVFrame *frame,
                                                 enum AVFrameSideDataType type,
                                                 AVBufferRef *buf);`  
从现有的AVBufferRe向帧添加新的辅助数据

`AVFrameSideData *av_frame_get_side_data(const AVFrame *frame,
                                        enum AVFrameSideDataType type);`  
成功返回给定类型的辅助数据的指针，如果在此帧中没有具有该类型的辅助数据，则返回NULL。

`void av_frame_remove_side_data(AVFrame *frame, enum AVFrameSideDataType type);`  
删除并释放给定类型的所有辅助数据实例。

`int av_frame_apply_cropping(AVFrame *frame, int flags);`  
根据其crop_left / crop_top / crop_right / crop_bottom字段裁剪给定视频AVFrame。 如果裁剪成功，该函数将调整数据指针和宽度/高度字段，并将裁剪字段设置为0。

`const char *av_frame_side_data_name(enum AVFrameSideDataType type);`  
返回标识辅助数据类型的字符串