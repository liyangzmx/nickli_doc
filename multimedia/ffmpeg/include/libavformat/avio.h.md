# avio.h

头文件: `libavformat/avio.h`

```
typedef struct AVIOInterruptCB {
    int (*callback)(void*);
    void *opaque;
} AVIOInterruptCB;
```
中断处理函数, 如果函数返回1, 则终止流程`opaque`作为`callback`的参数.

```
enum AVIODirEntryType {
    AVIO_ENTRY_UNKNOWN,
    // 块设备
    AVIO_ENTRY_BLOCK_DEVICE,
    // 字符设备
    AVIO_ENTRY_CHARACTER_DEVICE,
    // 目录
    AVIO_ENTRY_DIRECTORY,
    // 有名管道
    AVIO_ENTRY_NAMED_PIPE,
    // 符号连接(软连接)
    AVIO_ENTRY_SYMBOLIC_LINK,
    // Socket
    AVIO_ENTRY_SOCKET,
    // 文件
    AVIO_ENTRY_FILE,
    // 服务器
    AVIO_ENTRY_SERVER,
    // 共享目录(Samba)
    AVIO_ENTRY_SHARE,
    // 工作组
    AVIO_ENTRY_WORKGROUP,
};
```
本地路径的文件类型

```
typedef struct AVIODirEntry {
    // 文件名
    char *name;
    // 类型, 参考上文
    int type;
    // 如果文件名是UTF-8编码的, 则为0, 否则为0; 注意, 名字为0是也可以编码为UTF-8
    int utf8;
    // 文件大小, 未知时为-1
    int64_t size;
    // 文件的最后修改时间, 在unix中以毫秒为单位(Epoch时间)
    int64_t modification_timestamp;
    // 文件的最后接入时间, 在unix中以毫秒为单位(Epoch时间), 未知时为-1
    int64_t access_timestamp;
    // 文件的状态改变时间, 在unix中以毫秒为单位(Epoch时间), 未知时为-1
    int64_t status_change_timestamp;
    // 所有者uid
    int64_t user_id;
    // 所有组gid
    int64_t group_id;
    // 文件模式, unix风格, 未知为-1;
    int64_t filemode;
} AVIODirEntry;
```

```
typedef struct AVIODirContext {
    struct URLContext *url_context;
} AVIODirContext;
```
目录上下文, 本质和URL上下文是一致的.

```
typedef struct AVIOContext {
    // 私有操作指针
    const AVClass *av_class;
    // 缓冲区的起始地址
    unsigned char *buffer;
    // 缓冲区的大小
    int buffer_size;
    // 当前缓冲区中的指针位置, 比如读取/写入了部分数据后, 该指针会对应调整
    unsigned char *buf_ptr;
    // 缓冲区结束地址
    unsigned char *buf_end;
    // 传递给read/write的私有数据指针, 例如对于一个输入, 它通常指向struct URLContext
    void *opaque;
    // 读取函数, opaque为上文的私有数据
    int (*read_packet)(void *opaque, uint8_t *buf, int buf_size);
    // 读取seek函数, 用于在读取时seek到指定的tiemestamp位置
    int64_t (*read_seek)(void *opaque, int stream_index, int64_t timestamp, int flags);
    // 是否允许seek, 通常是AVIO_SEEKABLE_NORMAL, 为0表示不允许seek
    int seekable;
    // 文件的最大尺寸
    int64_t maxsize;
    // 是否允许直接通过底层调用直接读写/seek文件
    int direct;
    // 以','分割的协议白名单
    const char *protocol_whitelist;
    // 以','分割的协议禁止名单
    const char *protocol_blacklist;
    // 用于替代write_packet()的回调,
    int (*write_data_type)(void *opaque, uint8_t *buf, int buf_size, enum AVIODataMarkerType type, int64_t time);
    // !!! 
    int ignore_boundary_point;
    // 想后seek的最大缓冲区位置
    unsigned char *buf_ptr_max;
    // 尝试想后seek的最小尺寸
    int min_packet_size;

    // ----- [内部变量] -----
    enum AVIODataMarkerType current_type;
    int64_t last_time;
    // 用于替换short_seek_threshold()的函数
    int (*short_seek_get)(void *opaque);
    // 已经写入的数据
    int64_t written;

    // [内部]统计读取了多少字节
    int64_t bytes_read;
    // [内部]seek了多少字节
    int seek_count;
    // [内部]写入了多少字节
    int writeout_count;
    // [内部]原始缓冲区大小
    int orig_buffer_size;
    // [内部]短seek的阈值
    int short_seek_threshold;

```

`const char *avio_find_protocol_name(const char *url);`
返回`url`所表示的资源的协议类型, 该函数返回的结果比较简单, 比如https的dash, 返回的是https

`int avio_check(const char *url, int flags);`
检查流的属性, 常用的有三个:
```
// 只读
#define AVIO_FLAG_READ  1
// 只写
#define AVIO_FLAG_WRITE 2
// 读写
#define AVIO_FLAG_READ_WRITE (AVIO_FLAG_READ|AVIO_FLAG_WRITE)
```
但是官方的意思, 这个函数不太"安全", 因为流的读写属性可能随时发生改变;

`int avpriv_io_move(const char *url_src, const char *url_dst);`  
移动/重命名一个url资源, 调用的是`URLContext.prot->url_move`方法, 实际上只有如下几种协议支持该操作:
file, ftp, samba, ssh

`int avpriv_io_delete(const char *url);`  
删除一个url资源, 调用的是`URLContext.prot->url_delete`方法, 但可能有权限问题

`int avio_open_dir(AVIODirContext **s, const char *url, AVDictionary **options);`  
打开一个资源目录, 调用的是`URLContext.prot->url_open_dir`方法, 实际上只有如下几种协议支持该操作:
file, ftp, samba, ssh.  
使用该函数钱, 需要传入一个`AVIODirContext *ctx = NULL;`皆可, 成功后`ctx`有值, 可以使用后续的`avio_read_dir`方法访问, 对于`AVDictionary`是一组配置, 比如要打开的是ftp协议的链接, 则可能需要一些额外的配置:
|选项|类型|含义|
|:-|:-|:-|
|"timeout"|AV_OPT_TYPE_INT|超时时间设置|
|"ftp-write-seekable"|AV_OPT_TYPE_BOOL|写入是否支持seek|
|"ftp-anonymous-password"|AV_OPT_TYPE_STRING|匿名用户密码|
|"ftp-user"|AV_OPT_TYPE_STRING|用户名|
|"ftp-password"|AV_OPT_TYPE_STRING|密码|

对于`AVDictionary`的设置, 不同的类型, 设置方法不同:
|类型|设置函数|
|:-|:-|
|AV_OPT_TYPE_STRING|int av_dict_set(AVDictionary **pm, const char *key, const char *value, int flags);|
|其它类型|int av_dict_set_int(AVDictionary **pm, const char *key, int64_t value, int flags);|

上文两个函数定义在`libavutil/dict.h`中.

基本用法:
* 一个字典指针: 
    ```
    AVDictionary *d = NULL;
    ```
* 销毁一个字典: 
    ```
    av_dict_free(&d);
    ```
* 添加一对 key-value
    ```
    av_dict_set(&d, "name", "jhuster", 0);
    av_dict_set_int(&d, "age", "29", 0);
    ```
* 获取 key 的值
    ```
    AVDictionaryEntry *t = NULL;

    t = av_dict_get(d, "name", NULL, AV_DICT_IGNORE_SUFFIX);
    av_log(NULL, AV_LOG_DEBUG, "name: %s", t->value);

    t = av_dict_get(d, "age", NULL, AV_DICT_IGNORE_SUFFIX);
    av_log(NULL, AV_LOG_DEBUG, "age: %d", (int) (*t->value));
    ```
* 遍历字典
    ```
    AVDictionaryEntry *t = NULL;
    while ((t = av_dict_get(d, "", t, AV_DICT_IGNORE_SUFFIX))) {
        av_log(NULL, AV_LOG_DEBUG, "%s: %s", t->key, t->value);
    }
    ```
* DEMO
    ```
    AVDictionary *options = NULL;
    av_dict_set(&options, “probesize”, “4096", 0);
    av_dict_set(&options, “max_delay”, “5000000”, 0);

    AVFormatContext *ic = avformat_alloc_context();
    if (avformat_open_input(&ic, url, NULL, &options) < 0) {
        LOGE("could not open source %s", url);
        return -1;
    } 
    ```

`int avio_read_dir(AVIODirContext *s, AVIODirEntry **next);`  
读取打开后的`AVIODirContext`, 每读取一个项目, 则返回一个`AVIODirEntry`, 可以使用while来判定结束, 基本用法:
```
    // 打开目录
    ... ...
    AVIODirEntry *entry = NULL;
    for (;;) {
        if ((ret = avio_read_dir(ctx, &entry)) < 0) {
            av_log(NULL, AV_LOG_ERROR, "Cannot list directory: %s.\n", av_err2str(ret));
            goto fail;
        }
        if (!entry)
            break;
        // 处理 AVIODirEntry
        ... ...

        // 处理完成后释放AVIODirEntry
        avio_free_directory_entry(&entry);
    }
```

`void avio_free_directory_entry(AVIODirEntry **entry);`  
释放`AVIODirEntry`, 例子见上文.

`
AVIOContext *avio_alloc_context(
                  unsigned char *buffer,
                  int buffer_size,
                  int write_flag,
                  void *opaque,
                  int (*read_packet)(void *opaque, uint8_t *buf, int buf_size),
                  int (*write_packet)(void *opaque, uint8_t *buf, int buf_size),
                  int64_t (*seek)(void *opaque, int64_t offset, int whence));
                  `  
分配一个上下文, 可以设置给`AVFormatContext`的pb, 此时在`avformat_open_input()`函数中`AVFormatContext`的`flag`将:`s->flags |= AVFMT_FLAG_CUSTOM_IO;`, 表示使用自定义的`AVIOContext`.
参数:
* buffer - 数据缓冲区
* buffer_size - 数据缓冲区大小
* write_flag - 写入标记, 如果是1表示buffer可写
* opaque - 私有数据结构, 例如一段buffer的描述等
* read_packet - 读取数据方法
* write_packet - 写入数据的方法
* seek - 对数据进行seek的方法

注意: 数据缓冲区不是原始数据的buffer, 原始数据的buffer应由opaque的自定义结构体自行管理

`void avio_context_free(AVIOContext **s);`  
释放一个`AVIOContext`, 注意: 如果一个`AVIOContext`用于一个输入流的打开, 则应该:
* 注意先使用`avformat_close_input()`关闭输入流后再释放`AVIOContext`
* 注意使用`av_freep()`释放`AVIOContext`的缓冲区buffer: `AVIOContext.buffer`

`int64_t avio_seek(AVIOContext *s, int64_t offset, int whence);`  
seek指针到流的指定偏移

`int64_t avio_skip(AVIOContext *s, int64_t offset);`  
向前跳过制定的偏移

`static av_always_inline int64_t avio_tell(AVIOContext *s)`  
返回文件指针在媒体资源中的位置

`int64_t avio_size(AVIOContext *s);`  
返回媒体资源大小

`int avio_feof(AVIOContext *s);`  
判断是否到达资源文件的末尾

`int avio_open(AVIOContext **s, const char *url, int flags);`  
打开一个输入流

`int avio_open2(AVIOContext **s, const char *url, int flags,
               const AVIOInterruptCB *int_cb, AVDictionary **options)`  
是一个类, 上文说到可以通过该结构实现中断, 对于: dash/hls/srt/amq/rtp/rtsp/tls等网络流, 有时可能阻塞很久, 为了在等待过程可以被打断, 则可以传入该结构. 使用`AVIOInterruptCB`的主要函数是`ff_check_interrupt()`

`int avio_close(AVIOContext *s);`  
关闭一个IO上下文, 注意: 只有在使用`avio_open/avio_open2`打开一个上下问的时候, 才需要用该函数关闭, 否则不要主动关闭.

`int avio_closep(AVIOContext **s);`  
类似上问, 但支持释放`AVIOContext`本身, 设置指针为NULL等

```
void avio_w8(AVIOContext *s, int b);
void avio_write(AVIOContext *s, const unsigned char *buf, int size);
void avio_wl64(AVIOContext *s, uint64_t val);
void avio_wb64(AVIOContext *s, uint64_t val);
void avio_wl32(AVIOContext *s, unsigned int val);
void avio_wb32(AVIOContext *s, unsigned int val);
void avio_wl24(AVIOContext *s, unsigned int val);
void avio_wb24(AVIOContext *s, unsigned int val);
void avio_wl16(AVIOContext *s, unsigned int val);
void avio_wb16(AVIOContext *s, unsigned int val);

// 写入一个以NULL为结尾的字符串(标准C字符串)
int avio_put_str(AVIOContext *s, const char *str);

// 小端序写入一个16bit
int avio_put_str16le(AVIOContext *s, const char *str);

// 大端序写入一个16bit
int avio_put_str16be(AVIOContext *s, const char *str);

// 标记即将写入的字节流是特殊的类型
void avio_write_marker(AVIOContext *s, int64_t time, enum AVIODataMarkerType type);

// 按照fmt格式向流中写入数据
int avio_printf(AVIOContext *s, const char *fmt, ...) av_printf_format(2, 3);

// 写入一组字符串到输出
void avio_print_string_array(AVIOContext *s, const char *strings[]);
// 通常推荐直接用如下的宏
#define avio_print(s, ...) \
    avio_print_string_array(s, (const char*[]){__VA_ARGS__, NULL})

// 刷新输出缓冲到媒体资源
void avio_flush(AVIOContext *s);
```
一组向`AVIOContext`输出写入数据的辅助方法, 注意必须保证`AVIOContext`是可写的.

```
// 读取指定量的数据到缓冲
int avio_read(AVIOContext *s, unsigned char *buf, int size);

// 读取指定量的数据到缓冲, 允许读取的数据小于需求的
int avio_read_partial(AVIOContext *s, unsigned char *buf, int size);

// 一组辅助读取方法
int          avio_r8  (AVIOContext *s);
unsigned int avio_rl16(AVIOContext *s);
unsigned int avio_rl24(AVIOContext *s);
unsigned int avio_rl32(AVIOContext *s);
uint64_t     avio_rl64(AVIOContext *s);
unsigned int avio_rb16(AVIOContext *s);
unsigned int avio_rb24(AVIOContext *s);
unsigned int avio_rb32(AVIOContext *s);
uint64_t     avio_rb64(AVIOContext *s);

// 读取字符串
int avio_get_str(AVIOContext *pb, int maxlen, char *buf, int buflen);

// 16bit的小/大端读取方法
int avio_get_str16le(AVIOContext *pb, int maxlen, char *buf, int buflen);
int avio_get_str16be(AVIOContext *pb, int maxlen, char *buf, int buflen);


```
一组从`AVIOContext`输如读取数据的辅助方法, 注意必须保证`AVIOContext`是可读的.


```
int avio_open_dyn_buf(AVIOContext **s);
int avio_get_dyn_buf(AVIOContext *s, uint8_t **pbuffer);
int avio_close_dyn_buf(AVIOContext *s, uint8_t **pbuffer);
```
一组纯buffer的操作, 参考的demo:
```
    // 一些初始化
    ... ...
    const char *name = "...";
    uint8_t *res = NULL;
    AVIOContext *pb;
    if (avio_open_dyn_buf(&pb) < 0)
        exit(1);
    // 向动态内存输出上下文中写入数据
    avio_printf(pb, "%s", name);
    avio_w8(pb, 0);
    ... ...
    // 获取已经写入数据的buffer, buffer_size是buffer的长度
    int buffer_size = avio_close_dyn_buf(pb, &res);
```
注意, 返回的动态内存必须使用`av_free()`方法释放.



`const char *avio_enum_protocols(void **opaque, int output);`  
// 迭代所有支持的协议, 如果output为0, 则每调用一次, 迭代出的返回为一个输入, 反之输出

`const AVClass *avio_protocol_get_class(const char *name);`  
// 获取一种输入/输出协议的AVClass

`int     avio_pause(AVIOContext *h, int pause);`    
用于网络流的暂停

`int64_t avio_seek_time(AVIOContext *h, int stream_index,
                       int64_t timestamp, int flags);`   
seek到制定的时间

`int avio_accept(AVIOContext *s, AVIOContext **c);`  
`int avio_handshake(AVIOContext *c);`  
两个用于网络的AVIO函数