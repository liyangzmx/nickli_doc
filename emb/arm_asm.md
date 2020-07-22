# C内联汇编(ARM)
嵌入式开发中常常遇到需要在C代码中内联汇编的情况, 关于这个内容, 你可以参考如下资料:  
[Writing inline assembly code](https://developer.arm.com/documentation/100748/0607/using-assembly-and-intrinsics-in-c-or-c---code/writing-inline-assembly-code)

对于交叉编译器, 安装:  
```
sudo apt install gcc-arm-linux-gnueabi
sudo apt install g++-arm-linux-gnueabi
```

我自己按照参考资料编写的例子:
```
#include <iostream>

int add(int i, int j) {
    int res = 0;
    __asm ("ADD %[result], %[input_i], %[input_j]"
        : [result] "=r" (res)
        : [input_i] "r" (i), [input_j] "r" (j)
        );
    return res;
}

int main(int, char**) {
    int a = 1;
    int b = 1;
    int c = add(a, b);
    std::cout << "Hello, world!, 1 + 1 = " << c << std::endl;
}
```

安装完成后, 你可以使用命令:  
```
arm-linux-gnueabi-g++ main.cpp -o asm_hello
```
构建你的程序, 但你可能无法在X86的计算机上执行编译完成后的程序, 你可以通过尝试安装如下程序解决这个问题:  
```
sudo apt install qemu-user
```

然后执行命令:
```
qemu-arm -L /usr/arm-linux-gnueabi/ asm_hello
```

我机器上的输出:
```
Hello, world!, 1 + 1 = 2
```