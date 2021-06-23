# OpenGL ES 3.0 API

## EGL
---
### 检查错误
`EGLint eglGetError()`  
|返回值|说明|
|:-|:-|
|**GL_SUCCESS** |成功  
|**<其它值>** |错误码

---
### 初始化EGL
`EGLBoolean eglInitialize(EGLDisplay display, EGLint *majorVersion, EGLint *minorVersion)`  
|参数|说明|
|:-|:-|
|**display**         |指定EGL显示连接  
|**majorVersion**    |指定EGL实现返回的主版本号, 可能为NULL  
|**minorVersion**    |指定EGL实现返回的次版本号, 可能为NULL  

|返回值|说明|
|:-|:-|
|**EGL_TRUE:** |成功  
|**EGL_FALSE:** |失败

|错误码|说明|
|:-|:-|
|**EGL_NOT_INITIALIZED**|如果EGL没有初始化|
|**EGL_BAD_DISPLAY**|如果display没有指定有效的`EGLDisplay`

---
### 确定可用的表面配置
`EGLBoolean eglGetConfigs(EGLDisplay display, EGLConfig *configs, EGLint maxReturnConfigs, EGLint *numConfigs)`
|参数|说明|
|:-|:-|
|**display**    |指定EGL显示连接  
|**configs**    |指定configs列表  
|**maxReturnConfigs** |指定configs的大小  
|**numConfigs**    |指定返回的configs大小  

|返回值|说明|
|:-|:-|
|**EGL_TRUE** |成功  
|**EGL_FALSE** |失败

|错误码|说明|
|:-|:-|
|**EGL_NOT_INITIALIZED**|如果EGL没有初始化|
|**EGL_BAD_PARAMETER**|如果numConfigs为空

---
### 查询EGLConfig属性
`EGLBoolean eglGetConfigAttrib(EGLDisplay display, EGLConfig config, EGLint attribute, EGLint *value)`  
|参数|说明|
|:-|:-|
|**display**|指定EGL显示连接
|**config**|指定要查询的配置
|**attribute**|指定返回的特定属性
|**value**|指定返回值

|返回值|说明|
|:-|:-|
|**EGL_TRUE** |成功  
|**EGL_FALSE** |失败

|错误码|说明|
|:-|:-|
|**GL_BAD_ATTRIBUTE**|`attribute`不是有效的属性

EGLConfig属性
|属性|描述|默认值|
|:-|:-|:-|
|**EGL_BUFFER_SIZE**|颜色缓冲区中所有颜色分量的位数|0|
|**EGL_RED_SIZE**|颜色缓冲区中红色分量位数|0|
|**EGL_GREEN_SIZE**|颜色缓冲区中绿色分量位数|0|
|**EGL_BLUE_SIZE**|颜色缓冲区中蓝色分量位数|0|
|**EGL_LUMINANCE_SIZE**|颜色缓冲区中亮度位数|0|
|**EGL_ALPHA_SIZE**|颜色缓冲区中Alpha值位数|0|
|**EGL_ALPHA_MASK_SIZE**|掩码缓冲区中Alpha掩码位数|0|
|**EGL_BIND_TO_TEXTURE_RGB**|如果可以绑定到RGB纹理, 则为真|`EGL_DONT_CARE`|
|**EGL_BIND_TO_TEXTURE_ARGB**|如果可以绑定到ARGB纹理, 则为真|`EGL_DONT_CARE`|
|**EGL_COLOR_BUFFER_TYPE**|颜色缓冲区类型:EGL_RGB_BUFFER或EGL_LUMINANCE_BUFFER|`EGL_RGB_BUFFER`
|**EGL_CONFIG_CAVEAT**|和配置相关的任何注意事项|`EGL_DONT_CARE`|
|**EGL_CONFIG_ID**|唯一的EGLConfig标识值|`EGL_DONT_CARE`|
|**EGL_CONFORMANT**|如果用这个EGLConfig创建的上下文兼容, 则为真|-
|**EGL_DEPTH_SIZE**|深度缓冲区位数|0|
|**EGL_LEVEL**|帧缓冲级别|0|
|**EGL_MAX_PBUFFER_WIDTH**|用这个EGLConfig创建的PBuffer的最大宽度|-
|**EGL_MAX_PBUFFER_HEIGHT**|用这个EGLConfig创建的PBuffer的最大高度|-
|**EGL_MAX_PBUFFER_PIXELS**|用这个EGLConfig创建的PBuffer的最大尺寸|-
|**EGL_MAX_SWAP_INTERNAL**|最大缓冲区交换间隔|`EGL_DONT_CARE`
|**EGL_MIN_SWAP_INTERNAL**|最小缓冲区交换间隔|`EGL_DONT_CARE`
|**EGL_NATIVE_RENDERABLE**|如果原生渲染库可以渲染到用EGLConfig创建的表面则为真
|**EGL_NATIVE_VISUAL_ID**|关于应原生窗口系统可视ID句柄|`EGL_DONT_CARE`
|**EGL_NATIVE_VISUAL_TYPE**|关于应原生窗口系统可视类型|`EGL_DONT_CARE`
|**EGL_RENDERABLE_TYPE**|由<br>`EGL_OPENGL_ESBIT`<br>`EGL_OPENGL_ES2_BIG`<br>`EGL_OPENGL_ES3_BIT_KHR(需要EGL_KHR_create_context扩展)`<br>`EGL_OPENGL_BIT`<br>`EGL_OPENVG_BIT`<br>组成的掩码, 代表配置支持的渲染接口|`EGL_OPENGL_ES_BIT`|
|**EGL_SAMPLE_BUFFERS**|可用多重采样缓冲区数量|0|
|**EGL_SAMPLES**|每个像素的样本数量|0|
|**EGL_STENCIL_SIZE**|模板缓冲区位数|0|
|**EGL_SURFACE_TYPE**|支持的EGL表面类型, 可能是EGL_WINDOW_BIT<br>EGL_PIXMAP_BIT<br>EGL_PBUFFER_BIT<br>EGL_MULTISAMPLE_RESOVE_BOX_BIT<br>EGL_SWAP_BEHAVIOR_PRESERVED_BIT<br>EGL_VG_COLORSPACE_LINEAR_BIT<br>EGL_VG_ALPHA_FORMAT_PRE_BIT|`EGL_WINDOW_BIT`|
|**EGL_TRANSPARENT_TYPE**|支持的透明度|`EGL_NONE`|
|**EGL_TRANSPARENT_RED_VALUE**|解读为透明的红色值|`EGL_DONT_CARE`|
|**EGL_TRANSPARENT_GREEN_VALUE**|解读为透明的绿色值|`EGL_DONT_CARE`|
|**EGL_TRANSPARENT_BLUE_VALUE**|解读为透明的蓝色值|`EGL_DONT_CARE`|

---
### 让EGL选择配置
`EGLBoolean eglChooseConfig(EGLDisplay display, const EGLint *attribList, EGLConfig *configs, EGLint maxReturnConfigs, EGLint *numConfigs)`

|参数|说明|
|:-|:-|
|**display**|指定EGL显示连接
|**attribList**|指定configs匹配的属性列表
|**configs**|指定配置列表
|**maxReturnConfigs**|指定配置的大小
|**numConfigs**|指定返回的配置大小

|返回值|说明|
|:-|:-|
|**EGL_TRUE** |成功  
|**EGL_FALSE** |失败

`attribList`举例:
```
EGLint attribList[] = {
    EGL_RENDERABLE_TYPE, EGL_OPENGL_ES3_KHR_BIT, 
    EGL_RED_SIZE, 5,
    EGL_GREEN_SIZE, 6, 
    EGL_BLUE_SIZE, 5, 
    EGL_DEPTH_SIZE, 1, 
    EGL_NONE
};
```

---
### 创建屏幕上的渲染区域: EGL窗口
`EGLSurface eglCreateWindowSurface(EGLDisplay display, EGLConfig config, EGLNativeWindowType window, const EGLint *attribList)`

|参数|说明|
|:-|:-|
|**display**|指定EGL显示连接
|**config**|指定配置
|**window**|指定原生窗口
|**attribList**|指定窗口属性列表; 可能为NULL|

`eglCreateWindowSurface()`失败时可能的错误:  
|错误码|说明|
|:-|:-|
|**EGL_BAD_MATCH**|* 原生窗口属性不匹配提供的EGLConfig<br>* 提供的EGLConfig不支持渲染到窗口(也就是说EGL_SURFACE_TYPE属性没有设置EGL_WINDOW_BIT)|
|**EGL_BAD_CONFIG**|如果提供的EGLConfig没有得到系统的支持, 则标记该错误|
|**EGL_BAD_NATIVE_WINDOW**|如果提供的原生窗口句柄无效, 则指定该错误|
|**EGL_BAD_ALLOC**|如果eglCreateWindowSurface无法为新的EGL窗口分配资源, 或者已经有和提供原生窗口关联的EGLConfig, 则发生这种错误|

---
### 创建屏幕外渲染区域: EGL PBuffer
`EGLSurface eglCreatePbufferSurface(EGLDisplay display, EGLConfig config, const EGLint *attribList)`  
|参数|说明|
|:-|:-|
|**display**|指定EGL显示连接
|**config**|指定配置
|**attribList**|指定窗口属性列表; 可能为NULL|

EGL像素缓冲区属性:
|标志|描述|默认值|
|:-|:-|:-|
|**EGL_WIDTH**|指定Pbuffer的宽度|0|
|**EGL_HEIGHT**|指定Pbuffer的高度|0|
|**EGL_LARGEST_PBUFFER**|如果请求的大小不可用, 选择最大的可用pbuffer. 有效值为: EGL_TRUE和EGL_FALSE|`EGL_FALSE`|
|**EGL_TEXTURE_FORMAT**|如果pbuffer绑定到一个纹理贴图, 则制定纹理格式类型, 有效值是: EGL_TEXTURE_RGB, EGL_TEXTURE_RGBA, 和EGL_NO_TEXTURE(表示pbuffer不能直接用于纹理)|`EGL_NO_TEXTURE`|
|**EGL_TEXTURE_TARGET**|制定pbuffer作为纹理贴图时应该廉洁到的相关纹理目标, 有效值为EGL_TEXTURE_2D和EGL_NO_TEXTURE|`EGL_NO_TEXTURE`|
|**EGL_MIPMAP_TEXTURE**|指定是否应该另外为纹理mipmap级别, 分配存储. 有效值是: EGL_TRUE和EGL_FALS|`EGL_FALSE`|

`eglChooseConfig()`的`attribList`举例:
```
EGLint attribList[] = {
    EGL_SURFACE_TYPE, EGL_PBUFFER_BIT,
    EGL_RENDERABLE_TYPE, EGL_OPENGL_ES3_KHR_BIT,
    EGL_RED_SIZE, 5,
    EGL_GREEN_SIZE, 6,
    EGL_BLUE_SIZE, 5,
    EGL_DEPTH_SIZE, 1,
    EGL_NONE
};
```

`eglCreateWindowSurface()`的`attribList`举例:
```
EGLint attribList[] = {
    EGL_WIDTH, 512,
    EGL_HEIGHT, 512,
    EGL_LARGEST_PBUFFER, EGL_TRUE,
    EGL_NONE
};
```

---
### 创建一个渲染上下文
`EGLContext eglCreateContext(EGLDisplay display, EGLConfig config, EGLContext shareContext, const EGLint *attribList)`  
|参数|说明|
|:-|:-|
|**display**|指定EGL的显示连接
|**config**|指定配置|
|**shareContext**|允许多个EGL上下文共享特定类型的数据, 例如着色器程序和纹理贴图; 使用EGL_NO_CONTEXT表示没有共享
|**attribList**|指定创建上下文使用的属性列表; 只有一个可接受的属性: `EGL_CONTEXT_CLIENT_VERSION`|

用`eglCreateContext()`创建上下文时的属性: 
|标志|描述|默认值|
|:-|:-|:-|
|EGL_CONTEXT_CLIENT_VERSION|指定与你所使用的OpenGL ES版本相关的上下文类型|1(指定OpenGL ES 1.X上下文)

`eglCreateContext()`的`attribList`举例:
```
EGLint attribList[] = {
    EGL_CONTEXT_CLIENT_VERSION, 3,
    EGL_NONE
};
```

---
### 指定某个EGLContext为当前上下文
`EGLBoolean eglMakeCurrent(EGLDisplay display, EGLSurface draw, EGLSurface read, EGLContext context)`  
|参数|说明|
|:-|:-|
|**display**|指定EGL的显示连接
|**draw**|指定EGL绘图表面|
|**read**|指定EGL读取表面|
|**context**|指定连接到该表面的渲染上下文|

例子:
```
EGLBoolean initializeWindow(EGLNativeWindowType nativeWindow) {
    const EGLint configAttribs[] = {
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES3_KHR_BIT, 
        EGL_RED_SIZE, 8,
        EGL_GREEN_SIZE, 8, 
        EGL_BLUE_SIZE, 8, 
        EGL_DEPTH_SIZE, 24, 
        EGL_NONE
    };
    const EGLint contextAttribs[] = {
        EGL_CONTEXT_CLIENT_VERSION, 3,
        EGL_NONE
    };
    EGLDisplayer display = elgGetDisplay(EGL_DEFAULT_DISPLAY);
    if(display == ELG_NO_DISPLAY) {
        return EGL_FALSE;
    }
    EGLint major, minor;
    if(!eglInitialize(display, &major, &minor)) {
        return EGL_FALSE;
    }
    EGLConfig config;
    EGLint numConfigs;
    if(!eglChooseConfig(display, configAttribs, &config, 1, &numConfigs)) {
        return EGL_FALSE;
    }
    EGLSurface *window = eglCreateWindowSurface(display, config, nativeWindow, NULL);
    if(window == EGL_NO_SURFACE) {
        return EGL_FALSE;
    }
    EGLContext context = eglCreateContext(display, config, EGL_NO_CONTEXT, contextAttribs);
    if(context == EGL_NO_CONTEXT) {
        return EGL_FALSE;
    }
    if(!eglMakeCurrent(display, window, window, context)) {
        return EGL_FALSE;
    }
    return EGL_TRUE;
}
```

---

## Shader & Program
--- 
### 创建一个着色器
`GLuint glCreateShader(GLenum type)`  
|参数|说明|
|:-|:-|
|type|创建着色器的类型, 可以是: GL_VERTEX_SHADER或者GL_FRAGMENT_SHADER|

`void glDeleteShader(GLuint shader)`  
|参数|说明|
|:-|:-|
|shader|要删除的着色器对象的句柄|

`void glShaderSource(GLuint shader, GLsizei count, const GLchar * const *string, const GLint *length)`  
|参数|说明|
|:-|:-|
|shader|指向着色器对象的句柄|
|count|着色器源字符串的数量. 着色器可以有多个源字符串的数组指针, 但是每个着色器只能有一个main函数|
|string|指向保存数量为count的着色器源字符串的数组指针.|
|length|指向保存每个着色器字符串大小且元素变量为count的整数数组指针. 如果lenght为NULL, 着色器字符串将被认定为空. 如果length不为NULL, 它的每个元素保存对应于string数组的着色器字符数量. 如果任何元素的length均小于0, 则该字符串被认定以NULL结束.|

`void glCompileShader(GLuint shader)`  
|参数|说明|
|:-|:-|
|shader|需要编译的着色器对象句柄|

`void glGetShaderiv(GLuint shader, GLenum pname, GLint *params)`  
|参数|说明|
|:-|:-|
|**shader**|指向需要获取信息的着色器对象的句柄|
|**pname**|获得信息的参数, 可以为:<br>`GL_COMPILE_STATUS`: 编译成功为:`GL_TRUE`<br>`GL_DELETE_STATUS`<br>`GL_INFO_LOG_LENGTH`: 编译日志的长度<br>`GL_SHADER_SOURCE_LENGHT`: 源码长度(包括null终止符)<br>`GL_SHADER_TYPE`|
|**params**|指向查询结果的整数存储位置的指针|

`void glGetShaderInfoLog(GLuint shader, GLsizei maxLength, GLsizei *length, GLchar *infoLog)`  
|参数|说明|
|:-|:-|
|**shader**|指向需要获取日志的着色器对象的句柄|
|maxLength|保存信息日志的缓冲区大小|
|length|写入信息日志的长度(减去null终止符); 如果不需要知道长度, 这个参数可以为NULL|
|infoLog|指向保存信息日志的字符缓冲区的指针|

例子:
```
GLuint LoadShader(GLenum type, const char *shaderSrc) {
    GLuint shader;
    GLint compiled;

    shader = glCreateShader(type);
    if(shader == 0) {
        return 0;
    }
    glShaderSource(shader, 1, &shaderSrc, NULL);
    glCompileShader(shader);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if(!compiled) {
        GLint infoLen = 0;
        char *infoLog = glGetShaderInfoLog(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if(infoLen > 1) {
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            // DO anything...
            free(infoLog);
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}
```

---
### 创建和连接程序
`GLuint glCreateProgram()`  
简单返回一个句柄

`void glDeleteProgram(GLuint program)`  
|参数|说明|
|:-|:-|
|program|指向需要删除的程序对象句柄

`void glAttachShader(GLuint program, GLuint shader)`  
|参数|说明|
|:-|:-|
|program|指向程序对象的句柄|
|shader|指向程序连接的着色器对象的句柄|

`void glDetachShader(GLuint program, GLuint shader)`  
|参数|说明|
|:-|:-|
|program|向程序对象的句柄|
|shader|指向程序断开连接的着色器对象的句柄|

`void glLinkProgram(GLuint program)`  
|参数|说明|
|:-|:-|
|program|指向程序对象的句柄|

`void glGetProgramiv(GLuint program, GLenum pname, GLint *params)`  
|参数|说明|
|:-|:-|
|**program**|需要获取信息的程序对象句柄|
|**pname**|获取信息的参数, 可以是:<br>`GL_ACTIVE_ATTRIBUTES`: 顶点着色器中欧给你活动属性的数量<br>`GL_ACTIVE_ATTRIBUTE_MAX_LENGHT`<br>`GL_ACTIVE_UNIFORM_BLOCK`<br>`GL_ACTIVE_UNIFORM_BLOCK_MAX_LENGTH`<br>`GL_ACTIVE_UNIFORMS`<br>`GL_ACTIVE_UNIFORM_MAX_LENGTH`<br>`GL_ATTACHED_SHADERS`<br>`GL_DELETE_STATUS`<br>`GL_INFO_LOG_LENGTH`<br>`GL_LINK_STATUS`: 是否链接成功<br>`GL_PROGRAM_BINARY_RETRIEVABLE_HINT`<br>`GL_TRANSFORM_FEEDBACK_BUFFER_MODE`<br>`GL_TRANSFORM_FEEDBACK_VARYINGS`<br>`GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH`<br>`GL_VALIDATE_STATUS`|
|**params**|指向查询结果整数存储位置的指针

`void glGetProgramInfoLog(GLuint program, GLsizei maxLength, GLsizei *length, GLchar *infoLog)`  
|参数|说明|
|:-|:-|
|**program**|指向需要获取信息的程序对象的句柄|
|**maxLength**|存储信息日志的缓冲区大小|
|**length**|写入的信息日志长度(减去null终止符); 如果不需要知道长度, 这个参数可以是NULL|
|**infoLog**|指向存储信息日志的字符串缓冲区的指针

`void glValidateProgram(GLuint program)`  
|参数|说明|
|:-|:-|
|**program**|需要校验的程序对象的句柄|

`void glUseProgram(GLuint program)`  
|参数|说明|
|:-|:-|
|**params**|设置为活动程序的程序对象句柄|

`void glGetActiveUniform(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name)`  
|参数|说明|
|:-|:-|
|**program**|程序对象的句柄|
|**index**|查询的统一变量索引|
|**bufSize**|名称数组中的字符数字|
|**length**|如果不是NULL, 则是名称数组中写入的字符数(不含null终止符)|
|**size**|如果查询的统一变量是个数组, 这个变量将写入程序中使用的最大数组元素(加1); 如果查询的统一变量不是数组, 则该值为1|
|**type**|将写入统一变量的类型, 可以为:`GL_FLOAT`<br>`GL_FLOAT_VEC2`<br>`GL_FLOAT_VEC3`<br>`GL_FLOAT_VEC4`<br>`GL_INT`<br>`GL_INT_VEC2`<br>`GL_INT_VEC3`<br>`GL_INT_VEC4`<br>`GL_USIGNED_INT`<br>`GL_USIGNED_INT_VEC2`<br>`GL_USIGNED_INT_VEC3`<br>`GL_USIGNED_INT_VEC4`<br>`GL_BOOL`<br>`GL_BOOL_VEC2`<br>`GL_BOOL_VEC3`<br>`GL_BOOL_VEC4`<br>`GL_FLOAT_MAT2`<br>`GL_FLOAT_MAT3`<br>`GL_FLOAT_MAT4`<br>`GL_FLOAT_MAT2x3`<br>`GL_FLOAT_MAT2x4`<br>`GL_FLOAT_MAT3x2`<br>`GL_FLOAT_MAT3x4`<br>`GL_FLOAT_MAT4x2`<br>`GL_FLOAT_MAT4x3`<br>`GL_SAMPLER_2D`<br>`GL_SAMPLER_3D`<br>`GL_SAMPLER_CUBE`<br>`GL_SAMPLER_SHADOW`<br>`GL_SAMPLER_2D_ARRAY`<br>`GL_SAMPLER_ARRAY_SHADOW`<br>`GL_SAMPLER_CUBE_SHADOW`<br>`GL_INT_SAMPLER_2D`<br>`GL_INT_SAMPLER_3D`<br>`GL_INT_SAMPLER_CUBE`<br>`GL_INT_SAMPLER_2D_ARRAY`<br>`GL_UNSIGNED_INT_SAMPLER_2D`<br>`GL_UNSIGNED_INT_SAMPLER_3D`<br>`GL_UNSIGNED_INT_SAMPLER_CUBE`<br>`GL_UNSIGNED_INT_SAMPLER_2D_ARRAY`|

`void glGetActiveUniformsiv (GLuint program, GLsizei count, const GLuint* indices, GLenum pname, GLint* params)`
|参数|说明|
|:-|:-|
|**parame**|要查询的program对象|
|**count**|indices数组元素数量|
|**indices**|uniform索引列表|
|**pname**|要查询的属性, 可取值为:<br>`GL_UNIFORM_TYPE`<br>`GL_UNIFORM_SIZE`<br>`GL_UNIFORM_NAME_LENGTH`<br>`GL_UNIFORM_BLOCK_INDEX`<br>`GL_UNIFORM_OFFSET`<br>`GL_UNIFORM_ARRAY_STRIDE`<br>`GL_UNIFORM_MATRIX_STRIDE`<br>`GL_UNIFORM_IS_ROW_MAJOR`|
|**params**|指向查询结果|

查询到uniform的名字之后, 就可以根据名字查询uniform的位置, 注意, 命名uniform block里的uniform不会被分配一个位置(猜测应该是整个uniform block会被分配一个位置, 而里面的每个uniform不会再被单独分配一个):

`GLint glGetUniformLocation (GLuint program, const char* name)`  
|参数|说明|
|:-|:-|
|program|相应的program对象|
|name|要查询位置的uniform名字|

如果这个uniform是非激活状态,返回值为-1

查询到uniform的位置之后, 在根据位置和上面查询到的size和type, 就可以为这个uniform加载数据: 
`void glUniform1f (GLint location, GLfloat x)`  
`void glUniform1fv (GLint location, GLsizei count, const GLfloat * value)`  

`void glUniform1i (GLint location, GLint x)`  
`void glUniform1iv (GLint location, GLsizei count, const GLint * value)`  

`void glUniform1ui (GLint location, GLuint x)`  
`void glUniform1uiv (GLint location, GLsizei count, const GLuint * value)`  

`void glUniform2f (GLint location, GLfloat x, GLfloat y)`  
`void glUniform2fv (GLint location, GLsizei count, const GLfloat * value)`  

`void glUniform2i (GLint location, GLint x, GLint y)`  
`void glUniform2iv (GLint location, GLsizei count, const GLint * value)`  

`void glUniform2ui (GLint location, GLuint x, GLuint y)`  
`void glUniform2uiv (GLint location, GLsizei count, const GLuint * value)`  

`void glUniform3f (GLint location, GLfloat x, GLfloat y, GLfloat z)`  
`void glUniform3fv (GLint location, GLsizei count, const GLfloat * value)`  

`void glUniform3i (GLint location, GLint x, GLint y, GLint z)`  
`void glUniform3iv (GLint location, GLsizei count, const GLint * value)`  

`void glUniform3ui (GLint location, GLuint x, GLuint y, GLuint z)`  
`void glUniform3uiv (GLint location, GLsizei count, const GLuint * value)`  

`void glUniform4f (GLint location, GLfloat x, GLfloat y, GLfloat z, GLfloat w)`  
`void glUniform4fv (GLint location, GLsizei count, const GLfloat * value)`  

`void glUniform4i (GLint location, GLint x, GLint y, GLint z, GLint w)`  
`void glUniform4iv (GLint location, GLsizei count, const GLint * value)`  

`void glUniform4ui (GLint location, GLuint x, GLuint y, GLuint z, GLuint w)`  
`void glUniform4uiv (GLint location, GLsizei count, const GLuint * value)`  

`void glUniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  
`void glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  
`void glUniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`

`void glUniformMatrix2x3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  
`void glUniformMatrix3x2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  
`void glUniformMatrix2x4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  
`void glUniformMatrix4x2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  
`void glUniformMatrix3x4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  
`void glUniformMatrix4x3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat * value)`  

|参数|说明|
|:-|:-|
|**location**|uniform的位置|
|**count**|需要加载数据的数组元素的数量或者需要修改的矩阵的数量|
|**transpose**|指明矩阵是列优先(column major)矩阵(GL_FALSE)还是行优先(row major)矩阵(GL_TRUE)
|**x,y,z,w**|uniform的值|
|**value**|指向由count个元素的数组的指针|

---
###根据名字获得uniform block index
`GLuint glGetUniformBlockIndex (GLuint program, const GLchar * blockName)`  
|参数|说明|
|:-|:-|
|**program**|程序对象句柄|
|**blockName**|需要获取索引的统一变量块名称|

---
### 获得uniform block的名字
`void glGetActiveUniformBlockName (GLuint program, GLuint index, GLsizei bufSize, GLsizei * length, GLchar * blockName)`  
|参数|说明|
|:-|:-|
|**program**|程序对象句柄|
|**index**|需要获取索引的统一变量块索引|
|**bufSize**|名称数组中的字符数|
|**length**|如果不为NULL, 将写入名称数组中的字符数(减去null终止符)|
|**name**|将写入统一变量名称, 最大字符数为bufSize个字符, 这是一个以null终止的字符串|

---
### 获得uniform block的其他属性
`void glGetActiveUniformBlockiv (GLuint program, GLuint index, GLenum pname, GLint * params)`  
|参数|说明|
|:-|:-|
|**program**|程序对象句柄|
|**index**|要查询的统一变量块索引|
|**pname**|写入params的统一变量块索引属性, 可以是:<br>`GL_UNIFORM_BLOCK_BINDING` 返回uniform block的最后一个绑定点(如果uniform block不存在, 则为0)<br>`GL_UNIFORM_BLOCK_DATA_SIZE`: 返回包含uniform block中所有uniform的缓冲对象的最小尺寸<br>`GL_UNIFORM_BLOCK_NAME_LENGTH`: 返回uniform block名字的总长度(包括终止字符)<br>`GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS`: 返回uniform block中活动的uniform的数量<br>`GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES`: 返回uniform block中活动的uniform的索引列表<br>`GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER`: 返回uniform block是否由顶点shader引用<br>`GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER`: 返回uniform block是否由片段shader引用|
|**params**|写入pname指定的结果|

---
### 将uniform block index和program中的一个绑定点进行绑定
`void glUniformBlockBinding (GLuint program, GLuint blockIndex, GLuint blockBinding)`  
|参数|说明|
|:-|:-|
|**program**|程序对象句柄|
|**blockIndex**|统一变量块索引|
|**blockbinding**|统一变量缓冲对象绑定点|

---
### 将一个uniform buffer object和这个绑定点绑定
`void glBindBufferRange (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size)`  
`void glBindBufferBase (GLenum target, GLuint index, GLuint buffer)`  
|参数|说明|
|:-|:-|
|**target**|必须是:<br>`GL_UNIFORM_BUFFER`<br>`GL_TRANSFORM_FEEDBACK_BUFFER`|
|**index**|绑定索引|
|**buffer**|缓冲区对象句柄|
|**offset**|以字节数计算的缓冲对象起始偏移(仅`glBindBufferRange`|
|**size**|可以从缓冲对象读取或者写入缓冲对象的数据量(以字节数计算, 仅`glBindBufferRange`|

当编程使用到uniform时, 有以下限制要注意：
* 顶点shader或片段shader能使用的活动的uniform block是有数量限制的, 最大值可以通过`glGetIntegerv`调用`GL_MAX_VERTEX_UNIFORM_BLOCKS或`者`GL_MAX_FRAGMENT_UNIFORM_BLOCKS`来查询。任何实现的最大值都不会小于12.
* 一个program对象中所有shader能使用的活动的uniform block也是有数量限制的, 最大值可以通过`glGetIntegerv`调用`GL_MAX_COMBINED_UNIFORM_BLOCKS`查询. 任何实现的最大值都不会小于24. 
* 每个uniform缓冲对象的最大可用储存量的大小可以通过`glGetInteger64v`来查询. 任何实现的最大值都不会小于16KB. 

如何用前面描述的命名uniform block LightBlock来建立一个uniform缓冲对象:
```
GLuint blockId, bufferId;
GLint blockSize;
GLuint bindingPoint = 1;
GLfloat lightData[] =
{
    // lightDirection (padded to vec4 based on std140 rule)
    1.0f, 0.0f, 0.0f, 0.0f
    
    // lightPosition
    0.0f, 0.0f, 0.0f, 1.0f
};

// Retrieve the uniform block index
blockId = glGetUniformBlockIndex (program, "LightBlock")

glUniformBlockBinding (program, blockId, bindingPoint)

glGetActiveUniformBlockiv (program, blockId, GL_UNIFORM_BLOCK_DATA_SIZE, &blockSize)

glGenBuffers (1, &bufferId);
glBindBuffer (GL_UNIFORM_BUFFER, bufferId);
glBufferData (GL_UNIFORM_BUFFER, blockSize, lightData, GL_DYNAMIC_DRAW);

glBindBufferBase (GL_UNIFORM_BUFFER, bindingPoint, bufferId);
```

## Shader Compiler
---
### 释放shader的编译
`void glReleaseShaderCompiler (void)`  
这个方法只是一个hint, 所以有些实现会忽略这条命令

---
### 检索程序二进制码
`void glGetProgramBinary (GLuint program, GLsizei bufSize, GLsizei * length, GLenum binaryFormat, GLvoid * binary)`  
|参数|说明|
|:-|:-|
|**program**|program对象|
|**bufSize**|可能被写入到binary的字节最大值|
|**length**|写入binary的字节数|
|**binaryFormat**|binary格式|
|**binary**|binary数据|

---
### 将程序二进制码读回到 OpenGL ES
`void glProgramBinary (GLuint program, GLenum binaryFormat, const GLvoid * binary, GLsizei length)`  
|参数|说明|
|:-|:-|
|**program**|program对象|
|**binaryFormat**|binary格式|
|**binary**|binary数据|
|**length**|写入binary的字节数|

OpenGL ES并不指定任何二进制格式, 二进制格式完全由各个实现的供应商决定, 这意味着使用`glProgramBinary`的程序的可移植性不强, 即使同一供应商的不同版本之间, 二进制格式也可能改变。所以, 为了确保程序兼容, 在调用`glProgramBinary`之后, 需要通过glGetProgramiv调用`GL_LINK_STATUS`来检查状态, 如果失败, 那么还需要重新编译shader源码.

---

## 顶点属性, 顶点数组和缓冲区对象

### 指定常量顶点属性的值
`void glVertexAttrib1f(GLuint index, GLfloat x);`  
`void glVertexAttrib2f(GLuint index, GLfloat x, GLfloat y)`  
`void glVertexAttrib3f(GLuint index, GLfloat x, GLfloat y, GLfloat z)`  
`void glVertexAttrib4f(GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)`  
`void glVertexAttrib1fv(GLuint index, const GLfloat *value)`  
`void glVertexAttrib2fv(GLuint index, const GLfloat *value)`  
`void glVertexAttrib3fv(GLuint index, const GLfloat *value)`  
`void glVertexAttrib4fv(GLuint index, const GLfloat *value)`  
|参数|说明|
|:-|:-|
|**index**|指定顶点属性|
|**x,y,z,w**|指定常量顶点属性的值|
|**value**|指定常量顶点属性的值|

---
### 指定顶点数组
`void glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void *ptr)`  
`void glVertexAttribIPointer(GLuint index, GLint size, GLenum type, GLsizei stride, const void *ptr)`  
|参数|说明|
|:-|:-|
|**index**|指定通用顶点属性索引|
|**size**|顶点数组中为索引引用的顶点属性所指定的分量数量. 有效值为: 1 ~ 4|
|**type**|数据格式, **两个函数都**包括的有效值是:<br>`GL_BYTE`<br>`GL_UNSIGNED_BYTE`<br>`GL_SHORT`<br>`GL_UNSIGNED_SHORT`<br>`GL_INT`<br>`GL_UNSIGNED_INT`<br>`glVertexAttribPointer`的有效值**还包括**:<br>`GL_HALF_FLOAT`<br>`GL_FLOAT`<br>`GL_FIXED`<br>`GL_INT_2_10_10_10_REV`<br>`GL_UNSIGNED_INT_2_10_10_10_REV`|
|**normalized**|(仅`glVertexAttribPointer`)用于表示非浮点数据格式类型在转换为浮点时是否应该规范化. 对于`glVertexAttribPointer`这些值被当作整数对待|
|**stride**|每个顶点由size指定顶点的属性分量顺序存储. stride指定顶点索引$I$和($I+1$)表示的顶点数据之间的位移. 如果stride为0, 则每个顶点的属性数据顺序存储(只有一个顶点数据时). 如果stride大于0, 则使用该值作为获取下一个索引表示的顶点数据的跨距|
|**ptr**|如果使用客户端顶点数组, 则是保存顶点属性数据的缓冲区的指针. 如果使用顶点缓冲对象, 则表示该缓冲区内的偏移量|

举例:
* 结构数组(xyzxyzstst|xyzxyzstst|xyzxyzstst|...): 
```
#define VERTEX_POS_SIZE         3
#define VERTEX_NORMAL_SIZE      3
#define VERTEX_TEXCOORD0_SIZE   2
#define VERTEX_TEXCOORD1_SIZE   2

#define VERTEX_POS_INDX         0
#define VERTEX_NORMAL_INDX      1
#define VERTEX_TEXCOORD0_INDX   2
#define VERTEX_TEXCOORD1_INDX   3

#define VERTEX_POS_OFFSET       0
#define VERTEX_NORMAL_OFFSET    3
#define VERTEX_TEXCOORD0_OFFSET 6
#define VERTEX_TEXCOORD1_OFFSET 8

#define VERTEX_ATTRIB_SIZE     (VERTEX_POS_SIZE + \
                                VERTEX_NORMAL_SIZE + \
                                VERTEX_TEXCOORD0_SIZE + \
                                VERTEX_TEXCOORD1_SIZE)

float *p = (float *)malloc(numVertices * VERTEX_ATTRIB_SIZE * sizeof(float));
glVertexAttribPointer(VERTEX_POS_INDX, VERTEX_POS_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_ATTRIB_SIZE * sizeof(float), p);

glVertexAttribPointer(VERTEX_NORMAL_INDX, VERTEX_NORMAL_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_ATTRIB_SIZE * sizeof(float), (p + VERTEX_NORMAL_OFFSET));

glVertexAttribPointer(VERTEX_TEXCOORD0_INDX, VERTEX_TEXCOORD0_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_ATTRIB_SIZE * sizeof(float), (p + VERTEX_TEXCOORD0_OFFSET));

glVertexAttribPointer(VERTEX_TEXCOORD1_INDX, VERTEX_TEXCOORD1_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_ATTRIB_SIZE * sizeof(float), (p + VERTEX_TEXCOORD1_OFFSET));
```
* 数组结构(xyzxyzxyz...|xyzxyzxyz...|ststst...|ststst...|):
```
float postion = (float *)malloc(numVertices * VERTEX_POS_SIZE * sizeof(float));
float normal = (float *)malloc(numVertices * VERTEX_NORMAL_SIZE * sizeof(float));
float texcoord0 = (float *)malloc(numVertices * VERTEX_TEXCOORD0_SIZE * sizeof(float));
float texcoord0 = (float *)malloc(numVertices * VERTEX_TEXCOORD1_SIZE * sizeof(float));

glVertexAttribPointer(VERTEX_POS_INDX, VERTEX_POS_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_POS_SIZE * sizeof(float), positon);

glVertexAttribPointer(VERTEX_NORMAL_INDX, VERTEX_NORMAL_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_NORMAL_SIZE * sizeof(float), normal);

glVertexAttribPointer(VERTEX_TEXCOORD0_INDX, VERTEX_TEXCOORD0_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_TEXCOORD0_SIZE * sizeof(float), texcoord0;

glVertexAttribPointer(VERTEX_TEXCOORD1_INDX, VERTEX_TEXCOORD1_SIZE, GL_FLOAT, GL_FALSE
        VERTEX_TEXCOORD1_SIZE * sizeof(float), texcoord1;
```