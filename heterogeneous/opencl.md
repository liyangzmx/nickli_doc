# Ubuntu 20.04 LTS安装opencl

## 系统信息  
```
nickli@Earth:/opt/work$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04 LTS
Release:	20.04
Codename:	focal
nickli@Earth:/opt/work$ cat /proc/version
Linux version 5.4.0-37-generic (buildd@lcy01-amd64-001) (gcc version 9.3.0 (Ubuntu 9.3.0-10ubuntu2)) #41-Ubuntu SMP Wed Jun 3 18:57:02 UTC 2020
```

## RX580显卡驱动的下载
[https://drivers.amd.com/drivers/linux/amdgpu-pro-20.20-1089974-ubuntu-20.04.tar.xz](https://drivers.amd.com/drivers/linux/amdgpu-pro-20.20-1089974-ubuntu-20.04.tar.xz)  
请您根据您实际的情况下载对应的驱动

## 安装驱动
```
$ mkdir amd-gpu
$ cd amd-gpu/
$ tar xvf /download/amdgpu-pro-20.20-1089974-ubuntu-20.04.tar.xz
$ cd amdgpu-pro-20.20-1089974-ubuntu-20.04/
$ sudo ./amdgpu-install
```

安装完成后需要重启电脑(祝您好运~)

## 安装clinfo工具查看显卡对OpenCL的支持情况
```
$ sudo apt-get install clinfo
$ cliinfo
nickli@Earth:/opt/work$ clinfo 
Number of platforms                               1
  Platform Name                                   AMD Accelerated Parallel Processing
  Platform Vendor                                 Advanced Micro Devices, Inc.
  Platform Version                                OpenCL 2.1 AMD-APP (3110.6)
  Platform Profile                                FULL_PROFILE
  Platform Extensions                             cl_khr_icd cl_amd_event_callback cl_amd_offline_devices 
  Platform Host timer resolution                  1ns
  Platform Extensions function suffix             AMD

  Platform Name                                   AMD Accelerated Parallel Processing
Number of devices                                 1
  Device Name                                     Ellesmere
  Device Vendor                                   Advanced Micro Devices, Inc.
  Device Vendor ID                                0x1002
  Device Version                                  OpenCL 1.2 AMD-APP (3110.6)
  Driver Version                                  3110.6
  Device OpenCL C Version                         OpenCL C 1.2 
... ...
```

## 安装OpenCL的头文件和库
```
nickli@Earth:/opt/work$ sudo apt-get install opencl-headers
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages were automatically installed and are no longer required:
  guile-2.0-libs libgsoap-2.8.91 libm17n-0 libotf0 libqt5opengl5 libvncserver1 m17n-db virtualbox-dkms
... ...
Setting up opencl-clhpp-headers (2.1.0~~git51-gc5063c3-1) ...
Setting up opencl-c-headers (2.2~2019.08.06-g0d5f18c-1) ...
Setting up opencl-headers (2.2~2019.08.06-g0d5f18c-1) ...

nickli@Earth:/opt/work$ sudo apt install opencl-dev
[sudo] password for liyang: 
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Note, selecting 'ocl-icd-opencl-dev' instead of 'opencl-dev'
The following packages were automatically installed and are no longer required:
  guile-2.0-libs libgsoap-2.8.91 libm17n-0 libotf0 libqt5opengl5 libvncserver1 m17n-db virtualbox-dkms
... ...
Unpacking ocl-icd-opencl-dev:amd64 (2.2.11-1ubuntu1) ...
Setting up ocl-icd-opencl-dev:amd64 (2.2.11-1ubuntu1) ...
```

## 测试代码
### 代码编写
**假设**: 源码路径: **/opt/work/cl/**  
主机源码文件名: **cl.c**, 同级别目录编写**CMakeLists.txt**文件:  
```
cmake_minimum_required( VERSION 2.8.10 )

project( Example )

find_package( OpenCL REQUIRED )

include_directories( ${OPENCL_INCLUDE_DIR} )

add_executable( example cl.c )

target_link_libraries( example ${OPENCL_LIBRARIES} )
```

### 编译
执行cmake命令生成Makefile(/opt/work/cl/下)  
```
$ mkdir build
$ cd build
$ cmake -DOPENCL_INCLUDE_DIR=/usr/include -DOPENCL_LIBRARIES=/lib/x86_64-linux-gnu/libOpenCL.so ..
```

### 编写cl.c源程序
```
#define PROGRAM_FILE "matvec.cl"
#define KERNEL_FUNC "matvec_mult"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#ifdef MAC
#include <OpenCL/cl.h>
#else
#include <CL/cl.h>
#endif

void show_float4(float data[4]) {
    int i = 0;

    for(i = 0; i < 4; i++) {
        if(i != 3) {
            printf("%f, ", data[i]);
        } else {
            printf("%f", data[i]);
        }
    }
    printf("\n\n");
}

int main() {
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_int i, err;

    cl_program program;
    FILE *program_handle;
    char *program_buffer, *program_log;
    size_t program_size, log_size;
    cl_kernel kernel;
    size_t work_units_per_kernel;

    float mat[16], vec[4], result[4];
    float correct[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    cl_mem mat_buff, vec_buff, res_buff;

    for(i = 0; i < 16; i++) {
        mat[i] = i * 2.0f;
    }

    for(i = 0; i < 4; i++) {
        vec[i] = i * 3.0f;
        correct[0] += mat[i]        * vec[i];
        correct[1] += mat[i + 4]    * vec[i];
        correct[2] += mat[i + 8]    * vec[i];
        correct[3] += mat[i + 12]   * vec[i];
    }
    clGetPlatformIDs(1, &platform, NULL);
    clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
    context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    program_handle = fopen(PROGRAM_FILE, "r");
    fseek(program_handle, 0, SEEK_END);
    program_size = ftell(program_handle);
    rewind(program_handle);
    program_buffer = (char *)malloc(program_size + 1);
    program_buffer[program_size] = '\0';
    fread(program_buffer, sizeof(char), program_size, program_handle);
    fclose(program_handle);

    program = clCreateProgramWithSource(context, 1, (const char **)&program_buffer, &program_size, &err);
    free(program_buffer);

    clGetProgramInfo(program, CL_PROGRAM_SOURCE, 0, NULL, &program_size);
    program_buffer = (char *)malloc(program_size);
    clGetProgramInfo(program, CL_PROGRAM_SOURCE, program_size, program_buffer, 0);
    printf("Program Source: \n%s\n\n", program_buffer);
    free(program_buffer);

    err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    if(err < 0) {
        printf("CL_PROGRAM_BUILD_STATUS: %d\n", err);
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);
        printf("log_size: %ld\n", log_size);
        program_log = (char *) malloc (log_size + 1);
        program_log[log_size] = '\0';
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, log_size, program_log, NULL);
        printf("Program log: %s\n", program_log);
        free(program_log);
        exit(1);
    }

    kernel = clCreateKernel(program, KERNEL_FUNC, &err);
    if(0 > err) {
        printf("clCreateKernel status: %d\n", (int32_t)err);
        exit(1);
    }
    queue = clCreateCommandQueue(context, device, 0, &err);
    if(0 > err) {
        printf("clCreateCommandQueue status: %d\n", (int32_t)err);
        exit(1);
    }
    mat_buff = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, sizeof(float) * 16, mat, &err);
    vec_buff = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, sizeof(float) * 4, vec, &err);
    res_buff = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(float) * 4, NULL, &err);

    clSetKernelArg(kernel, 0, sizeof(cl_mem), &mat_buff);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), &vec_buff);
    clSetKernelArg(kernel, 2, sizeof(cl_mem), &res_buff);

    work_units_per_kernel = 4;
    clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &work_units_per_kernel, NULL, 0, NULL, NULL);
    clEnqueueReadBuffer(queue, res_buff, CL_TRUE, 0, sizeof(float) * 4, result, 0, NULL, NULL);
    printf("Result: \n");
    show_float4(result);
    printf("Correct: \n");
    show_float4(correct);

    if((result[0] == correct[0]) && (result[1] == correct[1])
            && (result[2] == correct[2]) && (result[3] == correct[3])) {
        printf("Matrix-vector multiplication successful.\n");
    }
    else {
        printf("Matrix-vector multiplication unsuccessful.\n");
    }

    clReleaseMemObject(mat_buff);
    clReleaseMemObject(vec_buff);
    clReleaseMemObject(res_buff);
    clReleaseKernel(kernel);
    clReleaseCommandQueue(queue);
    clReleaseProgram(program);
    clReleaseContext(context);

    return 0;
}
```

### 编译cl.c
```
nickli@Earth:/opt/work/cl$ cd build/; make; cd ..
[ 50%] Building C object CMakeFiles/example.dir/cl.c.o
In file included from /usr/include/CL/cl.h:32,
                 from /opt/work/cl/cl.c:12:
/usr/include/CL/cl_version.h:34:9: note: #pragma message: cl_version.h: CL_TARGET_OPENCL_VERSION is not defined. Defaulting to 220 (OpenCL 2.2)
   34 | #pragma message("cl_version.h: CL_TARGET_OPENCL_VERSION is not defined. Defaulting to 220 (OpenCL 2.2)")
      |         ^~~~~~~
/opt/work/cl/cl.c: In function 'main':
/opt/work/cl/cl.c:100:5: warning: 'clCreateCommandQueue' is deprecated [-Wdeprecated-declarations]
  100 |     queue = clCreateCommandQueue(context, device, 0, &err);
      |     ^~~~~
In file included from /opt/work/cl/cl.c:12:
/usr/include/CL/cl.h:1781:1: note: declared here
 1781 | clCreateCommandQueue(cl_context                     context,
      | ^~~~~~~~~~~~~~~~~~~~
[100%] Linking C executable example
[100%] Built target example
```

### 编写kernel程序: **matvec.cl**
```
__kernel void matvec_mult(  __global float4* matrix, 
                            __global float4* vector, 
                            __global float* result) {
    int i = get_global_id(0);
    result[i] = dot(matrix[i], vector[0]);
}
```

### 运行
```
nickli@Earth:/opt/work/cl$ ./build/example 
Program Source: 
__kernel void matvec_mult(  __global float4* matrix, 
                            __global float4* vector, 
                            __global float* result) {
    int i = get_global_id(0);
    result[i] = dot(matrix[i], vector[0]);
}

Result: 
84.000000, 228.000000, 372.000000, 516.000000

Correct: 
84.000000, 228.000000, 372.000000, 516.000000

Matrix-vector multiplication successful.
```