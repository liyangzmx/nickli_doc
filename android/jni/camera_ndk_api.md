# Android Camera with NDK

## 官方API
[Android Developers > NDK > 参考文档 > Camera](https://developer.android.com/ndk/reference/group/camera)

## 头文件
```
// ImageReader
#include <media/NdkImageReader.h>
#include <camera/NdkCameraManager.h>
#include <camera/NdkCameraError.h>
#include <camera/NdkCameraDevice.h>
#include <camera/NdkCameraMetadataTags.h>
#include <camera/NdkCameraCaptureSession.h>
#include <camera/NdkCameraMetadataTags.h>
#include <camera/NdkCameraWindowType.h>
#include <camera/NdkCaptureRequest.h>
```

## CMakeLists.txt
```
target_link_libraries(
    ...
    camera2ndk
)
```

## build Gradle
```
android {
    ...
    defaultConfig {
        ...
        minSdkVersion  24
        ...
    }
    ...
}
```
要求API的版本必须大于24, 另外, 如果需要使用ImageReader, 那么需要`target_link_libraries()`添加`android`的库

## 基本步骤
* 相机的选择
  * 调用`ACameraManager* ACameraManager_create()`获取一个`ACameraManager *`
  * 准备一个`ACameraIdList *`, 调用`camera_status_t ACameraManager_getCameraIdList(ACameraManager* manager,
          /*out*/ACameraIdList** cameraIdList)`获取列表
  * 根据`ACameraIdList`的`numCameras`成员遍历`ACameraIdList`
  * 相机的id从`ACameraIdList的cameraIds[i]成员中获取`
  * 准备一个`ACameraMetadata *`然后调用`camera_status_t ACameraManager_getCameraCharacteristics(
          ACameraManager* manager, const char* cameraId,
          /*out*/ACameraMetadata** characteristics)`获取对应相机Id的MetaData
  * 准备一个`ACameraMetadata_const_entry`, 然后调用`camera_status_t ACameraMetadata_getConstEntry( const ACameraMetadata* metadata, uint32_t tag, /*out*/ACameraMetadata_const_entry* entry)`方法获取`ACameraMetadata_const_entry`, 其中`tag`参数, 填`ACAMERA_LENS_FACING`, 其它选项参考官方文档
  * 根据`ACameraMetadata_const_entry`的成员`data.u8[0]`判断其和`ACAMERA_LENS_FACING_FRONT`的关系判断摄像头是否属于前摄, 如果是需要的摄像头, 那么记录其id
* 相机的打开
  * 准备一个`ACameraDevice *`, 再准备一个`ACameraDevice_StateCallbacks`, 其中`ACameraDevice_StateCallbacks`可以写成:
      ```
      static ACameraDevice_StateCallbacks stateCallbacks = {
          .context = nullptr,
          .onDisconnected = OnDisconnected,
          .onError = OnError,
      };
      ```
      如果没有`ACameraDevice_StateCallbacks`的实例, `ACameraManager_openCamera()`会失败, 这里`ACameraDevice_StateCallbacks`应是**static**的
  * 调用`camera_status_t ACameraManager_openCamera( ACameraManager* manager, const char* cameraId, ACameraDevice_StateCallbacks* callback, /*out*/ACameraDevice** device)` 打开相机
  * 准备一个`ACaptureRequest *`, 然后调用`camera_status_t ACameraDevice_createCaptureRequest(const ACameraDevice* device, ACameraDevice_request_template templateId, /*out*/ACaptureRequest** request)`创建一个请求, 其中`templateId`是模板的类型, 这里是preview, 所以选择`TEMPLATE_PREVIEW`
* 拍照请求的创建
  * 调用`ANativeWindow_fromSurface()`把`jobject surface`转换成`ANativeWindow *`
  * 调用`void ANativeWindow_acquire(ANativeWindow* window);`产生对ANativeWindows的引用
  * 准备一个`ACameraOutputTarget *`, 然后调用`camera_status_t ACameraOutputTarget_create(ACameraWindowType* window, ACameraOutputTarget** output)` 创建一个输出目标
  * 调用`camera_status_t ACaptureRequest_addTarget(ACaptureRequest* request, const ACameraOutputTarget* output)`将输出目标添加到请求当中
* 相机会话的创建
  * 准备一个`ACaptureSessionOutput *`, 首先调用`camera_status_t ACaptureSessionOutput_create(ACameraWindowType* anw, /*out*/ACaptureSessionOutput** output)`从`ANativeWindow`创建一个会话输出:`ACaptureSessionOutput`
  * 准备一个`ACaptureSessionOutputContainer *`, 然后调用`camera_status_t ACaptureSessionOutputContainer_create(/*out*/ACaptureSessionOutputContainer** container)`创建一个会话的输出容器, 然后调用`camera_status_t ACaptureSessionOutputContainer_add(ACaptureSessionOutputContainer* container, const ACaptureSessionOutput* output)`将此前创建的会话输出添加到会话容器当中
  * 准备一个`ACameraCaptureSession_stateCallbacks`, 同样它必须是静态的, 类似: 
    ```
    static ACameraCaptureSession_stateCallbacks sessionListener = {
        .context = nullptr,
        .onActive = ::OnActive,
        .onReady = ::OnReady,
        .onClosed = ::OnClosed,
    };
    ```
  * 准备一个`ACameraCaptureSession`, 然后调用`camera_status_t ACameraDevice_createCaptureSession(ACameraDevice* device, const ACaptureSessionOutputContainer*       outputs, const ACameraCaptureSession_stateCallbacks* callbacks, /*out*/ACameraCaptureSession** session)` 方法创建一个相机会话, 参数1是此前打开的相机引用, 参数二是之前创建的会话容器, 参数三是此前创建的静态`ACameraCaptureSession_stateCallbacks`, 参数四是输出的会话指针的地址
* 拍照请求的发出
  * 调用`camera_status_t ACameraCaptureSession_setRepeatingRequest(CameraCaptureSession* session, /*optional*/ACameraCaptureSession_captureCallbacks* callbacks, int numRequests, ACaptureRequest** requests, /*optional*/int* captureSequenceId)`发出拍照请求, 参数1是上一步创建的拍照会话, 参数2是拍照后的回调, 该方法可以为`nullptr`, 参数3是请求的数量, 参数4是请求的指针的地址, 因为可能有多个请求, 所以只需要传一个`ACaptureRequest **`即可, 参数5是拍照请求的序列Id, 对于Preview, 这里可以传空.

## 基本用例
简单的示例:
```
extern "C"
JNIEXPORT void JNICALL
Java_com_wyze_cameranativedemo_MainActivity_preview(JNIEnv *env, jobject thiz, jobject surface) {
    ANativeWindow *nativeWindow = ANativeWindow_fromSurface(env, surface);
    ACameraManager *cameraManager = ACameraManager_create();
    ACameraIdList *cameraIdList;
    const char *cameraId = nullptr;
    ACameraManager_getCameraIdList(cameraManager, &cameraIdList);
    for(int i = 0; i < cameraIdList->numCameras; i++) {
        ACameraMetadata *cameraMetadata;
        ACameraMetadata_const_entry entry;
        ACameraManager_getCameraCharacteristics(cameraManager, cameraIdList->cameraIds[i], &cameraMetadata);
        ACameraMetadata_getConstEntry(cameraMetadata, ACAMERA_LENS_FACING, &entry);
        if(entry.data.u8[0] == ACAMERA_LENS_FACING_FRONT) {
            cameraId = cameraIdList->cameraIds[i];
            LOGD("cameraId: %s is front camera\n", cameraId);
        }
    }
    ACameraDevice *cameraDevice = nullptr;
    static ACameraDevice_StateCallbacks stateCallbacks = {
            .context = nullptr,
            .onDisconnected = OnDisconnected,
            .onError = OnError,
    };
    if(cameraId != nullptr) {
        ACameraManager_openCamera(cameraManager, cameraId, &stateCallbacks, &cameraDevice);
    }
    ACaptureRequest *captureRequest;
    ACameraDevice_createCaptureRequest(cameraDevice, TEMPLATE_PREVIEW, &captureRequest);

    ANativeWindow_acquire(nativeWindow);
    ACameraOutputTarget *outputTarget;
    ACameraOutputTarget_create(nativeWindow, &outputTarget);
    ACaptureRequest_addTarget(captureRequest, outputTarget);
    ACameraCaptureSession *captureSession;
    ACaptureSessionOutput *sessionOutput;
    ACaptureSessionOutput_create(nativeWindow, &sessionOutput);
    ACaptureSessionOutputContainer *sessionOutputContainer;
    ACaptureSessionOutputContainer_create(&sessionOutputContainer);
    ACaptureSessionOutputContainer_add(sessionOutputContainer, sessionOutput);
    static ACameraCaptureSession_stateCallbacks sessionListener = {
            .context = nullptr,
            .onActive = ::OnActive,
            .onReady = ::OnReady,
            .onClosed = ::OnClosed,
    };
    ACameraDevice_createCaptureSession(cameraDevice, sessionOutputContainer, &sessionListener, &captureSession);
    ACameraCaptureSession_setRepeatingRequest(captureSession, nullptr, 1, &captureRequest, nullptr);

    ACameraManager_deleteCameraIdList(cameraIdList);
}
```