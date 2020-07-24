# CMake & VSCode

很长一段时间, 在Linux各个发行版本的系统中构建C/C++的程序都是一件很麻烦的事情, 虽然有很多好的构建方式, 其中经典的:
* [GNU make](https://www.gnu.org/software/make/manual/make.html)
* [Cmake](https://cmake.org/cmake/help/latest/)
* [Autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html)
  
还有一些适用于特定应用的:
* [The Ninja build system](https://ninja-build.org/manual.html)
* [Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
* [Soong 构建系统](https://source.android.com/setup/build)
* [Blue Print](https://opensource.google/docs/)
* [SCons](https://scons.org/doc/production/HTML/scons-man.html)

但这些构建系统无疑让使用者身心疲惫, 因为大多数人希望的是能在构建上花短的时间.  

不推荐很多IDE(**除非是Android/iOS的开发者**), 虽然他们可以节省很多时间, 但是它们一旦出问题, 会更难解决；  

那为何用VSCode, 它不是IDE么? 它是IDE, 但它与CLI(Command Line Interface)的方式相比, 保持了很好的**界限**, 它没有试图隐藏虽有的细节, 反而是试图暴露出现问题的时候, 尽可能给出更多的信息.

说会正题, 通常我们开发一个小程序经历的步骤:
1. 构建一个基本的工程
2. 在本地(主机)安装依赖的库
3. 构建并进行本地测试
4. 交叉编译所开发的程序, 并解决依赖关系上的问题
5. 在实际的设备上进行测试

那么我们该选择何种build环境呢? 就经验而言, C++的项目采用**CMake**和**Autotools**非擦汗那个多, 但就体验而言, CMake似乎更优秀, 也是我一直以来首选的构建环境, 而且它可以协助生成其它build环境的支持.  

在步骤1.中, 如何快速的构建一个CMake的工程呢? VSCode提供了非常好的体验:  
[Get started with CMake Tools on Linux](https://code.visualstudio.com/docs/cpp/cmake-linux)



周报:  
* [**WebRTC**] Camera 连接TURN Server报403的问题, 后续没有复现, 待复现
* [**WebRTC**] Camera 收到手机的Candidate信息后无法正常链接到手机, 连接超时错误
* [**App**] 尝试集成一些多媒体库到App当中, 为后续集成第三方C++库做准备
* [**Document**] 新增文档:
  * China R&D / Wyze Beijing Android Team / WebRTC
    * [AWS WebRTC SDK Web Demo](https://wyzelabs.atlassian.net/wiki/spaces/CRD/pages/637470153/AWS+WebRTC+SDK+Web+Demo)
    * [AWS WebRTC SDK Android Demo](https://wyzelabs.atlassian.net/wiki/spaces/CRD/pages/637535726/AWS+WebRTC+SDK+Android+Demo)
  * China R&D / Wyze Beijing Android Team / Android Native
    * [FFmpeg in Android](https://wyzelabs.atlassian.net/wiki/spaces/CRD/pages/645137005/FFmpeg+in+Android)
    * [X264 in Android](https://wyzelabs.atlassian.net/wiki/spaces/CRD/pages/644481652/X264+in+Android)
    * [OpenSSL in Android](https://wyzelabs.atlassian.net/wiki/spaces/CRD/pages/644481659/OpenSSL+in+Android)



[WebRTC] Camera 连接TURN Server报403的问题, 后续没有复现, 待复现
[WebRTC] Camera 收到手机的Candidate信息后无法正常链接到手机, 连接超时错误
[App] 尝试集成一些多媒体库到App当中, 为后续集成第三方C++库做准备
[Document] 新增文档:
  China R&D / Wyze Beijing Android Team / WebRTC
    AWS WebRTC SDK Web Demo
    AWS WebRTC SDK Android Demo
  China R&D / Wyze Beijing Android Team / Android Native
    FFmpeg in Android
    X264 in Android
    OpenSSL in Android