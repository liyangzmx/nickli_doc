# Android OpenGL Native API

## 参考资料
* [OpenGL® 4.5 Reference Pages](https://www.khronos.org/registry/OpenGL-Refpages/gl4/)

## 头文件
```
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
```

## CMakeLists.txt
```
target_link_libraries (
    ...
    EGL
    GLESv2
)
```

## GLShader
`GLuint GL_APIENTRY glCreateShader (GLenum type);`  
**REF**: [glCreateShader()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glCreateShader.xhtml)  
用于创建一个Shader, 其中`GLenum`是Shader类型, 常用的有两种:  
* GL_VERTEX_SHADER
* GL_FRAGMENT_SHADER
* GL_GEOMETRY_SHADER

`void glShaderSource (GLuint shader, GLsizei count, const GLchar *const*string, const GLint *length);`  
**REF**: [glShaderSource()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glShaderSource.xhtml)  
用于绑定Shader源码到已经创建的Shader, 参数1是shader id, 参数2是有几组源文件, 参数3是源码的string *列表, 参数4是源码长度, 可以为空.  

`void glCompileShader(	GLuint shader);`  
**REF**:  [glCompileShader()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glCompileShader.xhtml)  
用于编译源码, 前提是必须调用`glShaderSource()`对Shader进行过配置

`void glGetShaderiv (GLuint shader, GLenum pname, GLint *params);`  
**REF**:  [glGetShaderiv()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glGetShader.xhtml)  
用于获取Shader的信息, 参数1是shader id, 参数2是需要获取的参数类型, 参数3是参数的存放位置, 一般参数类型`GLenum`可选的有:
* GL_SHADER_TYPE
    返回Shader类型, 类型一般有: `GL_VERTEX_SHADER`, `GL_FRAGMENT_SHADER`和`GL_GEOMETRY_SHADER`三种
* GL_DELETE_STATUS
    返回Shader是否被删除, 返回`GL_TRUE`是已经被删除, 否则`GL_FALSE`为没有被删除.
* GL_COMPILE_STATUS
    获取Shader的编译状态, 如果是`GL_TRUE`表示编译成功, 如果是`GL_FALSE`表示编译遇到错误.
* GL_INFO_LOG_LENGTH
    获取Log信息的长度, 一般用于`GL_COMPILE_STATUS`结果为`GL_FALSE`的情况下获取Log
* GL_SHADER_SOURCE_LENGTH
    获取Shader的源码长度
为何不能获取Log? 因为获取Log有专门的函数:`glGetShaderInfoLog()`

`void glGetShaderInfoLog (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);`  
**REF**: [glGetShaderInfoLog()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glGetShaderInfoLog.xhtml)  
用于获取编译的Log输出, 参数1是shader id, 参数2是buffer的长度(可以理解为:maxLength), 参数3是实际返回的长度, 参数4是log的输出buffer地址

`void glDeleteShader (GLuint shader);`  
**REF**: [glDeleteShader()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glDeleteShader.xhtml)  
用于删除一个Shader, 只需要shader id做参数

## GLProgram
`GLuint glCreateProgram (void);`  
**REF**: [glCreateProgram()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glCreateProgram.xhtml)  
注意: **REF**提及了一些辅助函数, 应特别留意  
用于创建一个GL程序`GLProgram`, 这是一个抽象概念, 表示一个可运行的实体, 它将和一个GLShader绑定, 以执行其代码.

`void glAttachShader (GLuint program, GLuint shader);`  
**REF**: [glAttachShader()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glAttachShader.xhtml)  
关联一个Shader到GLProgram, 这是显然的. 一个GLProgram可以Attach到**多个**GLShader上, Attach完成后, 需要执行Link操作, 将多个Shader Link到一起, 使用的函数为:`glLinkProgram()`

`void glLinkProgram (GLuint program);`  
**REF**: [glLinkProgram()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glLinkProgram.xhtml)  
这是一个单纯对GLProgram的操作, 是其关联到的GLShader组成一个完整的GLProgram.

`void glGetProgramiv (GLuint program, GLenum pname, GLint *params);`  
**REF**: [glGetProgram()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glGetProgram.xhtml)  
获取`GLProgram`的输出, 有很多的可选参数(仅介绍`GL_LINK_STATUS`和`GL_INFO_LOG_LENGTH`):
* GL_DELETE_STATUS
* GL_LINK_STATUS
    获取Link的状态, `GL_TRUE`表示成功, `GL_FALSE`表示失败, 需要先获取`GL_INFO_LOG_LENGTH`, 然后使用`glGetProgramInfoLog()`方法获取Log的输出.
* GL_VALIDATE_STATUS
* GL_INFO_LOG_LENGTH
    获取Link的Log长度, 结果将会保存在参数3中所指的buffer
* GL_ATTACHED_SHADERS
* GL_ACTIVE_ATOMIC_COUNTER_BUFFERS
* GL_ACTIVE_ATTRIBUTES
* GL_ACTIVE_ATTRIBUTE_MAX_LENGTH
* GL_ACTIVE_UNIFORMS
* GL_ACTIVE_UNIFORM_BLOCKS
* GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH
* GL_ACTIVE_UNIFORM_MAX_LENGTH
* GL_COMPUTE_WORK_GROUP_SIZE
* GL_PROGRAM_BINARY_LENGTH
* GL_TRANSFORM_FEEDBACK_BUFFER_MODE
* GL_TRANSFORM_FEEDBACK_VARYINGS
* GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH
* GL_GEOMETRY_VERTICES_OUT
* GL_GEOMETRY_INPUT_TYPE
* GL_GEOMETRY_OUTPUT_TYPE

`void glGetProgramInfoLog (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);`  
**REF**:  [glGetProgramInfoLog()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glGetProgramInfoLog.xhtml)  
用法和`glGetShaderInfoLog()`一致

`void glDeleteProgram(	GLuint program);`  
**REF**: [glDeleteProgram()](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glDeleteProgram.xhtml)  
用来删除一个GLProgram, 只需要提供GLProgram的id即可.