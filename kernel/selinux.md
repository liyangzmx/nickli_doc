# SELinux

## SEPolicy
sepolicy的分布十分广泛, 主要有以下几个部分:
* `device/${VENDOR}/${DEVICE}/**/sepolicy`
* `frameworks/av/services/audiopolicy/engineconfigurable/sepolicy`
* `external/selinux/python/sepolicy/sepolicy`
* `system/sepolicy/`  
* `system/extras/boottime_tools/bootio/sepolicy`
* `build/make/target/board/generic_arm64/sepolicy`
等等.

以`system/sepolicy`为例, `te`相关的规则主要分布在: 
* `system/sepolicy/prebuilts/api/${API}/private/`
* `system/sepolicy/prebuilts/api/${API}/public/`
* `system/sepolicy/private/`
* `system/sepolicy/public/`
* `system/sepolicy/vendor/`
几个目录中, `cil`同样如此.

对于`file_contexts`:
* `system/sepolicy/vendor/file_contexts`
* `system/sepolicy/private/file_contexts`
* `system/sepolicy/prebuilts/api/${API}/private/file_contexts`

对于`genfs_contexts`:
* `system/sepolicy/private/genfs_contexts`
* `system/sepolicy/prebuilts/api/${API}/genfs_contexts`


## *.te与(file.te & file_contexts)的关系
### te中的域
以`system/sepolicy/private/audioserver.te`为例:
```
# audioserver - audio services daemon

typeattribute audioserver coredomain;

type audioserver_exec, exec_type, file_type, system_file_type;
init_daemon_domain(audioserver)
tmpfs_domain(audioserver)
```
对于`init_daemin_damain()`, 其定义在:`system/sepolicy/public/te_macros`中.

`system/sepolicy/private/file_contexts`文件:
```
...
# System files
...
/system/bin/audioserver	u:object_r:audioserver_exec:s0
...
```
### file_contexts中的文件标识(file.te)
对于文件标识, 在`system/sepolicy/public/file.te`中:
```
...
type audioserver_data_file, file_type, data_file_type, core_data_file_type;
...
```
`system/sepolicy/private/file_contexts`文件:
```
# Misc data
...
/data/misc/audioserver(/.*)?    u:object_r:audioserver_data_file:s0
...
```
### 域对文件标识的访问权限
文件`system/sepolicy/private/audioserver.te`中:
```
...
userdebug_or_eng(`
  # used for TEE sink - pcm capture for debug.
  allow audioserver media_data_file:dir create_dir_perms;
  allow audioserver audioserver_data_file:dir create_dir_perms;
  allow audioserver audioserver_data_file:file create_file_perms;

  # ptrace to processes in the same domain for memory leak detection
  allow audioserver self:process ptrace;
')
...
```

## SEPolicy的编译
### te到cil的转换
以`system/sepolicy`为例, 首先查看`system/sepolicy/build/Android.bp`, 确定编译时使用的脚本:
* `system/sepolicy/build/build_sepolicy.py`
* `system/sepolicy/build/file_utils.py`

然后查看`system/sepolicy/Android.mk`:
```
...
pub_policy.cil := $(intermediates)/pub_policy.cil
$(pub_policy.cil): PRIVATE_POL_CONF := $(pub_policy.conf)
$(pub_policy.cil): PRIVATE_REQD_MASK := $(reqd_policy_mask.cil)
$(pub_policy.cil): $(HOST_OUT_EXECUTABLES)/checkpolicy \
$(HOST_OUT_EXECUTABLES)/build_sepolicy $(pub_policy.conf) $(reqd_policy_mask.cil)
        @mkdir -p $(dir $@)
        $(hide) $(CHECKPOLICY_ASAN_OPTIONS) $< -C -M -c $(POLICYVERS) -o $@ $(PRIVATE_POL_CONF)
        $(hide) $(HOST_OUT_EXECUTABLES)/build_sepolicy -a $(HOST_OUT_EXECUTABLES) filter_out \
                -f $(PRIVATE_REQD_MASK) -t $@
...
```

可以明显看出, cil由`build_sepolicy.py`完成从te到cil的转换, 特别注意的是, `build_sepolicy`支持`build_policy`和`filter_out`这两种操作, `filter_out`主要是完成te到cil的转换, 此时还没有完全进行编译.

### cil到precompiled_sepolicy的过程
在文件`system/sepolicy/Android.mk`的`precompiled_sepolicy`目标完成该过程, 该过程调用了`secilc`命令对cil文件进行了合并:
```
$(LOCAL_BUILT_MODULE): PRIVATE_CIL_FILES := $(all_cil_files)
$(LOCAL_BUILT_MODULE): PRIVATE_NEVERALLOW_ARG := $(NEVERALLOW_ARG)
$(LOCAL_BUILT_MODULE): $(HOST_OUT_EXECUTABLES)/secilc $(all_cil_files) $(built_sepolicy_neverallows)
        $(hide) $(HOST_OUT_EXECUTABLES)/secilc -m -M true -G -c $(POLICYVERS) $(PRIVATE_NEVERALLOW_ARG) \
                $(PRIVATE_CIL_FILES) -o $@ -f /dev/null
```

此时调用`secilc`对所有cil进行合并以及编译, 生成的文件在:`/vendor/etc/selinux/precompiled_sepolicy`

## 启动
平台通常有预编译的SEPolicy, 一般路径在`/vendor/etc/selinux/precompiled_sepolicy`

Andorid启动后, SELinux规则由`init`通过`SelinuxInitialize()`方法加载到`/sys/fs/selinux`
而通常情况下, `init`是通过`libselinux(external/selinux/libselinux)`将cli文件路径写入到`/sys/fs/selinux/load`中开始SEPolicy的加载的.

对于mapping规则的加载, 首先获取平台版本, 一般版本在`/vendor/etc/selinux/plat_sepolicy_vers.txt`文件中, 然后根据版本搜集对应的`/system/etc/selinux/mapping/${plat_vers}.cil`文件, 例如平台版本是`10000.0`, 则搜集`/system/etc/selinux/mapping/10000.0.cil`文件. 对于兼容部分, 如果有`/system/etc/selinux/mapping/${plat_vers}.compat.cil`, 也同样需要搜集.

**补充:** 关于`/system/etc/selinux/plat_sepolicy_and_mapping.sha256`, 该文件是`sha256sum`的校验文件, 校验的文件内容是: `/system/etc/selinux/plat_sepolicy.cil`和`/system/etc/selinux/mapping/${plat_vers}.cil`两个文件之和的内容.

如果下列路径文件存在:
* `/system_ext/etc/selinux/system_ext_sepolicy.cil`(无)
* `/system_ext/etc/selinux/mapping/${plat_vers}.cil`
* `/product/etc/selinux/product_sepolicy.cil`
* `/product/etc/selinux/mapping/${plat_vers}.cil`
* `/vendor/etc/selinux/plat_pub_versioned.cil`
* `/vendor/etc/selinux/vendor_sepolicy.cil`
* `/vendor/etc/selinux/nonplat_sepolicy.cil`(无)
* `/odm/etc/selinux/odm_sepolicy.cil`(无)

则进行搜集, 然后使用`/system/bin/secilc`对以上所有搜集到的`cil`文件进行**编译以及合并**, 合并到:`/dev/sepolicy.XXXXXX`, 然后通过`libselinux::selinux_android_load_policy_from_fd()`对合并后的`cil`文件进行加载.

全部`cil`规则加载完成后, 检查`/sys/fs/selinux/enforce`的内容, 如果是`1`表示内核强制启用selinux规则.  
然后检查内核启动命令行参数`/proc/cmdline`中关于`androidboot.selinux`的字段, 如果是"`permissive`", 则表示启用强制模式, 如果不是, 则表示内核当前状态和启动参数不符合, 重新进行配置, 这里以`/proc/cmdline`为主.

最后向`/sys/fs/selinux/checkreqprot`写如`0`.