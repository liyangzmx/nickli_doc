# Jenkins Install on Ubuntu and gradle build

## 参考资料
* [Installing Jenkins](https://www.jenkins.io/doc/book/installing/#installing-jenkins)

## Ubuntu安装命令
```
$ wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
$ sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
$ sudo apt-get update
$ sudo apt-get install jenkins
```

## 修改端口
```
$ sudo vim /etc/default/jenkins
... ...
# port for HTTP connector (default 8080; disable with -1)
HTTP_PORT=8080

... ...
```

## 修改国内镜像
```
$ sudo vim /var/lib/jenkins/hudson.model.UpdateCenter.xml

<?xml version='1.1' encoding='UTF-8'?>
<sites>
  <site>
    <id>default</id>
    <url>https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json</url>
  </site>
</sites>
```

## 获取安装时需要的密码
```
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
9030edb655cc4605a7......aa2cb31
```

## Android配置
|配置项|子项|内容|
|:-|:-|:-|
|Invoke Gradle Script: 
`Invoke Gradle`| Gradle Version|`(Default)`|
||Switches|`clean build`|
||Root Build script	|`${workspace}/`|
||Build File	|`${workspace}/build.gradle`|

## 关于Gradle版本
可能需要在`Global Tool Configurations`中新增一个`Gradle`的版本, 将在编译时即时安装, 相关的控制台log:
```
... ...
[Gradle] - Launching build.
Unpacking https://services.gradle.org/distributions/gradle-5.6.4-bin.zip to /var/lib/jenkins/tools/hudson.plugins.gradle.GradleInstallation/gradle_5.6.4 on Jenkins
[test_android] $ /var/lib/jenkins/tools/hudson.plugins.gradle.GradleInstallation/gradle_5.6.4/bin/gradle clean build -b /var/lib/jenkins/workspace/test_android/build.gradle

Welcome to Gradle 5.6.4!

Here are the highlights of this release:
 - Incremental Groovy compilation
 - Groovy compile avoidance
 - Test fixtures for Java projects
 - Manage plugin versions via settings script

For more details see https://docs.gradle.org/5.6.4/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
... ...
```


## 关于默认Gradle版本的报错
报错内容:
```
FAILURE: Build failed with an exception.

* Where:
Build file '/var/lib/jenkins/workspace/test_android/app/build.gradle' line: 1

* What went wrong:
A problem occurred evaluating project ':app'.
> Failed to apply plugin [id 'com.android.internal.version-check']
   > Minimum supported Gradle version is 5.6.4. Current version is 4.4.1. If using the gradle wrapper, try editing the distributionUrl in /var/lib/jenkins/workspace/test_android/gradle/wrapper/gradle-wrapper.properties to gradle-5.6.4-all.zip

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.

* Get more help at https://help.gradle.org

BUILD FAILED in 47s
Build step 'Invoke Gradle script' changed build result to FAILURE
Build step 'Invoke Gradle script' marked build as failure
Archiving artifacts
Finished: FAILURE
```

提示Gradle的版本过低, 所以按照上一小节的case安装对应的: Gradle-5.6.4

## 关于环境变量的报错
报错内容:
```
FAILURE: Build failed with an exception.

* What went wrong:
Could not determine the dependencies of task ':app:compileReleaseJavaWithJavac'.
> SDK location not found. Define location with an ANDROID_SDK_ROOT environment variable or by setting the sdk.dir path in your project's local properties file at '/var/lib/jenkins/workspace/test_android/local.properties'.

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.

* Get more help at https://help.gradle.org

BUILD FAILED in 27s
Build step 'Invoke Gradle script' changed build result to FAILURE
Build step 'Invoke Gradle script' marked build as failure
Archiving artifacts
Finished: FAILURE
```

解决: 在`全局属性`设置中勾选`Environment variables`, 并新增一个全局属性, 
`键`设置为: `ANDROID_SDK_ROOT`, `值`设置为: `/home/<USERNAME>/Android/Sdk/`即可.

## 参考编译log
```
Started by user Li Yang
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/test
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url /home/liyang/AndroidStudioProjects/androidx/LifecycleLearn/ # timeout=10
Fetching upstream changes from /home/liyang/AndroidStudioProjects/androidx/LifecycleLearn/
 > git --version # timeout=10
 > git --version # 'git version 2.25.1'
 > git fetch --tags --force --progress -- /home/liyang/AndroidStudioProjects/androidx/LifecycleLearn/ +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
Checking out Revision c4017064221b2ddbfc04020b55d88c71245f233b (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f c4017064221b2ddbfc04020b55d88c71245f233b # timeout=10
Commit message: "init version."
 > git rev-list --no-walk c4017064221b2ddbfc04020b55d88c71245f233b # timeout=10
[Gradle] - Launching build.
[test] $ /var/lib/jenkins/tools/hudson.plugins.gradle.GradleInstallation/gradle_6.1.1/bin/gradle clean build -b /var/lib/jenkins/workspace/test/build.gradle
Starting a Gradle Daemon (subsequent builds will be faster)
> Task :clean
> Task :app:clean
> Task :app:preBuild UP-TO-DATE
> Task :app:preDebugBuild UP-TO-DATE
> Task :app:generateDebugBuildConfig
> Task :app:compileDebugAidl NO-SOURCE
> Task :app:compileDebugRenderscript NO-SOURCE
> Task :app:generateDebugResValues
> Task :app:generateDebugResources
> Task :app:javaPreCompileDebug
> Task :app:createDebugCompatibleScreenManifests
> Task :app:extractDeepLinksDebug
> Task :app:processDebugManifest
> Task :app:mergeDebugShaders
> Task :app:compileDebugShaders NO-SOURCE
> Task :app:generateDebugAssets UP-TO-DATE
> Task :app:mergeDebugAssets
> Task :app:mergeDebugResources
> Task :app:processDebugResources
> Task :app:compileDebugJavaWithJavac
> Task :app:compileDebugSources
> Task :app:processDebugJavaRes NO-SOURCE
> Task :app:dexBuilderDebug
> Task :app:checkDebugDuplicateClasses
> Task :app:mergeLibDexDebug
> Task :app:mergeDebugJniLibFolders
> Task :app:validateSigningDebug
> Task :app:preReleaseBuild UP-TO-DATE
> Task :app:compileReleaseAidl NO-SOURCE
> Task :app:compileReleaseRenderscript NO-SOURCE
> Task :app:generateReleaseBuildConfig
> Task :app:generateReleaseResValues
> Task :app:generateReleaseResources
> Task :app:createReleaseCompatibleScreenManifests
> Task :app:extractDeepLinksRelease
> Task :app:processReleaseManifest
> Task :app:prepareLintJar UP-TO-DATE
> Task :app:checkReleaseDuplicateClasses
> Task :app:mergeDebugNativeLibs
> Task :app:stripDebugDebugSymbols NO-SOURCE
> Task :app:mergeReleaseShaders
> Task :app:compileReleaseShaders NO-SOURCE
> Task :app:generateReleaseAssets UP-TO-DATE
> Task :app:mergeReleaseAssets
> Task :app:processReleaseJavaRes NO-SOURCE
> Task :app:collectReleaseDependencies
> Task :app:sdkReleaseDependencyData
> Task :app:mergeReleaseJniLibFolders
> Task :app:mergeProjectDexDebug
> Task :app:mergeReleaseResources
> Task :app:processReleaseResources
> Task :app:mergeExtDexRelease
> Task :app:mergeExtDexDebug
> Task :app:preDebugUnitTestBuild UP-TO-DATE
> Task :app:processDebugUnitTestJavaRes NO-SOURCE
> Task :app:preReleaseUnitTestBuild UP-TO-DATE
> Task :app:processReleaseUnitTestJavaRes NO-SOURCE
> Task :app:javaPreCompileReleaseUnitTest
> Task :app:mergeReleaseNativeLibs
> Task :app:stripReleaseDebugSymbols NO-SOURCE
> Task :app:javaPreCompileDebugUnitTest
> Task :app:compileDebugUnitTestJavaWithJavac
> Task :app:testDebugUnitTest
> Task :app:mergeDebugJavaResource
> Task :app:packageDebug
> Task :app:assembleDebug
> Task :app:javaPreCompileRelease
> Task :app:compileReleaseJavaWithJavac
> Task :app:compileReleaseSources
> Task :app:lintVitalRelease SKIPPED
> Task :app:dexBuilderRelease

> Task :app:lint
Ran lint on variant release: 7 issues found
Ran lint on variant debug: 7 issues found
Wrote HTML report to file:///var/lib/jenkins/workspace/test/app/build/reports/lint-results.html
Wrote XML report to file:///var/lib/jenkins/workspace/test/app/build/reports/lint-results.xml

> Task :app:compileReleaseUnitTestJavaWithJavac
> Task :app:testReleaseUnitTest
> Task :app:test
> Task :app:check
> Task :app:mergeReleaseJavaResource
> Task :app:mergeDexRelease
> Task :app:packageRelease
> Task :app:assembleRelease
> Task :app:assemble
> Task :app:build

BUILD SUCCESSFUL in 13s
52 actionable tasks: 51 executed, 1 up-to-date
Build step 'Invoke Gradle script' changed build result to SUCCESS
Archiving artifacts
Finished: SUCCESS
```