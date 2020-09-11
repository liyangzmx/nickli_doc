[TOC]

# PeerConnectionFactory Init

## I/audio_record_jni.cc: (line 71): ctor
该log位于文件`sdk/android/src/jni/audio_device/audio_record_jni.cc`中, 可以看到其位于`AudioRecordJni`的构造函数当中, 那么`AudioRecordJni`是何时构造的? 这要从Java层的`JavaAudioDeviceModule`类说起, 首先`JavaAudioDeviceModule`是应用层通过`JavaAudioDeviceModule.buider()`方法构造的, 所以, 查看该方法
```
JavaAudioDeviceModule.builder(ContextUtils.getApplicationContext())
        .createAudioDeviceModule();
```
直接看`JavaAudioDeviceModule.Builder.createAudioDeviceModule()`:
```
public AudioDeviceModule createAudioDeviceModule() {
    ...
    final WebRtcAudioRecord audioInput = new WebRtcAudioRecord(context, audioManager, audioSource,
        audioFormat, audioRecordErrorCallback, audioRecordStateCallback, samplesReadyCallback,
        useHardwareAcousticEchoCanceler, useHardwareNoiseSuppressor);
    final WebRtcAudioTrack audioOutput = new WebRtcAudioTrack(
        context, audioManager, audioTrackErrorCallback, audioTrackStateCallback);
    return new JavaAudioDeviceModule(context, audioManager, audioInput, audioOutput,
        inputSampleRate, outputSampleRate, useStereoInput, useStereoOutput);
}
```
可以看到两个音频相关的类:
* WebRtcAudioRecord
    sdk/android/src/java/org/webrtc/audio/WebRtcAudioRecord.java
* WebRtcAudioTrack
    sdk/android/src/java/org/webrtc/audio/WebRtcAudioTrack.java

对于WebRtcAudioRecord.java, 其通过audioRecord成员引用了AudioRecord:
```
private @Nullable AudioRecord audioRecord;
```
在其`initRecording()`方法中根据SDK的版本进行了区分, 但无论那种方式, 最终都是创建了AudioRecord对象:
```
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
    // Use the AudioRecord.Builder class on Android M (23) and above.
    // Throws IllegalArgumentException.   n  
    audioRecord = createAudioRecordOnMOrHigher(
        audioSource, sampleRate, channelConfig, audioFormat, bufferSizeInBytes);
    if (preferredDevice != null) {
        setPreferredDevice(preferredDevice);
    }
} else {
    // Use the old AudioRecord constructor for API levels below 23.
    // Throws UnsupportedOperationException.
    audioRecord = createAudioRecordOnLowerThanM(
        audioSource, sampleRate, channelConfig, audioFormat, bufferSizeInBytes);
}
```
在`JavaAudioDeviceModule`的创建中, 只是记录了`WebRtcAudioRecord`到`JavaAudioDeviceModule.audioInput`而已, 并没有做实际的初始化.那么`initRecording()`何时被调用的呢? 其是在`JavaAudioRecord::InitRecording()`中被调用的, 那么`JavaAudioRecord`又是什么? 其实它是在创建`AudioRecordJni`时创建的, 这要从PeerConnectionFactory.Builder.createPeerConnectionFactory()方法说起, 该方法中:
```
public PeerConnectionFactory createPeerConnectionFactory() {
    ...
    return nativeCreatePeerConnectionFactory(ContextUtils.getApplicationContext(), options,
          audioDeviceModule.getNativeAudioDeviceModulePointer(),
          ...
    );
}
```

查看JavaAudioDeviceModule.getNativeAudioDeviceModulePointer():
```
@Override
public long getNativeAudioDeviceModulePointer() {
    synchronized (nativeLock) {
        if (nativeAudioDeviceModule == 0) {
        nativeAudioDeviceModule = nativeCreateAudioDeviceModule(context, audioManager, audioInput,
            audioOutput, inputSampleRate, outputSampleRate, useStereoInput, useStereoOutput);
        }
        return nativeAudioDeviceModule;
    }
}
```
查看native方法:
```
JNI_GENERATOR_EXPORT jlong
    Java_org_webrtc_audio_JavaAudioDeviceModule_nativeCreateAudioDeviceModule(...){
        return JNI_JavaAudioDeviceModule_CreateAudioDeviceModule(env,
            base::android::JavaParamRef<jobject>(env, context), base::android::JavaParamRef<jobject>(env,
            audioManager), base::android::JavaParamRef<jobject>(env, audioInput),
            base::android::JavaParamRef<jobject>(env, audioOutput), inputSampleRate, outputSampleRate,
            useStereoInput, useStereoOutput
    }
```

继续查看`JNI_JavaAudioDeviceModule_CreateAudioDeviceModule()`方法:
```
static jlong JNI_JavaAudioDeviceModule_CreateAudioDeviceModule(...){
    auto audio_input = std::make_unique<AudioRecordJni>(
                            env, input_parameters, kHighLatencyModeDelayEstimateInMilliseconds,
                            j_webrtc_audio_record);
    ...
}
```
创建了`AudioTrackJni`对象, 并通过`j_webrtc_audio_record`关联到了`JavaAudioDeviceModule.audioInput`所对应的`WebRtcAudioRecord`类
看下`AudioRecordJni`的构造函数:
````
AudioRecordJni::AudioRecordJni(AudioManager* audio_manager)...{
    RTC_LOG(INFO) << "ctor";
    ...
    Java_WebRtcAudioRecord_setNativeAudioRecord(env, j_audio_record_,
            jni::jlongFromPointer(this));
    thread_checker_.Detach();
    thread_checker_java_.Detach();
    ...
}
````

至此我们看到了我们关心的log

## I/audio_track_jni.cc: (line 47): ctor
改log还是在`JNI_JavaAudioDeviceModule_CreateAudioDeviceModule()`方法中:
```
static jlong JNI_JavaAudioDeviceModule_CreateAudioDeviceModule(...){
    ...
    auto audio_output = std::make_unique<AudioTrackJni>(env, output_parameters,
            j_webrtc_audio_track);
    ...
}
```
查看`AudioTrackJni`的构造函数:
```
AudioTrackJni::AudioTrackJni(JNIEnv* env, ...){
    RTC_LOG(INFO) << "ctor";
    Java_WebRtcAudioTrack_setNativeAudioTrack(env, j_audio_track_,
            jni::jlongFromPointer(this));
    thread_checker_.Detach();
    thread_checker_java_.Detach();
}
```
此处我们看到了对应的log

## I/audio_device_module.cc: (line 658): CreateAudioDeviceModuleFromInputAndOutput
还是在`JNI_JavaAudioDeviceModule_CreateAudioDeviceModule()`方法中:
```
static jlong JNI_JavaAudioDeviceModule_CreateAudioDeviceModule(...){
    ...
    return jlongFromPointer(CreateAudioDeviceModuleFromInputAndOutput(
            AudioDeviceModule::kAndroidJavaAudio,
            j_use_stereo_input, j_use_stereo_output,
            kHighLatencyModeDelayEstimateInMilliseconds,
            std::move(audio_input), std::move(audio_output))
            .release());
}
```

继续查看`CreateAudioDeviceModuleFromInputAndOutput()`方法:
```
rtc::scoped_refptr<AudioDeviceModule> CreateAudioDeviceModuleFromInputAndOutput(...){
    // 这是本小节的log
    RTC_LOG(INFO) << __FUNCTION__;
    return new rtc::RefCountedObject<AndroidAudioDeviceModule>(
        audio_layer, is_stereo_playout_supported, is_stereo_record_supported,
        playout_delay_ms, std::move(audio_input), std::move(audio_output));
}
```
创建了`AndroidAudioDeviceModule(AudioDeviceModule)`对象


## I/audio_device_module.cc: (line 73): AndroidAudioDeviceModule
继续上文, 查看`AndroidAudioDeviceModule`的构造函数:
```
AndroidAudioDeviceModule(AudioDeviceModule::AudioLayer audio_layer, ...){
    ...
    / 这是本小节的log
    RTC_LOG(INFO) << __FUNCTION__;
    thread_checker_.Detach();
}
```

这样其实`AudioRecordJni`就被设置给了`AndroidAudioDeviceModule{AudioDeviceModule}`的`input_`成员了
```
const std::unique_ptr<AudioInput> input_;
```

而WebRTC的Native真正需要的是AudioDeviceModule这个类. 对于`WebRtcAudioTrack`也是类似的情形. 那么`AudioDeviceModule`最后会关联到那个Native类中呢? 是下面这个:
```
// media/engine/webrtc_voice_engine.h
class WebRtcVoiceEngine final : public VoiceEngineInterface {
    rtc::scoped_refptr<webrtc::AudioDeviceModule> adm_;
    ...
}
```

## I/audio_processing_impl.cc: (line 272): Injected APM submodules:
```
I/audio_processing_impl.cc: (line 272): Injected APM submodules:
    Echo control factory: 0
    Echo detector: 0
    Capture analyzer: 0
    Capture post processor: 0
    Render pre processor: 0
```
以上log在`AudioProcessingImpl`的构造函数中打印, 那么它是在什么时候构造的呢?, 这要从`PeerConnectionFactory`的构造说起, 通常`PeerConnectionFactory`的构造由`PeerConnectionFactory.Builder`完成, 那么检查该类的定义, 并且跟踪其构造流程
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
    ...AndroidAudioDeviceModule
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
        // 在Native层创建了默认的audio_processor
        audio_processor ? audio_processor : CreateAudioProcessing(),
        ...
        TakeOwnershipOfUniquePtr<NetEqFactory>(native_neteq_factory));
}
```

查看`AudioProcessor`的创建:
```
rtc::scoped_refptr<AudioProcessing> CreateAudioProcessing() {
    return AudioProcessingBuilder().Create();
}
```

查看`Create()`方法:
```
AudioProcessing* AudioProcessingBuilder::Create(...){
    AudioProcessingImpl* apm = new rtc::RefCountedObject<AudioProcessingImpl>(
            config, std::move(capture_post_processing_),
            std::move(render_pre_processing_), std::move(echo_control_factory_),
            std::move(echo_detector_), std::move(capture_analyzer_));
    ...
    return apm;
}
```
创建了`AudioProcessingImpl{AudioProcessing}`实例并返回给了上层用作`CreatePeerConnectionFactoryForJava()`的参数.
最后查看的构造函数:
```
AudioProcessingImpl::AudioProcessingImpl(...){
    RTC_LOG(LS_INFO) << "Injected APM submodules:"
            "\nEcho control factory: "
            << !!echo_control_factory_
            << "\nEcho detector: " << !!submodules_.echo_detector
            << "\nCapture analyzer: " << !!submodules_.capture_analyzer
            << "\nCapture post processor: "
            << !!submodules_.capture_post_processor
            << "\nRender pre processor: "
            << !!submodules_.render_pre_processor;
    ...
}
```

印证了该log的出现.

## I/webrtc_voice_engine.cc: (line 206): WebRtcVoiceEngine::WebRtcVoiceEngine
该log处于`WebRtcVoiceEngine`的构造过程中, 让我们回到`JNI_PeerConnectionFactory_CreatePeerConnectionFactory()`函数中:
```
static ScopedJavaLocalRef<jobject>
        JNI_PeerConnectionFactory_CreatePeerConnectionFactory(...){
    return CreatePeerConnectionFactoryForJava(
        ...
        jencoder_factory, jdecoder_factory,
        // 在Native层创建了默认的audio_processor
        audio_processor ? audio_processor : CreateAudioProcessing(),
        ...
        TakeOwnershipOfUniquePtr<NetEqFactory>(native_neteq_factory));
}
```

跟进这最后一句:
```
ScopedJavaLocalRef<jobject> CreatePeerConnectionFactoryForJava(...){
    ...
    dependencies.media_engine = 
        cricket::CreateMediaEngine(std::move(media_dependencies));
    ...
}
```

查看创建函数:
```
std::unique_ptr<MediaEngineInterface> CreateMediaEngine(...){
    auto audio_engine = std::make_unique<WebRtcVoiceEngine>(
            dependencies.task_queue_factory, std::move(dependencies.adm),
            std::move(dependencies.audio_encoder_factory),
            std::move(dependencies.audio_decoder_factory),
            std::move(dependencies.audio_mixer),
            std::move(dependencies.audio_processing));
    ...
    return std::make_unique<CompositeMediaEngine>(std::move(audio_engine),
            std::move(video_engine));
}
```
终于看到了的构造:
```
WebRtcVoiceEngine::WebRtcVoiceEngine(...){
    ...
    RTC_LOG(LS_INFO) << "WebRtcVoiceEngine::WebRtcVoiceEngine";
    ...
}
```

## I/webrtc_video_engine.cc: (line 571): WebRtcVideoEngine::WebRtcVideoEngine()
仅接上文的`CreateMediaEngine()`函数:
```
std::unique_ptr<MediaEngineInterface> CreateMediaEngine(...){
    ...
    auto video_engine = std::make_unique<WebRtcVideoEngine>(
            std::move(dependencies.video_encoder_factory),
            std::move(dependencies.video_decoder_factory));
    ...
}
```
查看`WebRtcVideoEngine`的构造函数:
```
WebRtcVideoEngine::WebRtcVideoEngine(...){
    RTC_LOG(LS_INFO) << "WebRtcVideoEngine::WebRtcVideoEngine()";
}
```

## I/webrtc_voice_engine.cc: (line 228): WebRtcVoiceEngine::Init
`WebRtcVoiceEngine`是何时被初始化的? 其实还是在上文提到的`CreatePeerConnectionFactoryForJava()`之中, 被`CreateModularPeerConnectionFactory()`初始化:
```
ScopedJavaLocalRef<jobject> CreatePeerConnectionFactoryForJava(...){
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

那么查看`CreateModularPeerConnectionFactory()`函数:
```
rtc::scoped_refptr<PeerConnectionFactoryInterface>
CreateModularPeerConnectionFactory(...){
    rtc::scoped_refptr<PeerConnectionFactory> pc_factory(
            new rtc::RefCountedObject<PeerConnectionFactory>(
                std::move(dependencies)));
    // 此处调用了: PeerConnectionFactory::Initialize()
    MethodCall<PeerConnectionFactory, bool> call(
            pc_factory.get(), &PeerConnectionFactory::Initialize);
    bool result = call.Marshal(RTC_FROM_HERE, pc_factory->signaling_thread());
    ...
    return PeerConnectionFactoryProxy::Create(pc_factory->signaling_thread(), pc_factory);
}
```

检查`PeerConnectionFactory::Initialize()`:
```
bool PeerConnectionFactory::Initialize() {
    ...
    channel_manager_ = std::make_unique<cricket::ChannelManager>(
            std::move(media_engine_), std::make_unique<cricket::RtpDataEngine>(),
    worker_thread_, network_thread_);
    channel_manager_->SetVideoRtxEnabled(true);
    channel_manager_->Init()
}
```

创建了`ChannelManager`, 传入了`media_engine_`, 那么`media_engine_`是何时设置在`PeerConnectionFactory`之中的, 显然是在`CreateModularPeerConnectionFactory()`函数中, 查看`PeerConnectionFactory`的构造函数:
```
PeerConnectionFactory::PeerConnectionFactory(
        ...
        // 显然dependencies.media_engine是上文CreateMediaEngine()创建的CompositeMediaEngine
        media_engine_(std::move(dependencies.media_engine)),
        ...){
    ...
}
```

所以`PeerConnectionFactory::Initialize()`中的`channel_manager_->Init()`对应的也就是`CompositeMediaEngine::Init()`了:
```
bool CompositeMediaEngine::Init() {
    voice().Init();
    return true;
}
```
而`voice().Init()`正是`WebRtcVoiceEngine::Init()`
```
void WebRtcVoiceEngine::Init() {
    ...
    RTC_LOG(LS_INFO) << "WebRtcVoiceEngine::Init";
    ...
}
```

## I/audio_device_module.cc: (line 92): Init
此处的log实际上是`AndroidAudioDeviceModule`的初始化, 它是在何时被调用的? 其实就是在上文的`WebRtcVoiceEngine::Init()`之中:
```
void WebRtcVoiceEngine::Init() {
    ...
    webrtc::adm_helpers::Init(adm());
}
```
`adm()`返回了构造WebRtcVoiceEngine是传入的`AndroidAudioDeviceModule`, 查看`webrtc::adm_helpers::Init)`:
```
// media/engine/adm_helpers.cc:
void Init(AudioDeviceModule* adm) {
    ...
    RTC_CHECK_EQ(0, adm->Init()) << "Failed to initialize the ADM.";
    ...
}
```

查看`AndroidAudioDeviceModule`的`Init()`方法:
```
// sdk/android/src/jni/audio_device/audio_device_module.cc:92
int32_t Init() override {
    RTC_LOG(INFO) << __FUNCTION__;
    ...
}
```

## I/audio_device_buffer.cc: (line 65): AudioDeviceBuffer::ctor
仅接上一小节的`Init()`方法:
```
int32_t Init() override {
    ...
    audio_device_buffer_ =
            std::make_unique<AudioDeviceBuffer>(task_queue_factory_.get());
}
```

查看`AudioDeviceBuffer`的构造函数:
```
AudioDeviceBuffer::AudioDeviceBuffer(...){
    RTC_LOG(INFO) << "AudioDeviceBuffer::ctor";
    ...
}
```

## I/audio_device_module.cc: (line 594): AttachAudioBuffer
仅接上一小节的`Init()`方法:
```
int32_t Init() override {
    ...
    audio_device_buffer_ =
            std::make_unique<AudioDeviceBuffer>(task_queue_factory_.get());
    AttachAudioBuffer();
}
```
查看`AttachAudioBuffer()`方法:
```
int32_t AttachAudioBuffer() {
    RTC_LOG(INFO) << __FUNCTION__;
    output_->AttachAudioBuffer(audio_device_buffer_.get());
    input_->AttachAudioBuffer(audio_device_buffer_.get());
    return 0;
}
```

## I/audio_track_jni.cc: (line 208): AttachAudioBuffer
对应上文的`output_->AttachAudioBuffer(...);`
对于Android SDK查看`AudioTrackJni::AttachAudioBuffer()`方法:
```
void AudioTrackJni::AttachAudioBuffer(AudioDeviceBuffer* audioBuffer) {
    RTC_LOG(INFO) << "AttachAudioBuffer";
    ...
    RTC_LOG(INFO) << "SetPlayoutSampleRate(" << sample_rate_hz << ")";
    ...
    RTC_LOG(INFO) << "SetPlayoutChannels(" << channels << ")";
    ...
}
```
分贝对应log:
```
I/audio_track_jni.cc: (line 208): AttachAudioBuffer
I/audio_track_jni.cc: (line 212): SetPlayoutSampleRate(48000)
I/audio_track_jni.cc: (line 215): SetPlayoutChannels(1)
```

## I/audio_record_jni.cc: (line 191): AttachAudioBuffer
对于`AudioRecordJni`也是类似的情况:
```
void AudioRecordJni::AttachAudioBuffer(AudioDeviceBuffer* audioBuffer) {
    RTC_LOG(INFO) << "AttachAudioBuffer";
    ...
    RTC_LOG(INFO) << "SetRecordingSampleRate(" << sample_rate_hz << ")";
    ...
    RTC_LOG(INFO) << "SetRecordingChannels(" << channels << ")";
    audio_device_buffer_->SetRecordingChannels(channels);
    ...
}
```

## I/audio_device_buffer.cc: (line 201): SetRecordingChannels(1)
接上文`audio_device_buffer_->SetRecordingChannels()`方法:
```
int32_t AudioDeviceBuffer::SetRecordingChannels(size_t channels) {
    RTC_LOG(INFO) << "SetRecordingChannels(" << channels << ")";
    rec_channels_ = channels;
    return 0;
}
```

## I/audio_track_jni.cc: (line 64): Init
Attach完成Buffer后, 将对`AudioTrackJni`和`AudioRecordJni`进行初始化, 此log为AudioTrackJni的初始化, 还是查看`AndroidAudioDeviceModule`的`Init()`
```
int32_t Init() override {
    ...
    AttachAudioBuffer();
    ...
    output_->Init();
    input_->Init();
    ...
```
查看`AudioTrackJni::Init()`:
```
int32_t AudioTrackJni::Init() {
    RTC_LOG(INFO) << "Init";
    env_ = AttachCurrentThreadIfNeeded();
    RTC_DCHECK(thread_checker_.IsCurrent());
    return 0;
}
```
可以看到对应的log.

## I/audio_record_jni.cc: (line 88): Init
同上一小节:
```
int32_t AudioRecordJni::Init() {
    RTC_LOG(INFO) << "Init";
    env_ = AttachCurrentThreadIfNeeded();
    RTC_DCHECK(thread_checker_.IsCurrent());
    return 0;
}
```

## I/audio_device_module.cc: (line 168): SetPlayoutDevice(0)
```
void WebRtcVoiceEngine::Init() {
    ...
    webrtc::adm_helpers::Init(adm());
    ...
    adm->SetPlayoutDevice(AUDIO_DEVICE_ID);
    // I/audio_device_module.cc: (line 321): InitSpeaker
    adm->InitSpeaker();
    // I/audio_device_module.cc: (line 458): StereoPlayoutIsAvailable
    // I/audio_device_module.cc: (line 460): output: 0
    adm->StereoPlayoutIsAvailable(&available);
    // I/audio_device_module.cc: (line 465): SetStereoPlayout(0)
    adm->SetStereoPlayout(available);

    // I/audio_device_module.cc: (line 181): SetRecordingDevice(0)
    adm->SetRecordingDevice(AUDIO_DEVICE_ID);
    // I/audio_device_module.cc: (line 331): InitMicrophone
    adm->InitMicrophone();
    // I/audio_device_module.cc: (line 485): StereoRecordingIsAvailable
    // I/audio_device_module.cc: (line 487): output: 0
    adm->StereoRecordingIsAvailable(&available);
    // I/audio_device_module.cc: (line 492): SetStereoRecording(0)
    adm->SetStereoRecording(available);
}
```

## I/audio_device_module.cc: (line 87): RegisterAudioCallback
此时仍然处于`WebRtcVoiceEngine::Init()`上下文之中:
```
void WebRtcVoiceEngine::Init() {
    ...
    webrtc::adm_helpers::Init(adm());
    ...
    adm()->RegisterAudioCallback(audio_state()->audio_transport());
    ...
}
```
查看`AndroidAudioDeviceModule`的`RegisterAudioCallback()`方法:
```
int32_t RegisterAudioCallback(AudioTransport* audioCallback) override {
    RTC_LOG(INFO) << __FUNCTION__;
    return audio_device_buffer_->RegisterAudioCallback(audioCallback);
}
```

## I/audio_device_buffer.cc: (line 82): RegisterAudioCallback
继续上一小节查看`AudioDeviceBuffer::RegisterAudioCallback()`方法:
```
int32_t AudioDeviceBuffer::RegisterAudioCallback(...){
    ...
    RTC_LOG(INFO) << __FUNCTION__;
    ...
}
}
```

## I/webrtc_voice_engine.cc: (line 315): WebRtcVoiceEngine::ApplyOptions: AudioOptions {aec: 1, agc: 1, ns: 1, hf: 1, swap: 0, audio_jitter_buffer_max_packets: 200, audio_jitter_buffer_fast_accelerate: 0, audio_jitter_buffer_min_delay_ms: 0, audio_jitter_buffer_enable_rtx_handling: 0, typing: 1, experimental_agc: 0, experimental_ns: 0, residual_echo_detector: 1, }
此时仍然处于`WebRtcVoiceEngine::Init()`上下文之中:
```
void WebRtcVoiceEngine::Init() {
    ...
    adm()->RegisterAudioCallback(audio_state()->audio_transport());
    ...
    AudioOptions options;
    options.echo_cancellation = true;
    options.auto_gain_control = true;
    options.noise_suppression = true;
    options.highpass_filter = true;
    options.stereo_swapping = false;
    options.audio_jitter_buffer_max_packets = 200;
    options.audio_jitter_buffer_fast_accelerate = false;
    options.audio_jitter_buffer_min_delay_ms = 0;
    options.audio_jitter_buffer_enable_rtx_handling = false;
    options.typing_detection = true;
    options.experimental_agc = false;
    options.experimental_ns = false;
    options.residual_echo_detector = true;
    bool error = ApplyOptions(options);
    ...
}
```
显而易见:
```
bool WebRtcVoiceEngine::ApplyOptions(const AudioOptions& options_in) {
    ...
    RTC_LOG(LS_INFO) << "WebRtcVoiceEngine::ApplyOptions: "
            << options_in.ToString();
    ...
}
```

## I/audio_device_module.cc: (line 531): BuiltInAECIsAvailable
AEC的初始化, 继续上一小节的`WebRtcVoiceEngine::ApplyOptions()`:
```
bool WebRtcVoiceEngine::ApplyOptions(const AudioOptions& options_in) {
    ...
    if (options.echo_cancellation)
        const bool built_in_aec = adm()->BuiltInAECIsAvailable();
    ...
}
```


查看`AndroidAudioDeviceModule::BuiltInAECIsAvailable()`
```
bool BuiltInAECIsAvailable() const override {
    // 此处为log打印
    RTC_LOG(INFO) << __FUNCTION__;
    if (!initialized_)
        return false;
    bool isAvailable = input_->IsAcousticEchoCancelerSupported();
    // I/audio_device_module.cc: (line 535): output: 1
    RTC_LOG(INFO) << "output: " << isAvailable;
    return isAvailable;
}
```

## I/audio_device_module.cc: (line 561): EnableBuiltInAEC(1)
继续上一小节的`WebRtcVoiceEngine::ApplyOptions()`:
```
bool WebRtcVoiceEngine::ApplyOptions(const AudioOptions& options_in) {
    ...
    if (options.echo_cancellation)
        const bool built_in_aec = adm()->BuiltInAECIsAvailable();
        if (built_in_aec)
            adm()->EnableBuiltInAEC(enable_built_in_aec);
            ...
    ...
}
```

查看`AndroidAudioDeviceModule::EnableBuiltInAEC()`
```
int32_t EnableBuiltInAEC(bool enable) override {
    RTC_LOG(INFO) << __FUNCTION__ << "(" << enable << ")";
    ...
    int32_t result = input_->EnableBuiltInAEC(enable);
    RTC_LOG(INFO) << "output: " << result;
    return result;
}
```

## I/audio_record_jni.cc: (line 215): EnableBuiltInAEC(1)
进一步查看:
```
int32_t AudioRecordJni::EnableBuiltInAEC(bool enable) {
    RTC_LOG(INFO) << "EnableBuiltInAEC(" << enable << ")";
    ...
    return Java_WebRtcAudioRecord_enableBuiltInAEC(env_, j_audio_record_, enable)
            ? 0
            : -1;
}
```

继续查看:`Java_WebRtcAudioRecord_enableBuiltInAEC()`:
```
static jboolean Java_WebRtcAudioRecord_enableBuiltInAEC(...){
    jboolean ret =
            env->CallBooleanMethod(obj.obj(), call_context.base.method_id, enable);
}
```

## I/org.webrtc.Logging: WebRtcAudioRecordExternal: enableBuiltInAEC(true)
注: `WebRtcAudioRecord`的TAG是:`WebRtcAudioRecordExternal`
调用到了Java层的:`WebRtcAudioRecord.enableBuiltInAEC()`
```
@CalledByNative
private boolean enableBuiltInAEC(boolean enable) {
    Logging.d(TAG, "enableBuiltInAEC(" + enable + ")");
    return effects.setAEC(enable);
}
```

## I/org.webrtc.Logging: WebRtcAudioEffectsExternal: setAEC(true)
`effects`是`WebRtcAudioEffects`, 在`WebRtcAudioRecord`的构造过程中构造, 查看构造函数:
```
// WebRtcAudioEffects.java
private WebRtcAudioEffects() {
    // [LOG]: WebRtcAudioEffectsExternal: ctor@[name=main, id=2]
    Logging.d(TAG, "ctor" + WebRtcAudioUtils.getThreadInfo());
}
```

## I/audio_device_module.cc: (line 566): output: 0
查看`AndroidAudioDeviceModule::EnableBuiltInAEC()`
```
int32_t EnableBuiltInAEC(bool enable) override {
    RTC_LOG(INFO) << __FUNCTION__ << "(" << enable << ")";
    ...
    int32_t result = input_->EnableBuiltInAEC(enable);
    // [LOG]: 566行
    RTC_LOG(INFO) << "output: " << result;
    return result;
}
```
## I/webrtc_voice_engine.cc: (line 397): Disabling EC since built-in EC will be used instead
此时位于`WebRtcVoiceEngine::ApplyOptions()`的上下文中:
```
bool WebRtcVoiceEngine::ApplyOptions(const AudioOptions& options_in) {
    ...
    if (options.auto_gain_control)
        bool built_in_agc_avaliable = adm()->BuiltInAGCIsAvailable();
        ...
        if (adm()->EnableBuiltInAEC(enable_built_in_aec) == 0 &&
                enable_built_in_aec) {
            ...
            RTC_LOG(LS_INFO)
                    << "Disabling EC since built-in EC will be used instead";
        }
    ...
}
```

## I/audio_device_module.cc: (line 541): BuiltInAGCIsAvailable
## I/audio_device_module.cc: (line 542): output: 0
此时位于`WebRtcVoiceEngine::ApplyOptions()`的上下文中:
```
bool WebRtcVoiceEngine::ApplyOptions(const AudioOptions& options_in) {
    ...
    if (options.auto_gain_control)
        bool built_in_agc_avaliable = adm()->BuiltInAGCIsAvailable();
        ...
    ...
}
```

查看`::BuiltInAGCIsAvailable()`:
```
bool BuiltInAGCIsAvailable() const override {
    RTC_LOG(INFO) << __FUNCTION__;
    RTC_LOG(INFO) << "output: " << false;
    return false;
}
```

## I/audio_device_module.cc: (line 551): BuiltInNSIsAvailable
## I/audio_device_module.cc: (line 555): output: 1
## I/audio_device_module.cc: (line 578): EnableBuiltInNS(1)
## I/audio_device_module.cc: (line 551): BuiltInNSIsAvailable
## I/audio_device_module.cc: (line 555): output: 1
## I/audio_record_jni.cc: (line 223): EnableBuiltInNS(1)
## I/org.webrtc.Logging: WebRtcAudioRecordExternal: enableBuiltInNS(true)
## I/org.webrtc.Logging: WebRtcAudioEffectsExternal: setNS(true)
## I/audio_device_module.cc: (line 583): output: 0
## I/webrtc_voice_engine.cc: (line 424): Disabling NS since built-in NS will be used instead
以上处理和上文情况基本相同

## I/webrtc_voice_engine.cc: (line 431): Stereo swapping enabled? 0
继续查看`WebRtcVoiceEngine::ApplyOptions()`:
```
bool WebRtcVoiceEngine::ApplyOptions(const AudioOptions& options_in) {
    ...
    if (options.stereo_swapping) {
        RTC_LOG(LS_INFO) << "Stereo swapping enabled? " << *options.stereo_swapping;
        audio_state()->SetStereoChannelSwapping(*options.stereo_swapping);
    }
    ...
}
```

## I/webrtc_voice_engine.cc: (line 436): NetEq capacity is 200
## I/webrtc_voice_engine.cc: (line 442): NetEq fast mode? 0
## I/webrtc_voice_engine.cc: (line 448): NetEq minimum delay is 0
## I/webrtc_voice_engine.cc: (line 454): NetEq handle reordered packets? 0
## I/webrtc_voice_engine.cc: (line 474): Experimental ns is enabled? 0
## I/webrtc_voice_engine.cc: (line 525): NS set to 0
## I/webrtc_voice_engine.cc: (line 529): Typing detection is enabled? 0
以上处理和上文情况基本相同

## I/audio_processing_impl.cc: (line 526): AudioProcessing::ApplyConfig:
本行log过长, 因此不再标题中体现:
``` 
I/audio_processing_impl.cc: (line 526): AudioProcessing::ApplyConfig: 
AudioProcessing::Config{ pipeline: {maximum_internal_processing_rate: 32000, multi_channel_render: 0, , multi_channel_capture: 0}, pre_amplifier: { enabled: 0, fixed_gain_factor: 1 }, high_pass_filter: { enabled: 1 }, echo_canceller: { enabled: 0, mobile_mode: 1, enforce_high_pass_filtering: 1 }, noise_suppression: { enabled: 0, level: High }, transient_suppression: { enabled: 0 }, voice_detection: { enabled: 0 }, gain_controller1: { enabled: 1, mode: FixedDigital, target_level_dbfs: 3, compression_gain_db: 9, enable_limiter: 1, analog_level_minimum: 0, analog_level_maximum: 255 }, gain_controller2: { enabled: 0, fixed_digital: { gain_db: 0 }, adaptive_digital: { enabled: 0, level_estimator: Rms, use_saturation_protector: 1, extra_saturation_margin_db: 2 } }, residual_echo_detector: { enabled: 1 }, level_estimation: { enabled: 0 } }
```
继续查看`WebRtcVoiceEngine::ApplyOptions()`:
```
bool WebRtcVoiceEngine::ApplyOptions(const AudioOptions& options_in) {
    // 构造apm_config并设置给: AudioProcessingImpl
    ...
    ap->SetExtraOptions(config);
    ap->ApplyConfig(apm_config);
}
```

查看设置配置函数:
```
void AudioProcessingImpl::ApplyConfig(const AudioProcessing::Config& config) {
    // RTC_LOG(LS_INFO) << "AudioProcessing::ApplyConfig: " << config.ToString();
    ...
}
```

## I/agc_manager_direct.cc: (line 69): [agc] GetMinMicLevel
接上节`AudioProcessingImpl::ApplyConfig()`:
```
void AudioProcessingImpl::ApplyConfig(...) {
    ...
    if (agc1_config_changed) {
        InitializeGainController1();
    }
}
```

继续:
```
void AudioProcessingImpl::InitializeGainController1() {
    ...
    submodules_.agc_manager.reset(new AgcManagerDirect(...), ...);
    ...
}
```
继续:
```
AgcManagerDirect::AgcManagerDirect(...){
    const int min_mic_level = GetMinMicLevel();
    ...
}
```
继续:
```
int GetMinMicLevel() {
    RTC_LOG(LS_INFO) << "[agc] GetMinMicLevel";
    ...
}
```

## I/agc_manager_direct.cc: (line 73): [agc] Using default min mic level: 12
接上节`GetMinMicLevel()`:
```
int GetMinMicLevel() {
    RTC_LOG(LS_INFO) << "[agc] GetMinMicLevel";
    ...
    if (!webrtc::field_trial::IsEnabled(kMinMicLevelFieldTrial))
        RTC_LOG(LS_INFO) << "[agc] Using default min mic level: " << kMinMicLevel;
        ...
    ...
}
```

## I/agc_manager_direct.cc: (line 457): AgcManagerDirect::Initialize
```
void AudioProcessingImpl::InitializeGainController1() {
    ...
    submodules_.agc_manager.reset(new AgcManagerDirect(...), ...);
    submodules_.agc_manager->Initialize();
    ...
}
```

查看初始化函数:
```
void AgcManagerDirect::Initialize() {
    RTC_DLOG(LS_INFO) << "AgcManagerDirect::Initialize";
    ...
}
```

## PeerConnectionFactory: onNetworkThreadReady
## PeerConnectionFactory: onSignalingThreadReady
## PeerConnectionFactory: onWorkerThreadReady
此时逐次返回到`CreatePeerConnectionFactoryForJava()`中:
```
ScopedJavaLocalRef<jobject> CreatePeerConnectionFactoryForJava(...){
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

