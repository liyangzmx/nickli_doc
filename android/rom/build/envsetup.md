# envsetup

## `source build/envsetup.sh`

## `m()`
在文件`source build/envsetup.sh`中:
```
function m()
{
    local T=$(gettop)
    if [ "$T" ]; then
        # 执行 build/soong/soong_ui.bash
        _wrap_build $T/build/soong/soong_ui.bash --make-mode $@
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
}

... ...
function _wrap_build()
{
    if [[ "${ANDROID_QUIET_BUILD:-}" == true ]]; then
      "$@"
      return $?
    fi
    local start_time=$(date +"%s")
    # 执行命令
    "$@"
    local ret=$?
    # 统计编译时间
    local end_time=$(date +"%s")
    local tdiff=$(($end_time-$start_time))
    local hours=$(($tdiff / 3600 ))
    local mins=$((($tdiff % 3600) / 60))
    local secs=$(($tdiff % 60))
    local ncolors=$(tput colors 2>/dev/null)
    if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
        color_failed=$'\E'"[0;31m"
        color_success=$'\E'"[0;32m"
        color_reset=$'\E'"[00m"
    else
        color_failed=""
        color_success=""
        color_reset=""
    fi
    echo
    # 打印编辑结果
    if [ $ret -eq 0 ] ; then
        echo -n "${color_success}#### build completed successfully "
    else
        echo -n "${color_failed}#### failed to build some targets "
    fi
    if [ $hours -gt 0 ] ; then
        printf "(%02g:%02g:%02g (hh:mm:ss))" $hours $mins $secs
    elif [ $mins -gt 0 ] ; then
        printf "(%02g:%02g (mm:ss))" $mins $secs
    elif [ $secs -gt 0 ] ; then
        printf "(%s seconds)" $secs
    fi
    echo " ####${color_reset}"
    echo
    return $ret
}
```

在文件`build/soong/soong_ui.bash`中:
```
export TRACE_BEGIN_SOONG=$(date +%s%N)

# 获取顶层目录
# Function to find top of the source tree (if $TOP isn't set) by walking up the
# tree.
function gettop
{
    local TOPFILE=build/soong/root.bp
    if [ -n "${TOP-}" -a -f "${TOP-}/${TOPFILE}" ] ; then
        # The following circumlocution ensures we remove symlinks from TOP.
        (cd $TOP; PWD= /bin/pwd)
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                \cd ..
                T=`PWD= /bin/pwd -P`
            done
            \cd $HERE
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

# Save the current PWD for use in soong_ui
export ORIGINAL_PWD=${PWD}
export TOP=$(gettop)
# 生效build/soong/scripts/microfactory.bash脚本
source ${TOP}/build/soong/scripts/microfactory.bash

# 构建soong_ui程序
soong_build_go soong_ui android/soong/cmd/soong_ui

cd ${TOP}
exec "$(getoutdir)/soong_ui" "$@"
```
`soong_build_go()`定义在`build/soong/scripts/microfactory.bash`中:
```
# Bootstrap microfactory from source if necessary and use it to build the
# requested binary.
#
# Arguments:
#  $1: name of the requested binary
#  $2: package name
function soong_build_go
{
    BUILDDIR=$(getoutdir) \
      SRCDIR=${TOP} \
      # build/blueprint是blueprint的工作目录, 此时是golang的源码
      BLUEPRINTDIR=${TOP}/build/blueprint \
      # 
      EXTRA_ARGS="-pkg-path android/soong=${TOP}/build/soong -pkg-path github.com/golang/protobuf=${TOP}/external/golang-protobuf" \
      # 这句话相当于: build_go soong_ui android/soong/cmd/soong_ui
      # 编译android/soong/cmd/soong_ui的go代码为soong_ui
      build_go $@
}
# build_go()来自于如下脚本
source ${TOP}/build/blueprint/microfactory/microfactory.bash
```

查看`build_go`脚本:
```
function build_go
{
    # Increment when microfactory changes enough that it cannot rebuild itself.
    # For example, if we use a new command line argument that doesn't work on older versions.
    local mf_version=3

    local mf_src="${BLUEPRINTDIR}/microfactory"
    local mf_bin="${BUILDDIR}/microfactory_$(uname)"
    local mf_version_file="${BUILDDIR}/.microfactory_$(uname)_version"
    local built_bin="${BUILDDIR}/$1"
    # 默认从源码执行
    local from_src=1

    # 但是如果生成了${mf_bin}, 则$from_src为0
    if [ -f "${mf_bin}" ] && [ -f "${mf_version_file}" ]; then
        if [ "${mf_version}" -eq "$(cat "${mf_version_file}")" ]; then
            from_src=0
        fi
    fi

    local mf_cmd
    if [ $from_src -eq 1 ]; then
        # `go run` requires a single main package, so create one
        local gen_src_dir="${BUILDDIR}/.microfactory_$(uname)_intermediates/src"
        mkdir -p "${gen_src_dir}"
        # 把build/blueprint/microfactory/microfactory.go中的"package microfactory"替换成"package main", 并将替换后的go文件拷贝到: out/.microfactory_Linux_intermediates/src/microfactory.go
        sed "s/^package microfactory/package main/" "${mf_src}/microfactory.go" >"${gen_src_dir}/microfactory.go"
        # 从源码执行时, 使用go运行替换后的: out/.microfactory_Linux_intermediates/src/microfactory.go
        mf_cmd="${GOROOT}/bin/go run ${gen_src_dir}/microfactory.go"
    else
        # 从二进制运行时, 执行:out/microfactory_Linux
        mf_cmd="${mf_bin}"
    fi

    rm -f "${BUILDDIR}/.$1.trace"
    # GOROOT must be absolute because `go run` changes the local directory
    # build生成out/microfactory_Linux, 此时如果从源码执行, 将生成该bin, 
    # 如果从out/microfactory_Linux中执行, 则判断是否重新生成
    # 如果${mf_bin}不为空, 
    GOROOT=$(cd $GOROOT; pwd) ${mf_cmd} -b "${mf_bin}" \
            # 此处做了包的映射, 源码中本身的"github.com/google/blueprint"被映射到了: "build/blueprint"
            # 因此"github.com/google/blueprint/microfactory/main"就被映射到了:"build/blueprint/package/main", 因此编译的是"build/blueprint/package/main/main.go", 生成的输出是: ${built_bin}也就是soong_ui
            -pkg-path "github.com/google/blueprint=${BLUEPRINTDIR}" \
            -trimpath "${SRCDIR}" \
            ${EXTRA_ARGS} \
            # $2是: android/soong/cmd/soong_ui
            # 而对于该包, 在build/soong/ui/build/path.go中, 被
            # SetupPath()映射成了: build/soong/cmd/soong_ui
            -o "${built_bin}" $2

    if [ $? -eq 0 ] && [ $from_src -eq 1 ]; then
        echo "${mf_version}" >"${mf_version_file}"
    fi
}
```

接上文的`build/soong/soong_ui.bash`:
```
... ...
# 构建soong_ui程序
soong_build_go soong_ui android/soong/cmd/soong_ui

cd ${TOP}
exec "$(getoutdir)/soong_ui" "$@"
```