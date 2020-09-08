# VideoEncoderFactory
`VideoEncoderFactory`是从外部设置进来的:
```
public class PeerConnectionFactory {
    ...
    public static class Builder {
        public Builder setVideoEncoderFactory(VideoEncoderFactory videoEncoderFactory) {
            this.videoEncoderFactory = videoEncoderFactory;
            return this;
        }
    }
    ...
}
```

然后在如下函数中使用:
```
public class PeerConnectionFactory {
    ...
    public static class Builder {
        ...
        public PeerConnectionFactory createPeerConnectionFactory() {
        ...
        return nativeCreatePeerConnectionFactory(ContextUtils.getApplicationContext(), options,
            ...
            audioDecoderFactoryFactory.createNativeAudioDecoderFactory(), videoEncoderFactory,
            ...
            neteqFactoryFactory == null ? 0 : neteqFactoryFactory.createNativeNetEqFactory());
        }
    }
    ...
}
```

那么`PeerConnectionFactory.Buider.nativeCreatePeerConnectionFactory()`对`VideoEncoderFactory`的使用:
```
JNI_GENERATOR_EXPORT jobject
        Java_org_webrtc_PeerConnectionFactory_nativeCreatePeerConnectionFactory(...){
    return JNI_PeerConnectionFactory_CreatePeerConnectionFactory(env,
        ...
        base::android::JavaParamRef<jobject>(env, encoderFactory),
        ...
        nativeNetworkStatePredictorFactory, neteqFactory).Release();
}
```

名字有点长:
```
static ScopedJavaLocalRef<jobject>
        JNI_PeerConnectionFactory_CreatePeerConnectionFactory(...){
    return CreatePeerConnectionFactoryForJava(
        ...
        jencoder_factory, jdecoder_factory,
        ...
        TakeOwnershipOfUniquePtr<NetEqFactory>(native_neteq_factory));
}
```

继续:
```
ScopedJavaLocalRef<jobject> CreatePeerConnectionFactoryForJava(...){
    media_dependencies.video_encoder_factory =
        absl::WrapUnique(CreateVideoEncoderFactory(jni, jencoder_factory));
    ...
    dependencies.media_engine = 
        cricket::CreateMediaEngine(std::move(media_dependencies));
    rtc::scoped_refptr<PeerConnectionFactoryInterface> factory =
        CreateModularPeerConnectionFactory(std::move(dependencies));
    return NativeToScopedJavaPeerConnectionFactory(
        jni, factory, std::move(network_thread), std::move(worker_thread),
        std::move(signaling_thread), network_monitor_factory);
}
```

先看`CreateVideoEncoderFactory()`:
```
VideoEncoderFactory* CreateVideoEncoderFactory(
    JNIEnv* jni,
    const JavaRef<jobject>& j_encoder_factory) {
  return IsNull(jni, j_encoder_factory)
             ? nullptr
             : new VideoEncoderFactoryWrapper(jni, j_encoder_factory);
}
```
继续`VideoEncoderFactoryWrapper`:
```
VideoEncoderFactoryWrapper::VideoEncoderFactoryWrapper(
    JNIEnv* jni,
    const JavaRef<jobject>& encoder_factory)
    : encoder_factory_(jni, encoder_factory) {
  const ScopedJavaLocalRef<jobjectArray> j_supported_codecs =
      Java_VideoEncoderFactory_getSupportedCodecs(jni, encoder_factory);
  supported_formats_ = JavaToNativeVector<SdpVideoFormat>(
      jni, j_supported_codecs, &VideoCodecInfoToSdpVideoFormat);
  const ScopedJavaLocalRef<jobjectArray> j_implementations =
      Java_VideoEncoderFactory_getImplementations(jni, encoder_factory);
  implementations_ = JavaToNativeVector<SdpVideoFormat>(
      jni, j_implementations, &VideoCodecInfoToSdpVideoFormat);
}
```
`VideoEncoderFactoryWrapper`是继承`VideoEncoderFactory`接口的, 创建后通过其引用Java层的`VideoEncoderFactory`

再看`CreateModularPeerConnectionFactory()`:
```
rtc::scoped_refptr<PeerConnectionFactoryInterface>
CreateModularPeerConnectionFactory(...){
    rtc::scoped_refptr<PeerConnectionFactory> pc_factory(
            new rtc::RefCountedObject<PeerConnectionFactory>(
                std::move(dependencies)));
    MethodCall<PeerConnectionFactory, bool> call(
            pc_factory.get(), &PeerConnectionFactory::Initialize);
    bool result = call.Marshal(RTC_FROM_HERE, pc_factory->signaling_thread());
    ...
    return PeerConnectionFactoryProxy::Create(pc_factory->signaling_thread(), pc_factory);
}
```

创建了`PeerConnectionFactory`, 先看构造函数:
```
PeerConnectionFactory::PeerConnectionFactory(
    PeerConnectionFactoryDependencies dependencies)
    : wraps_current_thread_(false),
    ...
    media_engine_(std::move(dependencies.media_engine)),
    trials_(dependencies.trials ? std::move(dependencies.trials)
                                  : std::make_unique<FieldTrialBasedConfig>()) {
        ...
    }
```
只是把`cricket::CreateMediaEngine(std::move(media_dependencies))`创建的`MediaEngineInterface`设置给了`PeerConnectionFactory`的`media_engine_`, 那还要看`CreateMediaEngine()`过程才能知道`VideoEncoderFactoryWrapper{VideoEncoderFactory}`最终设置给了谁:
```
std::unique_ptr<MediaEngineInterface> CreateMediaEngine(
    MediaEngineDependencies dependencies) {
        ...
        auto video_engine = std::make_unique<WebRtcVideoEngine>(
            std::move(dependencies.video_encoder_factory),
            std::move(dependencies.video_decoder_factory));
        ...
        return std::make_unique<CompositeMediaEngine>(std::move(audio_engine),
                std::move(video_engine));
```
创建了`WebRtcVideoEngine{MediaEngineInterface}`对象, 并将`VideoEncoderFactoryWrapper{VideoEncoderFactory}`设置到`WebRtcVideoEngine`的`encoder_factory_`中了


那个`PeerConnectionFactoryProxy`又是干什么的呢? 先看一组宏定义:
```
// api/proxy.h

#define PROXY_MAP_BOILERPLATE(c)                          \
  template <class PeerConnectionFactory>                         \
  class c##ProxyWithInternal;                             \
  typedef c##ProxyWithInternal<c##Interface> c##Proxy;    \
  template <class PeerConnectionFactory>                         \
  class c##ProxyWithInternal : public c##Interface {      \
   protected:                                             \
    typedef c##Interface C;                               \
                                                          \
   public:                                                \
    const PeerConnectionFactory* internal() const { return c_; } \
    PeerConnectionFactory* internal() { return c_; }

#define SIGNALING_PROXY_MAP_BOILERPLATE(c)                               \
 protected:                                                              \
  c##ProxyWithInternal(rtc::Thread* signaling_thread, PeerConnectionFactory* c) \
      : signaling_thread_(signaling_thread), c_(c) {}                    \
                                                                         \
 private:                                                                \
  mutable rtc::Thread* signaling_thread_;

#define REFCOUNTED_PROXY_MAP_BOILERPLATE(c)            \
 protected:                                            \
  ~c##ProxyWithInternal() {                            \
    MethodCall<c##ProxyWithInternal, void> call(       \
        this, &c##ProxyWithInternal::DestroyInternal); \
    call.Marshal(RTC_FROM_HERE, destructor_thread());  \
  }                                                    \
                                                       \
 private:                                              \
  void DestroyInternal() { c_ = nullptr; }             \
  rtc::scoped_refptr<PeerConnectionFactory> c_;

#define BEGIN_SIGNALING_PROXY_MAP(c)                                         \
  PROXY_MAP_BOILERPLATE(c)                                                   \
  SIGNALING_PROXY_MAP_BOILERPLATE(c)                                         \
  REFCOUNTED_PROXY_MAP_BOILERPLATE(c)                                        \
 public:                                                                     \
  static rtc::scoped_refptr<c##ProxyWithInternal> Create(                    \
      rtc::Thread* signaling_thread, PeerConnectionFactory* c) {                    \
    return new rtc::RefCountedObject<c##ProxyWithInternal>(signaling_thread, \
                                                           c);               \
  }
```

然后在文件`api/peer_connection_factory_proxy.h`中:
```
namespace webrtc {

// TODO(deadbeef): Move this to .cc file and out of api/. What threads methods
// are called on is an implementation detail.
BEGIN_SIGNALING_PROXY_MAP(PeerConnectionFactory)
...
}
```

简单展开`BEGIN_SIGNALING_PROXY_MAP(PeerConnectionFactory)`:
```
template <class PeerConnectionFactory>
class PeerConnectionFactoryProxyWithInternal;
typedef PeerConnectionFactoryProxyWithInternal<PeerConnectionFactoryInterface> PeerConnectionFactoryProxy;
template <class PeerConnectionFactory>
class PeerConnectionFactoryProxy : public c##Interface {
    public:
        const PeerConnectionFactory* internal() const { return c_; }
        PeerConnectionFactory* internal() { return c_; }
        static rtc::scoped_refptr<PeerConnectionFactoryProxy> Create(
            rtc::Thread* signaling_thread, PeerConnectionFactory* c) {
            return new rtc::RefCountedObject<PeerConnectionFactoryProxy>(signaling_thread, c);
        }
    protected:
        typedef PeerConnectionFactoryInterface C;
        PeerConnectionFactoryProxy(rtc::Thread* signaling_thread, PeerConnectionFactory* c)
            : signaling_thread_(signaling_thread), c_(c) {}
        ~PeerConnectionFactoryProxy() {
            MethodCall<PeerConnectionFactoryProxy, void> call(
                this, &PeerConnectionFactoryProxy::DestroyInternal);
            call.Marshal(RTC_FROM_HERE, destructor_thread());
        }
    private:
        mutable rtc::Thread* signaling_thread_;
        void DestroyInternal() { c_ = nullptr; }
        rtc::scoped_refptr<PeerConnectionFactory> c_;
}
```

可以看到得到的是继承自`PeerConnectionFactoryInterface`的`PeerConnectionFactoryProxy`, 其实`PeerConnectionFactory`也是继承自`PeerConnectionFactoryInterface`的, 但是它被`PeerConnectionFactoryProxy`代理了, 这意味着除了`Create()`, 所有对`PeerConnectionFactoryProxy`的调用都是对`PeerConnectionFactory`的调用, 因此继续上文的`PeerConnectionFactoryProxy::Create()`实际上是创建了一个`PeerConnectionFactoryProxy{PeerConnectionFactoryInterface}`并返回了.

最后看下`NativeToScopedJavaPeerConnectionFactory()`:
```
ScopedJavaLocalRef<jobject> NativeToScopedJavaPeerConnectionFactory(...){
    OwnedFactoryAndThreads* owned_factory = new OwnedFactoryAndThreads(
        std::move(network_thread), std::move(worker_thread),
        std::move(signaling_thread), network_monitor_factory, pcf);
    ScopedJavaLocalRef<jobject> j_pcf = Java_PeerConnectionFactory_Constructor(
        env, NativeToJavaPointer(owned_factory));
    ...
    return j_pcf;
}
```

可以清楚的看到`PeerConnectionFactoryProxy`被设设置到了`OwnedFactoryAndThreads`中的`factory_`, 最后创建Java层的`PeerConnectionFactory`, 并将`OwnedFactoryAndThreads`设置到其`nativeFactory`中. 

类的关系图:  
![VideoEncoderFactory](VideoEncoderFactory.png)