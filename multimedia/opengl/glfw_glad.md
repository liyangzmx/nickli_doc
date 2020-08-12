# GLFW & GLAD 开始

## 学习资料
[Welcome to OpenGL](https://learnopengl.com/)

## 可能遇到的问题
* glfw的安装
```
sudo apt install libglfw3-dev
```

* glad.h的缺失
登录网站: [Glad](https://glad.dav1d.de/), 选择相应的配置后, 点击"GENERATE", 然后下载网站生成的glad.zip, 解压到项目目录即可.

## 测试用例
### 目录结构
```
tree
---- < OUTPUT > ----
.
├── CMakeLists.txt
├── gl_Position.vs
├── include
│   ├── glad
│   │   └── glad.h
│   └── KHR
│       └── khrplatform.h
├── main.cpp
└── src
    └── glad.c
```

### CMakeLists.txt
在VSCodec中使用CMake插件建立一个简单的项目, 参考:[CMake - VSCode+CMake构建基本的cpp应用](tools/plantuml/cmake/cmake_vscode.md), 调整CMakeLists.txt, 并解压glad.zip到项目中, 然后配置CMakeLists.txt如下:
```
cmake_minimum_required(VERSION 3.0.0)
project(<YOUR_PROJECT_NAME> VERSION 0.1.0)

find_package(PkgConfig REQUIRED)

pkg_check_modules(GLFW3 REQUIRED
    IMPORTED_TARGET
    glfw3
)

add_executable(<YOUR_PROJECT_NAME> main.cpp src/glad.c)

target_include_directories(<YOUR_PROJECT_NAME> PRIVATE include/)
target_link_directories(<YOUR_PROJECT_NAME> PRIVATE "/usr/lib/x86_64-linux-gnu/")
target_link_libraries(
    <YOUR_PROJECT_NAME>
    
    PkgConfig::GLFW3

    dl
    m
)

```


## main.cpp
```
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    glViewport(0, 0, width, height);
}
void processInput(GLFWwindow *window)
{
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}
 
int main(int argc, char** argv)
{
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);

    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }
    glViewport(0, 0, 800, 600);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);  

    while(!glfwWindowShouldClose(window))
    {
        processInput(window);

        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        glfwSwapBuffers(window);
        glfwPollEvents();    
    }
    glfwTerminate();

    return 0;
}
```