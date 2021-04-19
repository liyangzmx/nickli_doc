# Android Camera 2

## CameraManager

`(CameraManager) getSystemService(Context.CAMERA_SERVICE)`  
用于获取`CameraManager`服务；

`String[] getCameraIdList()`  
获取支持的相机列表

`CameraCharacteristics getCameraCharacteristics(@NonNull String cameraId)`  
根据Id获取Camera的特性:`CameraCharacteristics`  
可以使用`CameraCharacteristics`的`get()`方法(原型:`<T> T get(CameraCharacteristics.Key<T> key)`)获取Camera的特性, 例如:  
`Integer cameraFace = cameraCharacteristics.get(CameraCharacteristics.LENS_FACING);`  
上述函数返回的结果可以进一步判断, 例如和`CameraCharacteristics.LENS_FACING_FRONT`等进行比较, 以判断Camera是否是前置摄像头.

## CameraDevice.StateCallback

`void openCamera(@NonNull String cameraId, @NonNull StateCallback callback, @Nullable Handler handler)`  
`CameraManager`的`openCamera()`方法用于打开一个相机, 其中`StateCallback`是需要传入的类, 一般集成该类并实现:  
* `void onOpened(@NonNull CameraDevice cameraDevice)`  
    相机打开后调用该回调
* `void onDisconnected(@NonNull CameraDevice cameraDevice)`  
    相机断开连接时调用该回调
* `void onError(@NonNull CameraDevice cameraDevice, int i)`  
    相机遇到错误时调用该回调

## CameraDevice

`CameraDevice`代表相机本身,向相机发送请求前需要构造请求, 一般使用`CaptureRequest.Builder`来创建相机请求, 由于请求参数通常很多, 所以可以通过`CameraDevice`的`createCaptureRequest()`从一个模板创建`CaptureRequest.Builder`

`Builder createCaptureRequest(int var1)`  
从模板创建一个相机请求的`Builder`, 其中`var1`是相机的模版类型, 一般有:
* TEMPLATE_MANUAL
* TEMPLATE_PREVIEW
* TEMPLATE_RECORD
* TEMPLATE_STILL_CAPTURE
* TEMPLATE_VIDEO_SNAPSHOT
* TEMPLATE_ZERO_SHUTTER_LAG
通常使用`CameraDevice.TEMPLATE_PREVIEW`这种类型创建预览请求

## CaptureRequest.Builder
`void addTarget(@NonNull Surface outputTarget)`  
可以通过该方法向`CaptureRequest.Builder`中添加一个`Surface`, 用于相机数据的输出

`void createCaptureSession(@NonNull List<Surface> var1, @NonNull android.hardware.camera2.CameraCaptureSession.StateCallback var2, @Nullable Handler var3)`  
发送请求, 参数1是一个类表, 需要用`Arrays.asList()`构造一个`List<Surface>`, 然后作为`var1`, 对于参数2, 其是`CameraCaptureSession.StateCallback`, 需要重写以下方法:  
* `void onConfigured(@NonNull CameraCaptureSession cameraCaptureSession)`  
    相机创建请求后会回调该方法表示相机已经准备好, 随时可以发送请求.
* `void onConfigureFailed(@NonNull CameraCaptureSession cameraCaptureSession) `  
    相机配置失败时会调用该回调.  

对于`createCaptureSession()`的参数3可以为`null`, 此时采用当前活动的Hanlder

## CameraCaptureSession.CaptureCallback
`int setRepeatingRequest(@NonNull CaptureRequest var1, @Nullable CameraCaptureSession.CaptureCallback var2, @Nullable Handler var3)`  
调用该方法向相机发出连续&重复的请求, 参数1是请求本身, 是`CaptureRequest.Builder`的`build()`方法得到的. 参数2是`CameraCaptureSession.CaptureCallback`, 传入时可以重写:  
`void onCaptureProgressed(@NonNull CameraCaptureSession session, @NonNull CaptureRequest request, @NonNull CaptureResult partialResult)`  
该方法是在预览的处理中, 每得到一帧图像, 即回调一次该方法.