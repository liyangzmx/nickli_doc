# libbinder

目录在: `frameworks/native/libs/binder/`

## binder/IBinder.h
主要定义了`IBinder`, 该文件被`binder/Binder.h`默认包含

## binder/Binder.h
包含`BBinder`和`BpRefBase`, 但**不包含**`BpBinder`

## binder/BpBinder.h
包含`BpBinder`, 注意: **没有**`BBinder.h`

## binder/IInterface.h
包含`IInterface`, `BnInterface`, `BpInterface`, 实现了:`interface_cast<Interface>`模板函数, 并提供了`DECLARE_META_INTERFACE(INTERFACE)`和`IMPLEMENT_META_INTERFACE(INTERFACE, NAME)`来声明和定义接口实现, 接口实现主要提供的函数: `asInterface(const ::android::sp<::android::IBinder>& obj)`, 该函数负责返回合适的接口.  
提供了`CHECK_INTERFACE(interface, data, reply)`宏定义, 用于检查接口

对于`BnInterface`, 提供了实现:
* `const String16& BnInterface<INTERFACE>::getInterfaceDescriptor() const`
* `IBinder* BnInterface<INTERFACE>::onAsBinder()`

对于`BpInterface`, 提供了实现:
* `BpInterface<INTERFACE>::BpInterface(const sp<IBinder>& remote)`
* `IBinder* BpInterface<INTERFACE>::onAsBinder()`

## binder/IServiceManager.h
包含`IServiceManager`接口, 实现了如下方法:
* `status_t android::getService(const String16& name, sp<INTERFACE>* outService)`
* `bool android::checkCallingPermission(const String16& permission)`
* `bool android::checkCallingPermission(const String16& permission, int32_t* outPid, int32_t* outUid)`
* `bool android::checkPermission(const String16& permission, pid_t pid, uid_t uid)`

## binder/Parcelable.h
包含`Parcelable`, 非常重要的接口, 实现该接口的类都可以通过Binder传递, 注意: 它不表示对象可以完全序列化, 序列化与否是`Flattenable`约束的

## binder/Parcel.h
包含:
`Parcel`非常重要, 这是binder中各对象序列化后的类, 对于该类, 注意其和`Parcelable`和`Flattenable`的配合

## binder/ProcessState.h
包含`ProcessState`的定义, 主要为进程提供访问binder驱动而存在.

## binder/IPCThreadState.h
包含`IPCThreadState`, 与IPC线程相关, 是`ProcessState`更上层的实现, 通过其`mProcess`引用`ProcessState`

## binder/BinderService.h
包含`BinderService`, 主要提供Binder服务的一些方法, 继承了该类的服务, 可以方便的进行注册/发布, 其也同样完成了与`IPCThreadState`的配合.