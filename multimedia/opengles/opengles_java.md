# OpenGL ES

## Khronos资料
**OpenGL ES不同于EGL**, 
**EGL**用于分配和管理 OpenGL ES **上下文**和 **Surface**

所有的OpenGL ES标准可以从此处下载:
[Khronos OpenGL ES Registry](https://www.khronos.org/registry/OpenGL/index_es.php)

本仓库也下载了一个3.0+的副本:
|Spec|Path|
|:-|:-|
|OpenGL ES 3.2 Specifications|[es_spec_3.2.pdf](es_spec_3.2.pdf)|
|OpenGL ES Shading Language 3.20 Specification|[GLSL_ES_Specification_3.20.pdf](GLSL_ES_Specification_3.20.pdf)|
|OpenGL ES Quick Reference Card|[opengles32-quick-reference-card.pdf](opengles32-quick-reference-card.pdf)|
|OpenGL ES 3.1 Specification|[es_spec_3.1.pdf](es_spec_3.1.pdf)|
|OpenGL ES Shading Language 3.10 Specification|[GLSL_ES_Specification_3.10.pdf](GLSL_ES_Specification_3.10.pdf)|
|OpenGL ES 3.0.6 Specification|[es_spec_3.0.pdf](es_spec_3.0.pdf)|
|OpenGL ES Shading Language 3.00 Specification|[GLSL_ES_Specification_3.00.pdf](GLSL_ES_Specification_3.00.pdf)|

## Android OpenGL ES(Java)
你需要特别注意Android下的OpenGL ES的API版本问题:  
[图片和图形 - OpenGL ES](https://developer.android.com/training/graphics/opengl)  

你也可以从如下文档中获得一些**Java**层的API指导:  
[使用 OpenGL ES 显示图形](https://developer.android.com/training/graphics/opengl)


## 关于glCreateProgram()的log获取
```
..
{
    ...
    init {
        mProgram = GLES30.glCreateProgram().also { program ->
            GLES30.glAttachShader(program, vertextShader)
            GLES30.glAttachShader(program, fragmentShader)
            GLES30.glLinkProgram(program)

            // 这里是因为glGetProgramiv() 只接收IntBuffer, 因此这样写
            var linkStatus: IntBuffer = IntBuffer.allocate(1)
            GLES30.glGetProgramiv(program, GLES30.GL_LINK_STATUS, linkStatus)
            if(linkStatus.get() != GLES30.GL_TRUE) {
                // 这里其实可以直接通过: GLES30.glGetProgramInfoLog(program) 获取编译Log
                var bufLength: IntBuffer = IntBuffer.allocate(1) 
                GLES30.glGetProgramiv(program, GLES30.GL_INFO_LOG_LENGTH, bufLength)
                if(bufLength.get() > 0) {
                    // 注意: GLES30.glGetProgramInfoLog()直接返回String, 不需要进行内存的分配.
                    Log.d("JMS", "Build Error: " + GLES30.glGetProgramInfoLog(program))
                }
            }
        }
    }
    ...
}
```

## 关于glCreateShader的log获取
```
{
    fun loadShader(type: Int, shaderCode: String): Int {
        GLES30.glCreateShader(type).also {
            GLES30.glShaderSource(it, shaderCode)
            GLES30.glCompileShader(it)
            var compileStatus: IntBuffer = IntBuffer.allocate(1)
            GLES30.glGetShaderiv(it, GLES30.GL_COMPILE_STATUS, compileStatus)
            if(compileStatus.get() != GLES30.GL_TRUE) {
                Log.d("JMS", "Build Error: " + GLES30.glGetShaderInfoLog(it))
            }
        }
        ...
    }
    ...
}
```
基本流程同上文.

## 从Bitmap加载纹理
### 纹理的加载
```
    fun loadTexture(context: Context): Int {
        var textureIds = IntArray(1)
        GLES30.glGenTextures(1, textureIds, 0)
        if(textureIds[0] == 0) {
            Log.e("JMS", "Could not generate a new OpenGL textureId object.")
            return 0
        }
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, textureIds[0])
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MIN_FILTER, GLES30.GL_LINEAR_MIPMAP_LINEAR)
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MAX_LEVEL, GLES30.GL_LINEAR)

        GLUtils.texImage2D(GLES30.GL_TEXTURE_2D, 0, mBitmap, 0)
        GLES30.glGenerateMipmap(GLES30.GL_TEXTURE_2D)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, GLES30.GL_NONE)

        return textureIds[0]
```
#### 顶点着色器代码
```
#version 300 es
layout(location = 0) in vec4 vPosition;
// 注意下, 这里接受的是vec2, 如果需要乘以矩阵做缩放, 那么需要用vec4
layout (location = 1) in vec2 aTextureCoord;
out vec2 vTexCoord;
void main() {
    gl_Position = vPosition;
    vTexCoord = aTextureCoord;
}
```
#### 片段着色器代码
```
#version 300 es
precision mediump float;
uniform sampler2D uTextureUnit;
in vec2 vTexCoord;
out vec4 fragColor;
void main() {
    fragColor = texture(uTextureUnit, vTexCoord);
}
```
#### 纹理坐标aTextureCoord的传递
```
{
    ...
    fun draw() {
        ... ...
        // 通过layout传递纹理坐标
        GLES30.glEnableVertexAttribArray(1)
        GLES30.glVertexAttribPointer(
            // layout为1的属性
            1,
            // 纹理坐标数据对应的分量为2, 但是最后传递进去的是vec4
            // 但是如果in是vec2, 那么接受的就是vec2
            2,
            GLES30.GL_FLOAT,
            false,
            // 两个GLES30.GL_FLOAT
            2 * 4,
            // 纹理坐标的buffer
            texBuffer
        )
        ...
    }
    ...
}
```

### 从网络获取Bitmap
```

```