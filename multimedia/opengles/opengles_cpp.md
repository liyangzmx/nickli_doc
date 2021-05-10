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

## Android OpenGL ES(NDK)

### NDK
OpenGL ES的NDK实例: 
* [android/ndk-samples](https://github.com/android/ndk-samples)中的**hello-gl2**和**teapots**
* [示例 - native-activity]


OpenGL ES的NDK说明: [OpenGL ES 1.0 - 3.2](https://developer.android.com/ndk/guides/stable_apis#opengl_es_10_)

### glm
如果你需要使用[glm](https://github.com/g-truc/glm), 那么你可以从使用如下命令获得它:
```
git clone --depth=1 -b 0.9.9.8 https://github.com/g-truc/glm
```
特别注意它的修正历史, 以及编译需求.