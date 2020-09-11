# PeerConnection

## PeerConnection的创建
从Java层开始:
```
@Nullable
public PeerConnection createPeerConnection(
        PeerConnection.RTCConfiguration rtcConfig, PeerConnection.Observer observer) {
    return createPeerConnection(rtcConfig, null /* constraints */, observer);
}
```

继续:
```
@Nullable
@Deprecated
public PeerConnection createPeerConnection(PeerConnection.RTCConfiguration rtcConfig,
    MediaConstraints constraints, PeerConnection.Observer observer) {
    return createPeerConnectionInternal(
            rtcConfig, constraints, observer, /* sslCertificateVerifier= */ null);
}
```

继续:
```
@Nullable
PeerConnection createPeerConnectionInternal(PeerConnection.RTCConfiguration rtcConfig,
        MediaConstraints constraints, PeerConnection.Observer observer,
        SSLCertificateVerifier sslCertificateVerifier) {
    checkPeerConnectionFactoryExists();
    long nativeObserver = PeerConnection.createNativePeerConnectionObserver(observer);
    if (nativeObserver == 0) {
        return null;
    }
    long nativePeerConnection = nativeCreatePeerConnection(
            nativeFactory, rtcConfig, constraints, nativeObserver, sslCertificateVerifier);
    if (nativePeerConnection == 0) {
        return null;
    }
    return new PeerConnection(nativePeerConnection);
}
```

到达了`nativeCreatePeerConnection()`方法, 查看JNI接口:
```
JNI_GENERATOR_EXPORT jlong Java_org_webrtc_PeerConnectionFactory_nativeCreatePeerConnection(...){
    return JNI_PeerConnectionFactory_CreatePeerConnection(env, factory,
        base::android::JavaParamRef<jobject>(env, rtcConfig),
        base::android::JavaParamRef<jobject>(env, constraints), nativeObserver,
        base::android::JavaParamRef<jobject>(env, sslCertificateVerifier));
}
```

查看`JNI_PeerConnectionFactory_CreatePeerConnection()`方法:
```
static jlong JNI_PeerConnectionFactory_CreatePeerConnection(...){
    // 准备一个RTCConfiguration
    PeerConnectionInterface::RTCConfiguration rtc_config(
            PeerConnectionInterface::RTCConfigurationType::kAggressive);
    // 将Java层的PeerConnection.RTCConfiguration转化为: PeerConnectionInterface::RTCConfiguration, 其中包括IceServerList信息
    JavaToNativeRTCConfiguration(jni, j_rtc_config, &rtc_config);
    ...
    // 同样的完成Java层MediaConstraints到Native的转换
    std::unique_ptr<MediaConstraints> constraints;
    ...
    // 创建一个PeerConnectionDependencies
    PeerConnectionDependencies peer_connection_dependencies(observer.get());
    // 将Java层的SSLCertificateVerifier转换到Native并配置给刚创建的PeerConnectionDependencies
    peer_connection_dependencies.tls_cert_verifier =
            std::make_unique<SSLCertificateVerifierWrapper>(jni, j_sslCertificateVerifier);
    ...
    // 创建PeerConnectionInterface接口的实现: PeerConnection{PeerConnectionInternal}{PeerConnectionInterface}
    rtc::scoped_refptr<PeerConnectionInterface> pc =
            PeerConnectionFactoryFromJava(factory)->CreatePeerConnection(
            rtc_config, std::move(peer_connection_dependencies));
    // 创建一个OwnedPeerConnection并设置到Java层用于构造PeerConnection类的参数
    return jlongFromPointer(
            new OwnedPeerConnection(pc, std::move(observer), std::move(constraints)));
}
```

`PeerConnectionFactoryFromJava()`将Java层的`PeerConnectionFactory`转化为Native层的`PeerConnectionFactoryProxy{PeerConnectionFactoryInterface}`, 特别的, `PeerConnectionFactoryProxy{PeerConnectionFactoryInterface}`是在`OwnedFactoryAndThreads`类中的, 该函数处理了这个情况. 继续查看`CreatePeerConnection()`, 对于`PeerConnectionFactoryProxy`所有的操作都会被映射到`PeerConnectionFactory`类中, 因此, 查看`PeerConnectionFactory::CreatePeerConnection()`方法:
```
rtc::scoped_refptr<PeerConnectionInterface>
PeerConnectionFactory::CreatePeerConnection(...){
    // 构造了PeerConnectionDependencies然后进一步传递
    PeerConnectionDependencies dependencies(observer);
    dependencies.allocator = std::move(allocator);
    dependencies.cert_generator = std::move(cert_generator);
    return CreatePeerConnection(configuration, std::move(dependencies));
}
```

进一步构造:
```
rtc::scoped_refptr<PeerConnectionInterface>
PeerConnectionFactory::CreatePeerConnection(...){
    ...
    // 如果没有创建, 则
    if (!dependencies.allocator) {
        // 在network_thread_上执行一个lambada函数, 创建一个: P2PPortAllocator{BasicPortAllocator} 并设置给PeerConnectionDependencies::allocator
        network_thread_->Invoke<void>(RTC_FROM_HERE, [this, &configuration,
                &dependencies,
                &packet_socket_factory]() {
                dependencies.allocator = std::make_unique<cricket::BasicPortAllocator>(
                default_network_manager_.get(), packet_socket_factory,
                configuration.turn_customizer);
        });
    }
    ...
    // 在network_thread_上执行PortAllocator::SetNetworkIgnoreMask()
    network_thread_->Invoke<void>(
            RTC_FROM_HERE,
            rtc::Bind(&cricket::PortAllocator::SetNetworkIgnoreMask,
                    dependencies.allocator.get(), options_.network_ignore_mask));
    ...
    // 在worker_thread_上执行PeerConnectionFactory::CreateRtcEventLog_w()方法, 返回一个: RtcEventLogImpl{RtcEventLog}
    std::unique_ptr<RtcEventLog> event_log =
            worker_thread_->Invoke<std::unique_ptr<RtcEventLog>>(
            RTC_FROM_HERE,
            rtc::Bind(&PeerConnectionFactory::CreateRtcEventLog_w, this));
    // 在worker_thread_上执行PeerConnectionFactory::CreateCall_w()方法, 返回一个: Call
    std::unique_ptr<Call> call = worker_thread_->Invoke<std::unique_ptr<Call>>(
            RTC_FROM_HERE,
            rtc::Bind(&PeerConnectionFactory::CreateCall_w, this, event_log.get()));
    // 创建PeerConnection
    rtc::scoped_refptr<PeerConnection> pc(
            new rtc::RefCountedObject<PeerConnection>(this, std::move(event_log),
            std::move(call)));
    // 初始化PeerConnection
    pc->Initialize(configuration, std::move(dependencies));
    // 创建PeerConnectionProxy, 并将创建的PeerConnection传递给其构造函数
    return PeerConnectionProxy::Create(signaling_thread(), pc);
}
```

`PeerConnection`的构造函数比较简单, 跟踪其初始化函数:
```
bool PeerConnection::Initialize(
        const PeerConnectionInterface::RTCConfiguration& configuration,
        PeerConnectionDependencies dependencies) {
    ...
    // 检查配置
    RTCError config_error = ValidateConfiguration(configuration);
    ...
    // 获取factory信息
    observer_ = dependencies.observer;
    async_resolver_factory_ = std::move(dependencies.async_resolver_factory);
    port_allocator_ = std::move(dependencies.allocator);
    packet_socket_factory_ = std::move(dependencies.packet_socket_factory);
    ice_transport_factory_ = std::move(dependencies.ice_transport_factory);
    tls_cert_verifier_ = std::move(dependencies.tls_cert_verifier);
    ...
    // 解析RTCConfiguration中的IceServer信息, 该信息是由PeerConnection.createPeerConnection()通过PeerConnection.RTCConfiguration传入的
    RTCErrorType parse_error =
            ParseIceServers(configuration.servers, &stun_servers, &turn_servers);
    ...
    // 由于上文已经创建了P2PPortAllocator{BasicPortAllocator}, 所以在network_thread_上调用PeerConnection::InitializePortAllocator_n()对由于上文已经初始化了P2PPortAllocator进行初始化
    const auto pa_result =
            network_thread()->Invoke<InitializePortAllocatorResult>(
                    RTC_FROM_HERE,
                    rtc::Bind(&PeerConnection::InitializePortAllocator_n, this,
            stun_servers, turn_servers, configuration));
    const PeerConnectionFactoryInterface::Options& options = factory_->options();
    session_id_ = rtc::ToString(rtc::CreateRandomId64() & LLONG_MAX);
    // 构造一个Config, 为构造JsepTransportController做准备
    JsepTransportController::Config config;
    config.redetermine_role_on_ice_restart =
        configuration.redetermine_role_on_ice_restart;
    ...
    config.rtcp_handler = [this](const rtc::CopyOnWriteBuffer& packet,
            int64_t packet_time_us) {
        ...
        // 创建了一个rtcp_handler, 该handler绑定到一个lambada函数, rtcp_handler被调用时, 在worker_thread_上异步调用call_->Receiver()->DeliverPacket()来处理收到的RTCP包
        rtcp_invoker_.AsyncInvoke<void>(
        RTC_FROM_HERE, worker_thread(), [this, packet, packet_time_us] {
            // 由于call_可能被work_thread_的稀构函数销毁, 所以此处要检查
            if (call_) {
            call_->Receiver()->DeliverPacket(MediaType::ANY, packet,
                    packet_time_us);
            }
        });
    };
    ...
    // 处理凭证
    rtc::scoped_refptr<rtc::RTCCertificate> certificate;
    ...
    // 创建一个SctpTransportFactory{SctpTransportInternalFactory}
    sctp_factory_ = factory_->CreateSctpTransportInternalFactory();
    config.ice_transport_factory = ice_transport_factory_.get();
    // 根据上文的JsepTransportController::Config构造JsepTransportController
    transport_controller_.reset(new JsepTransportController(
            signaling_thread(), network_thread(), port_allocator_.get(),
            async_resolver_factory_.get(), config));
    // 连接JsepTransportController的信号到PeerConnection的槽
    transport_controller_->SignalIceConnectionState.connect(
            this, &PeerConnection::OnTransportControllerConnectionState);
    ...
    // 创建状态
    stats_.reset(new StatsCollector(this));
    ...
    // 为配置Ice配置
    transport_controller_->SetIceConfig(ParseIceConfig(configuration));
    // 音视频参数设置
    ...
    // 构造WebRtcSessionDescriptionFactory
    webrtc_session_desc_factory_.reset(new WebRtcSessionDescriptionFactory(
            signaling_thread(), channel_manager(), this, session_id(),
            std::move(dependencies.cert_generator), certificate, &ssrc_generator_));
    // 连接构造WebRtcSessionDescriptionFactory的信号到PeerConnection的槽
    ...
    // 初始化WebRtcSessionDescriptionFactory
    ...
    // 如果是不是统一的Plan(有两种Plan, 一种是UnifiedPlan, 一种是PlanB), 则创建音视频收发器
    if (!IsUnifiedPlan()) {
        // 音频
        transceivers_.push_back(
            RtpTransceiverProxyWithInternal<RtpTransceiver>::Create(
                signaling_thread(), new RtpTransceiver(cricket::MEDIA_TYPE_AUDIO)));
        // 视频
        transceivers_.push_back(
            RtpTransceiverProxyWithInternal<RtpTransceiver>::Create(
                signaling_thread(), new RtpTransceiver(cricket::MEDIA_TYPE_VIDEO)));
    }
    ...
    // 信令服务器, 一般用不到
    signaling_thread()->PostDelayed(RTC_FROM_HERE, delay_ms, this,
            MSG_REPORT_USAGE_PATTERN, nullptr);
    // 根据需要创建BuiltinVideoBitrateAllocatorFactory{VideoBitrateAllocatorFactory}
    ...
}
```

## InitializePortAllocator_n()
```
PeerConnection::InitializePortAllocatorResult
PeerConnection::InitializePortAllocator_n(...){
    // 初始化 P2PPortAllocator
    port_allocator_->Initialize();
    ...
    port_allocator_->set_flags(port_allocator_flags);
    port_allocator_->set_step_delay(cricket::kMinimumStepDelay);
    port_allocator_->SetCandidateFilter(
            ConvertIceTransportTypeToCandidateFilter(configuration.type));
    port_allocator_->set_max_ipv6_networks(configuration.max_ipv6_networks);
    auto turn_servers_copy = turn_servers;
    for (auto& turn_server : turn_servers_copy) {
        turn_server.tls_cert_verifier = tls_cert_verifier_.get();
    }
    // 设置配置, 这将触发新的调用
    port_allocator_->SetConfiguration(
            stun_servers, std::move(turn_servers_copy),
            configuration.ice_candidate_pool_size,
            configuration.GetTurnPortPrunePolicy(), configuration.turn_customizer,
            configuration.stun_candidate_keepalive_interval);
    ...
}
```

### InitializePortAllocator_n()
```
void P2PPortAllocator::Initialize() {
    // 调用PortAllocator::Initialize()的方法, 标记状态
    BasicPortAllocator::Initialize();
    // network_manager_是构造P2PPortAllocator时传入的FilteringNetworkManager
    network_manager_->Initialize();
}
```

先看`FilteringNetworkManager{NetworkManagerBase}{NetworkManager}`的初始化
```
void FilteringNetworkManager::Initialize() {
    rtc::NetworkManagerBase::Initialize();
    if (media_permission_)
        CheckPermission();
}
```

### SetConfiguration()
```
bool PortAllocator::SetConfiguration(...){
    return SetConfiguration(stun_servers, turn_servers, candidate_pool_size,
            turn_port_prune_policy, turn_customizer,
            stun_candidate_keepalive_interval);
}
```
继续:
```
bool PortAllocator::SetConfiguration(...){
    ...
    while (static_cast<int>(pooled_sessions_.size()) < candidate_pool_size_) {
        ...
        // 获取Ice服务器参数
        IceParameters iceCredentials =
                IceCredentialsIterator::CreateRandomIceCredentials();
        // 建立PortAllocatorSession, 用于与StunServer交互
        PortAllocatorSession* pooled_session =
                CreateSessionInternal("", 0, iceCredentials.ufrag, iceCredentials.pwd);
        pooled_session->set_pooled(true);
        // 开始BindingRequest
        pooled_session->StartGettingPorts();
        pooled_sessions_.push_back(
                std::unique_ptr<PortAllocatorSession>(pooled_session));
    }
}
```

先看`CreateSessionInternal()`
```
PortAllocatorSession* BasicPortAllocator::CreateSessionInternal(...){
    ...
    PortAllocatorSession* session = new BasicPortAllocatorSession(
            this, content_name, component, ice_ufrag, ice_pwd);
    session->SignalIceRegathering.connect(this,
            &BasicPortAllocator::OnIceRegathering);
}
```
查看`BasicPortAllocatorSession::BasicPortAllocatorSession()`
```
BasicPortAllocatorSession::BasicPortAllocatorSession(...){
    allocator_->network_manager()->SignalNetworksChanged.connect(
            this, &BasicPortAllocatorSession::OnNetworksChanged);
    allocator_->network_manager()->StartUpdating();
}
```
network_manager()返回的是FilteringNetworkManager, 所以:
```
void FilteringNetworkManager::StartUpdating() {
    ...
    network_manager_->StartUpdating();
    ...
}
```

FilteringNetworkManager的network_manager_成员是新建时的: IpcNetworkManager, 所以:
```
IpcNetworkManager::IpcNetworkManager(...){
    network_list_manager_->AddNetworkListObserver(this);
}
```
`network_list_manager_`是`P2PSocketDispatcher`, 所以:
```
void P2PSocketDispatcher::AddNetworkListObserver(...){
    network_list_observers_->AddObserver(network_list_observer);
    PostCrossThreadTask(
        *main_task_runner_.get(), FROM_HERE,
        CrossThreadBindOnce(&P2PSocketDispatcher::RequestNetworkEventsIfNecessary,
                scoped_refptr<P2PSocketDispatcher>(this)));
}
```