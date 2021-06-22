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
|**EGL_BIND_TO_TEXTURE_RGB**|如果可以绑定到RGB纹理, 则为真|EGL_DONT_CARE|
|**EGL_BIND_TO_TEXTURE_ARGB**|如果可以绑定到ARGB纹理, 则为真|EGL_DONT_CARE|
|**EGL_COLOR_BUFFER_TYPE**|颜色缓冲区类型:EGL_RGB_BUFFER或EGL_LUMINANCE_BUFFER|EGL_RGB_BUFFER
|**EGL_CONFIG_CAVEAT**|和配置相关的任何注意事项|EGL_DONT_CARE|
|**EGL_CONFIG_ID**|唯一的EGLConfig标识值|EGL_DONT_CARE|
|**EGL_CONFORMANT**|如果用这个EGLConfig创建的上下文兼容, 则为真|-
|**EGL_DEPTH_SIZE**|深度缓冲区位数|0|
|**EGL_LEVEL**|帧缓冲级别|0|
|**EGL_MAX_PBUFFER_WIDTH**|用这个EGLConfig创建的PBuffer的最大宽度|-
|**EGL_MAX_PBUFFER_HEIGHT**|用这个EGLConfig创建的PBuffer的最大高度|-
|**EGL_MAX_PBUFFER_PIXELS**|用这个EGLConfig创建的PBuffer的最大尺寸|-
|**EGL_MAX_SWAP_INTERNAL**|最大缓冲区交换间隔|EGL_DONT_CARE
|**EGL_MIN_SWAP_INTERNAL**|最小缓冲区交换间隔|EGL_DONT_CARE
|**EGL_NATIVE_RENDERABLE**|如果原生渲染库可以渲染到用EGLConfig创建的表面则为真
|**EGL_NATIVE_VISUAL_ID**|关于应原生窗口系统可视ID句柄|EGL_DONT_CARE
|**EGL_NATIVE_VISUAL_TYPE**|关于应原生窗口系统可视类型|EGL_DONT_CARE
|**EGL_RENDERABLE_TYPE**|由EGL_OPENGL_ESBIT, EGL_OPENGL_ES2_BIG, EGL_OPENGL_ES3_BIT_KHR(需要EGL_KHR_create_context扩展), EGL_OPENGL_BIT或EGL_OPENVG_BIT组成的掩码, 代表配置支持的渲染接口|EGL_OPENGL_ES_BIT|
|**EGL_SAMPLE_BUFFERS**|可用多重采样缓冲区数量|0|
|**EGL_SAMPLES**|每个像素的样本数量|0|
|**EGL_STENCIL_SIZE**|模板缓冲区位数|0|
|**EGL_SURFACE_TYPE**|支持的EGL表面类型, 可能是EGL_WINDOW_BIT, EGL_PIXMAP_BIT, EGL_PBUFFER_BIT, EGL_MULTISAMPLE_RESOVE_BOX_BIT, EGL_SWAP_BEHAVIOR_PRESERVED_BIT, EGL_VG_COLORSPACE_LINEAR_BIT或者EGL_VG_ALPHA_FORMAT_PRE_BIT|EGL_WINDOW_BIT|
|**EGL_TRANSPARENT_TYPE**|支持的透明度|EGL_NONE|
|**EGL_TRANSPARENT_RED_VALUE**|解读为透明的红色值|EGL_DONT_CARE|
|**EGL_TRANSPARENT_GREEN_VALUE**|解读为透明的绿色值|EGL_DONT_CARE|
|**EGL_TRANSPARENT_BLUE_VALUE**|解读为透明的蓝色值|EGL_DONT_CARE|

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
|**EGL_LARGEST_PBUFFER**|如果请求的大小不可用, 选择最大的可用pbuffer. 有效值为: EGL_TRUE和EGL_FALSE|EGL_FALSE|
|**EGL_TEXTURE_FORMAT**|如果pbuffer绑定到一个纹理贴图, 则制定纹理格式类型, 有效值是: EGL_TEXTURE_RGB, EGL_TEXTURE_RGBA, 和EGL_NO_TEXTURE(表示pbuffer不能直接用于纹理)|EGL_NO_TEXTURE|
|**EGL_TEXTURE_TARGET**|制定pbuffer作为纹理贴图时应该廉洁到的相关纹理目标, 有效值为EGL_TEXTURE_2D和EGL_NO_TEXTURE|EGL_NO_TEXTURE|
|**EGL_MIPMAP_TEXTURE**|指定是否应该另外为纹理mipmap级别, 分配存储. 有效值是: EGL_TRUE和EGL_FALS|EGL_FALSE|

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
|**attribList**|指定创建上下文使用的属性列表; 只有一个可接受的属性: EGL_CONTEXT_CLIENT_VERSION|

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

