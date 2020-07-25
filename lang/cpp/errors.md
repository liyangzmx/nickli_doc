# C++ Errors

#### error: cannot convert 'double*' to 'int*' in initialization
不能用一个double类型的地址初始化一个int *类型的指针

#### error: uninitialized const 'k' [-fpermissive]
常量必须初始化

#### error: cannot bind non-const lvalue reference of type 'int&' to an rvalue of type 'int'
无法绑定一个左值的非常量引用到一个字面型的右值上

#### error: binding reference of type 'int&' to 'const int' discards qualifiers
绑定一个左值的非常量引用到一个常量类型的右值上将丢失常量限定

#### error: assignment of read-only location '*(const double*)pip'
不能对一个常量指针所指的地方赋值

#### error: inconsistent deduction for 'auto': 'int' and then 'double'
不能用auto同时定义两个不同类型的变量


