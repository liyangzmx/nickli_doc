# AVPacket

```
typedef struct AVPacket {
    AVBufferRef *buf;
    // 显示时间，结合AVStream->time_base转换成时间戳
    int64_t pts;
    // 解码时间，结合AVStream->time_base转换成时间戳
    int64_t dts;
    // 指向保存压缩数据的指针，这就是AVPacket的实际数据。
    uint8_t *data;
    // data的大小
    int   size;
    // packet在stream的index位置
    int   stream_index;
    // 标示，结合AV_PKT_FLAG使用，其中最低为1表示该数据是一个关键帧。
    // AV_PKT_FLAG_KEY    0x0001 //关键帧
    // AV_PKT_FLAG_CORRUPT 0x0002 //损坏的数据
    // AV_PKT_FLAG_DISCARD  0x0004 /丢弃的数据
    int   flags;
    // 容器提供的一些附加数据
    AVPacketSideData *side_data;
    // 边缘数据元数个数
    int side_data_elems;
    // 数据的时长，以所属媒体流的时间基准为单位，未知则值为默认值0
    int64_t duration;
    // 数据在流媒体中的位置，未知则值为默认值-1
    int64_t pos;
} AVPacket;
```

`AVPacket *av_packet_alloc(void);`  
分配AVPacket并将其字段设置为默认值。 必须使用av_packet_free（）释放生成的结构。

`AVPacket *av_packet_clone(const AVPacket *src);`  
创建一个引用与src相同的数据的新数据包。

`void av_packet_free(AVPacket **pkt);`  
释放数据包，如果该数据包被引用计数，它将首先被未引用。

`void av_init_packet(AVPacket *pkt);`  
使用默认值初始化数据包的可选字段。

`int av_new_packet(AVPacket *pkt, int size);`  
分配数据包的有效负载，并使用默认值初始化其字段。

`void av_shrink_packet(AVPacket *pkt, int size);`  
减少数据包大小，正确将填充归零

`int av_grow_packet(AVPacket *pkt, int grow_by);`  
增加数据包大小，将填充正确置零

`int av_packet_from_data(AVPacket *pkt, uint8_t *data, int size);`  
根据av_malloc()数据初始化引用计数的数据包。

`uint8_t* av_packet_new_side_data(AVPacket *pkt, enum AVPacketSideDataType type,
                                 int size);`  
分配数据包的新信息。

`int av_packet_add_side_data(AVPacket *pkt, enum AVPacketSideDataType type,
                            uint8_t *data, size_t size);`  
将现有阵列包装为包边数据。

`int av_packet_shrink_side_data(AVPacket *pkt, enum AVPacketSideDataType type,
                               int size);`  
缩小已经分配的侧面数据缓冲区

`uint8_t* av_packet_get_side_data(const AVPacket *pkt, enum AVPacketSideDataType type,
                                 int *size);`  
从数据包中获取辅助信息。

`const char *av_packet_side_data_name(enum AVPacketSideDataType type);`  
获取辅助信息类型对应的名称

`uint8_t *av_packet_pack_dictionary(AVDictionary *dict, int *size)`  
打包字典以供在side_data中使用。

`int av_packet_unpack_dictionary(const uint8_t *data, int size, AVDictionary **dict);`  
从side_data解压缩字典。

`void av_packet_free_side_data(AVPacket *pkt);`  
便利功能可释放所有存储的辅助数据。
所有其他字段保持不变。

`int av_packet_ref(AVPacket *dst, const AVPacket *src);`  
设置对给定数据包描述的数据的新引用

`void av_packet_unref(AVPacket *pkt);`  
减少对给定数据包的引用

`void av_packet_move_ref(AVPacket *dst, AVPacket *src);`  
将src中的每个字段移至dst并重置src。

`int av_packet_copy_props(AVPacket *dst, const AVPacket *src);`  
仅将“属性”字段从src复制到dst。

`int av_packet_make_refcounted(AVPacket *pkt);`  
确保对给定数据包描述的数据进行引用计数。

`int av_packet_make_writable(AVPacket *pkt);`  
为给定数据包描述的数据创建可写引用，并尽可能避免复制数据。

`void av_packet_rescale_ts(AVPacket *pkt, AVRational tb_src, AVRational tb_dst);`  
将数据包中的有效计时字段（时间戳/持续时间）从一个时基转换为另一个时基。 具有未知值（AV_NOPTS_VALUE）的时间戳将被忽略。