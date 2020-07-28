# 数据转换

## String -> jstring -> char *
直接使用`JNIEnv`的`GetStringUTFChars()`方法即可, 用完了记得`ReleaseStringUTFChars()`释放.

## char * -> jstring 
直接使用`JNIEnv`的`NewStringUTF()`即可.

## String -> byte[] -> jbyteArray -> jbyte * -> char *
`String`是Android上层的, 通过`getBytes()`方法可以得到Java层的:`byte[]`类型, 然后JNI到C++层时类型是`jbyteArray`, `jbyteArray`通过`JNIEnv`的`GetByteArrayElements()`方法可以得到`jbyte *`类型, 而`jbyte *`就是`*int_8 *`了, 也可以直接使用`(char *)`做类型转换.

## char * -> jbyteArray -> byte[] -> String
使用`JNIEnv`的`NewByteArray()`方法可以创建一个指定长度的`jbyteArray`, 但`jbyteArray`的数据需要通过`JNIEnv`的`SetByteArrayRegion()`方法进行设置.


## Surface
### Surface -> ANativeWindow
`Surface`传递到JNI后会变成`jobject`, 获取ANativeWindow的方法:
```
ANativeWindow* ANativeWindow_fromSurface(JNIEnv* env, jobject surface);
```
需要包含的头文件:
```
#include <android/native_window.h>
#include <android/native_window_jni.h>
```

#### 注意
`ANativeWindow_fromSurface()`有可能返回`NULL`这是因为Surface还没有准备好, 正确的做法是在拿到`SurfaceHolder`后, 执行其`addCallback()`方法, 添加一个`SurfaceHolder.Callback`, 在`surfaceCreated()`时, 再将`Surface`传递到Native

对ANativeWindow的访问:
```
void ANativeWindow_acquire(ANativeWindow* window);
void ANativeWindow_release(ANativeWindow* window);
int32_t ANativeWindow_lock(ANativeWindow* window, ANativeWindow_Buffer* outBuffer,
        ARect* inOutDirtyBounds);
int32_t ANativeWindow_unlockAndPost(ANativeWindow* window);
```
`ANativeWindow_acquire()`和`ANativeWindow_release()`防止引用Surface的时候, 其被删除.  
`ANativeWindow_lock()`和`ANativeWindow_unlockAndPost()`用于获取可以填写的`ANativeWindow_Buffer`

ANativeWindow_Buffer的定义:
```
typedef struct ANativeWindow_Buffer {
    /// The number of pixels that are shown horizontally.
    int32_t width;

    /// The number of pixels that are shown vertically.
    int32_t height;

    /// The number of *pixels* that a line in the buffer takes in
    /// memory. This may be >= width.
    int32_t stride;

    /// The format of the buffer. One of AHardwareBuffer_Format.
    int32_t format;

    /// The actual bits.
    void* bits;

    /// Do not touch.
    uint32_t reserved[6];
} ANativeWindow_Buffer;
```
其中bits是buffer的指针, 可以用来memcpy数据到这里, stride是每行对齐后的长度, 所以它一定是大于等于width的.