# Android Studio问题

```
NDK is missing a "platforms" directory.
If you are using NDK, verify the ndk.dir is set to a valid NDK directory.  It is currently set to /home/nickli/Android/Sdk/ndk-bundle.
If you are not using NDK, unset the NDK variable from ANDROID_NDK_HOME or local.properties to remove this warning.


FAILURE: Build failed with an exception.

* What went wrong:
A problem occurred configuring project ':ZybPlayer'.
> java.lang.NullPointerException (no error message)

* Try:
Run with --info or --debug option to get more log output. Run with --scan to get full insights.

* Exception is:
org.gradle.api.ProjectConfigurationException: A problem occurred configuring project ':ZybPlayer'.
	at org.gradle.configuration.project.LifecycleProjectEvaluator.addConfigurationFailure(LifecycleProjectEvaluator.java:94)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.notifyAfterEvaluate(LifecycleProjectEvaluator.java:89)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.doConfigure(LifecycleProjectEvaluator.java:70)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.access$100(LifecycleProjectEvaluator.java:34)
	at org.gradle.configuration.project.LifecycleProjectEvaluator$ConfigureProject.run(LifecycleProjectEvaluator.java:110)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:336)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:328)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:199)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:110)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.evaluate(LifecycleProjectEvaluator.java:50)
	at org.gradle.api.internal.project.DefaultProject.evaluate(DefaultProject.java:666)
	at org.gradle.api.internal.project.DefaultProject.evaluate(DefaultProject.java:135)
	at org.gradle.execution.TaskPathProjectEvaluator.configure(TaskPathProjectEvaluator.java:35)
	at org.gradle.execution.TaskPathProjectEvaluator.configureHierarchy(TaskPathProjectEvaluator.java:62)
	at org.gradle.configuration.DefaultBuildConfigurer.configure(DefaultBuildConfigurer.java:38)
	at org.gradle.initialization.DefaultGradleLauncher$ConfigureBuild.run(DefaultGradleLauncher.java:249)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:336)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:328)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:199)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:110)
	at org.gradle.initialization.DefaultGradleLauncher.configureBuild(DefaultGradleLauncher.java:167)
	at org.gradle.initialization.DefaultGradleLauncher.doBuildStages(DefaultGradleLauncher.java:126)
	at org.gradle.initialization.DefaultGradleLauncher.getConfiguredBuild(DefaultGradleLauncher.java:104)
	at org.gradle.internal.invocation.GradleBuildController$2.call(GradleBuildController.java:87)
	at org.gradle.internal.invocation.GradleBuildController$2.call(GradleBuildController.java:84)
	at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:152)
	at org.gradle.internal.invocation.GradleBuildController.doBuild(GradleBuildController.java:100)
	at org.gradle.internal.invocation.GradleBuildController.configure(GradleBuildController.java:84)
	at org.gradle.tooling.internal.provider.runner.ClientProvidedBuildActionRunner.run(ClientProvidedBuildActionRunner.java:64)
	at org.gradle.launcher.exec.ChainingBuildActionRunner.run(ChainingBuildActionRunner.java:35)
	at org.gradle.launcher.exec.ChainingBuildActionRunner.run(ChainingBuildActionRunner.java:35)
	at org.gradle.tooling.internal.provider.ValidatingBuildActionRunner.run(ValidatingBuildActionRunner.java:32)
	at org.gradle.launcher.exec.RunAsBuildOperationBuildActionRunner$1.run(RunAsBuildOperationBuildActionRunner.java:43)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:336)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:328)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:199)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:110)
	at org.gradle.launcher.exec.RunAsBuildOperationBuildActionRunner.run(RunAsBuildOperationBuildActionRunner.java:40)
	at org.gradle.tooling.internal.provider.SubscribableBuildActionRunner.run(SubscribableBuildActionRunner.java:51)
	at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:47)
	at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:30)
	at org.gradle.launcher.exec.BuildTreeScopeBuildActionExecuter.execute(BuildTreeScopeBuildActionExecuter.java:39)
	at org.gradle.launcher.exec.BuildTreeScopeBuildActionExecuter.execute(BuildTreeScopeBuildActionExecuter.java:25)
	at org.gradle.tooling.internal.provider.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:80)
	at org.gradle.tooling.internal.provider.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:53)
	at org.gradle.tooling.internal.provider.ServicesSetupBuildActionExecuter.execute(ServicesSetupBuildActionExecuter.java:57)
	at org.gradle.tooling.internal.provider.ServicesSetupBuildActionExecuter.execute(ServicesSetupBuildActionExecuter.java:32)
	at org.gradle.tooling.internal.provider.GradleThreadBuildActionExecuter.execute(GradleThreadBuildActionExecuter.java:36)
	at org.gradle.tooling.internal.provider.GradleThreadBuildActionExecuter.execute(GradleThreadBuildActionExecuter.java:25)
	at org.gradle.tooling.internal.provider.ParallelismConfigurationBuildActionExecuter.execute(ParallelismConfigurationBuildActionExecuter.java:43)
	at org.gradle.tooling.internal.provider.ParallelismConfigurationBuildActionExecuter.execute(ParallelismConfigurationBuildActionExecuter.java:29)
	at org.gradle.tooling.internal.provider.StartParamsValidatingActionExecuter.execute(StartParamsValidatingActionExecuter.java:69)
	at org.gradle.tooling.internal.provider.StartParamsValidatingActionExecuter.execute(StartParamsValidatingActionExecuter.java:30)
	at org.gradle.tooling.internal.provider.SessionFailureReportingActionExecuter.execute(SessionFailureReportingActionExecuter.java:59)
	at org.gradle.tooling.internal.provider.SessionFailureReportingActionExecuter.execute(SessionFailureReportingActionExecuter.java:44)
	at org.gradle.tooling.internal.provider.SetupLoggingActionExecuter.execute(SetupLoggingActionExecuter.java:45)
	at org.gradle.tooling.internal.provider.SetupLoggingActionExecuter.execute(SetupLoggingActionExecuter.java:30)
	at org.gradle.launcher.daemon.server.exec.ExecuteBuild.doBuild(ExecuteBuild.java:67)
	at org.gradle.launcher.daemon.server.exec.BuildCommandOnly.execute(BuildCommandOnly.java:36)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.WatchForDisconnection.execute(WatchForDisconnection.java:37)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.ResetDeprecationLogger.execute(ResetDeprecationLogger.java:26)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.RequestStopIfSingleUsedDaemon.execute(RequestStopIfSingleUsedDaemon.java:34)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.ForwardClientInput$2.call(ForwardClientInput.java:74)
	at org.gradle.launcher.daemon.server.exec.ForwardClientInput$2.call(ForwardClientInput.java:72)
	at org.gradle.util.Swapper.swap(Swapper.java:38)
	at org.gradle.launcher.daemon.server.exec.ForwardClientInput.execute(ForwardClientInput.java:72)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.LogAndCheckHealth.execute(LogAndCheckHealth.java:55)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.LogToClient.doBuild(LogToClient.java:62)
	at org.gradle.launcher.daemon.server.exec.BuildCommandOnly.execute(BuildCommandOnly.java:36)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.EstablishBuildEnvironment.doBuild(EstablishBuildEnvironment.java:82)
	at org.gradle.launcher.daemon.server.exec.BuildCommandOnly.execute(BuildCommandOnly.java:36)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.StartBuildOrRespondWithBusy$1.run(StartBuildOrRespondWithBusy.java:50)
	at org.gradle.launcher.daemon.server.DaemonStateCoordinator$1.run(DaemonStateCoordinator.java:295)
	at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:63)
	at org.gradle.internal.concurrent.ManagedExecutorImpl$1.run(ManagedExecutorImpl.java:46)
	at org.gradle.internal.concurrent.ThreadFactoryImpl$ManagedThreadRunnable.run(ThreadFactoryImpl.java:55)
Caused by: java.lang.NullPointerException
	at com.google.common.base.Preconditions.checkNotNull(Preconditions.java:782)
	at com.android.build.gradle.internal.ndk.NdkHandler.getPlatformVersion(NdkHandler.java:158)
	at com.android.build.gradle.internal.ndk.NdkHandler.supports64Bits(NdkHandler.java:331)
	at com.android.build.gradle.internal.ndk.NdkHandler.getSupportedAbis(NdkHandler.java:403)
	at com.android.build.gradle.tasks.ExternalNativeJsonGenerator.create(ExternalNativeJsonGenerator.java:738)
	at com.android.build.gradle.internal.TaskManager.createExternalNativeBuildJsonGenerators(TaskManager.java:1711)
	at com.android.build.gradle.internal.LibraryTaskManager.lambda$createTasksForVariantScope$11(LibraryTaskManager.java:248)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.internal.LibraryTaskManager.createTasksForVariantScope(LibraryTaskManager.java:243)
	at com.android.build.gradle.internal.VariantManager.createTasksForVariantData(VariantManager.java:530)
	at com.android.build.gradle.internal.VariantManager.lambda$createAndroidTasks$1(VariantManager.java:352)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.internal.VariantManager.createAndroidTasks(VariantManager.java:348)
	at com.android.build.gradle.BasePlugin.lambda$createAndroidTasks$6(BasePlugin.java:751)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.BasePlugin.createAndroidTasks(BasePlugin.java:746)
	at com.android.build.gradle.BasePlugin.lambda$null$4(BasePlugin.java:652)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.BasePlugin.lambda$createTasks$5(BasePlugin.java:648)
	at org.gradle.internal.event.BroadcastDispatch$ActionInvocationHandler.dispatch(BroadcastDispatch.java:91)
	at org.gradle.internal.event.BroadcastDispatch$ActionInvocationHandler.dispatch(BroadcastDispatch.java:80)
	at org.gradle.internal.event.AbstractBroadcastDispatch.dispatch(AbstractBroadcastDispatch.java:42)
	at org.gradle.internal.event.BroadcastDispatch$SingletonDispatch.dispatch(BroadcastDispatch.java:230)
	at org.gradle.internal.event.BroadcastDispatch$SingletonDispatch.dispatch(BroadcastDispatch.java:149)
	at org.gradle.internal.event.AbstractBroadcastDispatch.dispatch(AbstractBroadcastDispatch.java:58)
	at org.gradle.internal.event.BroadcastDispatch$CompositeDispatch.dispatch(BroadcastDispatch.java:324)
	at org.gradle.internal.event.BroadcastDispatch$CompositeDispatch.dispatch(BroadcastDispatch.java:234)
	at org.gradle.internal.event.ListenerBroadcast.dispatch(ListenerBroadcast.java:140)
	at org.gradle.internal.event.ListenerBroadcast.dispatch(ListenerBroadcast.java:37)
	at org.gradle.internal.dispatch.ProxyDispatchAdapter$DispatchingInvocationHandler.invoke(ProxyDispatchAdapter.java:93)
	at com.sun.proxy.$Proxy32.afterEvaluate(Unknown Source)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.notifyAfterEvaluate(LifecycleProjectEvaluator.java:76)
	... 82 more


* Get more help at https://help.gradle.org

CONFIGURE FAILED in 0s
```

在`local.properties`中添加配置:
```
... ...
ndk.dir=/home/nickli/Android/Sdk/ndk/21.3.6528147/
... ...
```

---

```

FAILURE: Build failed with an exception.

* What went wrong:
A problem occurred configuring project ':ZybPlayer'.
> Invalid revision: 3.18.1-g262b901

* Try:
Run with --info or --debug option to get more log output. Run with --scan to get full insights.

* Exception is:
org.gradle.api.ProjectConfigurationException: A problem occurred configuring project ':ZybPlayer'.
	at org.gradle.configuration.project.LifecycleProjectEvaluator.addConfigurationFailure(LifecycleProjectEvaluator.java:94)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.notifyAfterEvaluate(LifecycleProjectEvaluator.java:89)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.doConfigure(LifecycleProjectEvaluator.java:70)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.access$100(LifecycleProjectEvaluator.java:34)
	at org.gradle.configuration.project.LifecycleProjectEvaluator$ConfigureProject.run(LifecycleProjectEvaluator.java:110)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:336)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:328)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:199)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:110)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.evaluate(LifecycleProjectEvaluator.java:50)
	at org.gradle.api.internal.project.DefaultProject.evaluate(DefaultProject.java:666)
	at org.gradle.api.internal.project.DefaultProject.evaluate(DefaultProject.java:135)
	at org.gradle.execution.TaskPathProjectEvaluator.configure(TaskPathProjectEvaluator.java:35)
	at org.gradle.execution.TaskPathProjectEvaluator.configureHierarchy(TaskPathProjectEvaluator.java:62)
	at org.gradle.configuration.DefaultBuildConfigurer.configure(DefaultBuildConfigurer.java:38)
	at org.gradle.initialization.DefaultGradleLauncher$ConfigureBuild.run(DefaultGradleLauncher.java:249)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:336)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:328)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:199)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:110)
	at org.gradle.initialization.DefaultGradleLauncher.configureBuild(DefaultGradleLauncher.java:167)
	at org.gradle.initialization.DefaultGradleLauncher.doBuildStages(DefaultGradleLauncher.java:126)
	at org.gradle.initialization.DefaultGradleLauncher.getConfiguredBuild(DefaultGradleLauncher.java:104)
	at org.gradle.internal.invocation.GradleBuildController$2.call(GradleBuildController.java:87)
	at org.gradle.internal.invocation.GradleBuildController$2.call(GradleBuildController.java:84)
	at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:152)
	at org.gradle.internal.invocation.GradleBuildController.doBuild(GradleBuildController.java:100)
	at org.gradle.internal.invocation.GradleBuildController.configure(GradleBuildController.java:84)
	at org.gradle.tooling.internal.provider.runner.ClientProvidedBuildActionRunner.run(ClientProvidedBuildActionRunner.java:64)
	at org.gradle.launcher.exec.ChainingBuildActionRunner.run(ChainingBuildActionRunner.java:35)
	at org.gradle.launcher.exec.ChainingBuildActionRunner.run(ChainingBuildActionRunner.java:35)
	at org.gradle.tooling.internal.provider.ValidatingBuildActionRunner.run(ValidatingBuildActionRunner.java:32)
	at org.gradle.launcher.exec.RunAsBuildOperationBuildActionRunner$1.run(RunAsBuildOperationBuildActionRunner.java:43)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:336)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor$RunnableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:328)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:199)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:110)
	at org.gradle.launcher.exec.RunAsBuildOperationBuildActionRunner.run(RunAsBuildOperationBuildActionRunner.java:40)
	at org.gradle.tooling.internal.provider.SubscribableBuildActionRunner.run(SubscribableBuildActionRunner.java:51)
	at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:47)
	at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:30)
	at org.gradle.launcher.exec.BuildTreeScopeBuildActionExecuter.execute(BuildTreeScopeBuildActionExecuter.java:39)
	at org.gradle.launcher.exec.BuildTreeScopeBuildActionExecuter.execute(BuildTreeScopeBuildActionExecuter.java:25)
	at org.gradle.tooling.internal.provider.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:80)
	at org.gradle.tooling.internal.provider.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:53)
	at org.gradle.tooling.internal.provider.ServicesSetupBuildActionExecuter.execute(ServicesSetupBuildActionExecuter.java:57)
	at org.gradle.tooling.internal.provider.ServicesSetupBuildActionExecuter.execute(ServicesSetupBuildActionExecuter.java:32)
	at org.gradle.tooling.internal.provider.GradleThreadBuildActionExecuter.execute(GradleThreadBuildActionExecuter.java:36)
	at org.gradle.tooling.internal.provider.GradleThreadBuildActionExecuter.execute(GradleThreadBuildActionExecuter.java:25)
	at org.gradle.tooling.internal.provider.ParallelismConfigurationBuildActionExecuter.execute(ParallelismConfigurationBuildActionExecuter.java:43)
	at org.gradle.tooling.internal.provider.ParallelismConfigurationBuildActionExecuter.execute(ParallelismConfigurationBuildActionExecuter.java:29)
	at org.gradle.tooling.internal.provider.StartParamsValidatingActionExecuter.execute(StartParamsValidatingActionExecuter.java:69)
	at org.gradle.tooling.internal.provider.StartParamsValidatingActionExecuter.execute(StartParamsValidatingActionExecuter.java:30)
	at org.gradle.tooling.internal.provider.SessionFailureReportingActionExecuter.execute(SessionFailureReportingActionExecuter.java:59)
	at org.gradle.tooling.internal.provider.SessionFailureReportingActionExecuter.execute(SessionFailureReportingActionExecuter.java:44)
	at org.gradle.tooling.internal.provider.SetupLoggingActionExecuter.execute(SetupLoggingActionExecuter.java:45)
	at org.gradle.tooling.internal.provider.SetupLoggingActionExecuter.execute(SetupLoggingActionExecuter.java:30)
	at org.gradle.launcher.daemon.server.exec.ExecuteBuild.doBuild(ExecuteBuild.java:67)
	at org.gradle.launcher.daemon.server.exec.BuildCommandOnly.execute(BuildCommandOnly.java:36)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.WatchForDisconnection.execute(WatchForDisconnection.java:37)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.ResetDeprecationLogger.execute(ResetDeprecationLogger.java:26)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.RequestStopIfSingleUsedDaemon.execute(RequestStopIfSingleUsedDaemon.java:34)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.ForwardClientInput$2.call(ForwardClientInput.java:74)
	at org.gradle.launcher.daemon.server.exec.ForwardClientInput$2.call(ForwardClientInput.java:72)
	at org.gradle.util.Swapper.swap(Swapper.java:38)
	at org.gradle.launcher.daemon.server.exec.ForwardClientInput.execute(ForwardClientInput.java:72)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.LogAndCheckHealth.execute(LogAndCheckHealth.java:55)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.LogToClient.doBuild(LogToClient.java:62)
	at org.gradle.launcher.daemon.server.exec.BuildCommandOnly.execute(BuildCommandOnly.java:36)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.EstablishBuildEnvironment.doBuild(EstablishBuildEnvironment.java:82)
	at org.gradle.launcher.daemon.server.exec.BuildCommandOnly.execute(BuildCommandOnly.java:36)
	at org.gradle.launcher.daemon.server.api.DaemonCommandExecution.proceed(DaemonCommandExecution.java:122)
	at org.gradle.launcher.daemon.server.exec.StartBuildOrRespondWithBusy$1.run(StartBuildOrRespondWithBusy.java:50)
	at org.gradle.launcher.daemon.server.DaemonStateCoordinator$1.run(DaemonStateCoordinator.java:295)
	at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:63)
	at org.gradle.internal.concurrent.ManagedExecutorImpl$1.run(ManagedExecutorImpl.java:46)
	at org.gradle.internal.concurrent.ThreadFactoryImpl$ManagedThreadRunnable.run(ThreadFactoryImpl.java:55)
Caused by: java.lang.NumberFormatException: Invalid revision: 3.18.1-g262b901
	at com.android.repository.Revision.parseRevision(Revision.java:133)
	at com.android.repository.Revision.parseRevision(Revision.java:155)
	at com.android.build.gradle.external.cmake.CmakeUtils.getVersion(CmakeUtils.java:51)
	at com.android.build.gradle.tasks.ExternalNativeJsonGenerator.createCmakeExternalNativeJsonGenerator(ExternalNativeJsonGenerator.java:867)
	at com.android.build.gradle.tasks.ExternalNativeJsonGenerator.create(ExternalNativeJsonGenerator.java:794)
	at com.android.build.gradle.internal.TaskManager.createExternalNativeBuildJsonGenerators(TaskManager.java:1711)
	at com.android.build.gradle.internal.LibraryTaskManager.lambda$createTasksForVariantScope$11(LibraryTaskManager.java:248)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.internal.LibraryTaskManager.createTasksForVariantScope(LibraryTaskManager.java:243)
	at com.android.build.gradle.internal.VariantManager.createTasksForVariantData(VariantManager.java:530)
	at com.android.build.gradle.internal.VariantManager.lambda$createAndroidTasks$1(VariantManager.java:352)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.internal.VariantManager.createAndroidTasks(VariantManager.java:348)
	at com.android.build.gradle.BasePlugin.lambda$createAndroidTasks$6(BasePlugin.java:751)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.BasePlugin.createAndroidTasks(BasePlugin.java:746)
	at com.android.build.gradle.BasePlugin.lambda$null$4(BasePlugin.java:652)
	at com.android.builder.profile.ThreadRecorder.record(ThreadRecorder.java:81)
	at com.android.build.gradle.BasePlugin.lambda$createTasks$5(BasePlugin.java:648)
	at org.gradle.internal.event.BroadcastDispatch$ActionInvocationHandler.dispatch(BroadcastDispatch.java:91)
	at org.gradle.internal.event.BroadcastDispatch$ActionInvocationHandler.dispatch(BroadcastDispatch.java:80)
	at org.gradle.internal.event.AbstractBroadcastDispatch.dispatch(AbstractBroadcastDispatch.java:42)
	at org.gradle.internal.event.BroadcastDispatch$SingletonDispatch.dispatch(BroadcastDispatch.java:230)
	at org.gradle.internal.event.BroadcastDispatch$SingletonDispatch.dispatch(BroadcastDispatch.java:149)
	at org.gradle.internal.event.AbstractBroadcastDispatch.dispatch(AbstractBroadcastDispatch.java:58)
	at org.gradle.internal.event.BroadcastDispatch$CompositeDispatch.dispatch(BroadcastDispatch.java:324)
	at org.gradle.internal.event.BroadcastDispatch$CompositeDispatch.dispatch(BroadcastDispatch.java:234)
	at org.gradle.internal.event.ListenerBroadcast.dispatch(ListenerBroadcast.java:140)
	at org.gradle.internal.event.ListenerBroadcast.dispatch(ListenerBroadcast.java:37)
	at org.gradle.internal.dispatch.ProxyDispatchAdapter$DispatchingInvocationHandler.invoke(ProxyDispatchAdapter.java:93)
	at com.sun.proxy.$Proxy32.afterEvaluate(Unknown Source)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.notifyAfterEvaluate(LifecycleProjectEvaluator.java:76)
	... 82 more


* Get more help at https://help.gradle.org

CONFIGURE FAILED in 0s
```

在`local.properties`中添加配置:
```
... ...
cmake.dir=/home/nickli/Android/Sdk/cmake/3.10.2.4988404/
... ...
```


---

```
External native generate JSON release: JSON generation completed with problems
CMake Error: CMake was unable to find a build program corresponding to "Ninja".  CMAKE_MAKE_PROGRAM is not set.  You probably need to select a different build tool.
CMake Error: CMake was unable to find a build program corresponding to "Ninja".  CMAKE_MAKE_PROGRAM is not set.  You probably need to select a different build tool.
Configuration failed.
```

Ubuntu下执行如下命令安装`ninja-build`:
```
$ sudo apt install ninja-build 
```