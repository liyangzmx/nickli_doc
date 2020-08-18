# Android.bp

## cc_library_shared
```
cc_library_shared {
    // 动态库名称
    name: "...", 

    // 源码文件列表
    srcs: [
        "***/***.c", 
        "***.cpp", 
    ], 

    // cflags为编译时的C选项
    cflags: [
        "-D...", 
        "-D...", 
    ], 

    // cppflags为编译时的C++选项
    cflags: [
        "-D...", 
        "-D...", 
    ], 

    // 导出该库的头文件
    export_include_dirs: [
        "include", 
        "..."
    ], 

    // 特别的, 如果该库的头文件引用了第三方的头文件, 那么使用如下配置导出引用的头文件
    export_shared_lib_headers: [
        "libbinder", 
        "lib***", 
    ], 
    // 依赖的头文件, 注意: 从${TOP_DIR}开始
    include_dirs: [
        "frameworks/av/services/audiopolicy", 
        "...",  
    ], 

    // 依赖的动态苦
    shared_libs: [
        "libutils", 
        "lib***", 
    ], 

    // 依赖的静态库, 被依赖的库应由cc_library_static创建
    static_libs: [
        "libcpustats", 
        "lib***", 
    ], 

    // 编译检查选项
    sanitize: {
        // 整数溢出排错功能
        // 参考: https://source.android.com/devices/tech/debug/intsan
        integer_overflow: true,
    }
}
```

## prebuilt_etc
```
prebuilt_etc {
    // 预置的名称
    name: "", 
    // 文件放置的位置: /etc/<path>/
    sub_dir: "<path>", 
    // 架构相关的src配置
    arch: {
        arm: {
            src: "...", 
        }, 
        arm64: {
            src: "...", 
        }, 
        x86: {
            src: "...", 
        }, 
        x86_64: {
            src: "...", 
        }, 
    }, 
    // 非架构相关的src配置
    src: "", 
    // 依赖(非强制?)
    required: [
        "...", 
    ], 
}
```

## android_app
```
android_app {
    // 软件包名称(仅用于Build)
    name: "...", 
    // 源码列表, 支持通配符
    srcs: [
        "**/*.java", 
    ], 
    // 资源文件路径
    resource_dirs: [
        "res", 
        "...", 
    ], 
    // dexopt选项
    dex_preopt: {
        // 禁用dexopt, 默认为true
        enabled: false,
    }
    // 执行AndroidManifest.xml的路径
    manifest: "***/AndroidManifest.xml"
    // 最小sdk版本
    min_sdk_version: "[0-9][0-9]",
    // 目标sdk版本
    sdk_version: "[0-9][0-9]", 
    // 覆盖的其它App
    overrides: [
        "...", 
    ],
    // 使用平台的API版本
    platform_apis: true,
    // 签名方式: platform
    certificate: "platform",
    // 设置为特权App
    privileged: true,
    // 依赖
    required:[
        "...", 
    ], 
    // 优化选项
    optimize: {
        // 混淆选项
        proguard_flags_files: ["..."],
    }, 
    // 依赖的java_library
    static_libs: [
        "...", 
    ], 
    // SDK的版本, current: 当前版本
    sdk_version: "current",
}
```

一个使用Android创建的App如何通过编写Android.bp
```
android_app {
    name: "TestAndroidBp", 
    min_sdk_version: "23", 
    sdk_version: "current",
    srcs: [
        "app/src/main/java/**/*.java"
    ], 
    resource_dirs: [
        "app/src/main/res", 
    ], 
    manifest: "app/src/main/AndroidManifest.xml", 
    platform_apis: true,
    certificate: "platform",
    privileged: true,
    dex_preopt: {
        enabled: false, 
    }, 
    optimize: {
        enabled: false, 
    }, 
    static_libs: [
        "androidx.appcompat_appcompat", 
        "androidx-constraintlayout_constraintlayout",
    ], 
}
```