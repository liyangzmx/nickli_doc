# 开始

## 需要什么?
做很多事情都需要**适合**的工具, 而不是必须的工具, 本文中推荐的很多工具可能是陈旧的/保守的/甚至是不太容易使用的, 但通常这些工具出现问题时, 它们的解决方案都是比较容易的.

## 选择一个合适的系统
安装一个**合适**的**开发用**系统是很有必要的, 因为这可以给后面的很多操作减少很多麻烦. Ubuntu是个不错的系统, 对于后面你与这个系统打交道的任何时刻都建议:  
**除非你明确知道自己要干什么, 否则不要修改该系统的任何自带的配置文件**

### Ubuntu
#### 下载  
推荐你安装**Ubuntu**, 它的桌面版官网:[Ubuntu for desktops](https://ubuntu.com/desktop), 通常你应该在这里下载你需要的镜像文件, 例如通过"**Download Ubuntu**"页面下载最新的版本, 例如:[ubuntu-20.04-desktop-amd64.iso](https://mirror.lzu.edu.cn/ubuntu-releases/20.04/ubuntu-20.04-desktop-amd64.iso), 但对于国内的的网络环境, 通常会遇到网络缓慢的问题, 因此, 你也可以通过如下途径下载, 例如大学的镜像:  
* [TUNA - Index of /ubuntu-releases/](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/)

#### 版本的选择
通常推荐您选择较为新的**Ubuntu Desktop**版本(这里强调的不是~~最新版本的开发工具~~)

#### 系统安装盘的制作(Windows)
不推荐使用UltraISO, 最然该软件十分强大, 但它不是自由软件, 取而代之的推荐:  
* [Universal USB Installer – Easy as 1 2 3](https://www.pendrivelinux.com/universal-usb-installer-easy-as-1-2-3/)  
<!-- * [balena - Etcher](https://www.balena.io/etcher/) -->

#### 系统安装盘的引导
很不幸, 无法猜测您使用的计算机, 仅提供一个可能有用的信息: UEFI的存在很可能导致安装后的Ubuntu**无法正常启动**, 所以您可能需要查找一些资料确认这个问题, 对于类似Lenovo这种类似的品牌机, 你可能无法搞定分区相关的问题, 无论如何, 都可以通过其它方式:
* 购买一个廉价的**SATA**或者一个贵一点的**NVMe**(如果你实在不知道应不应该买NVMe接口的,问下你身边的装机达人)接口的硬盘, 并尝试在自己的计算机中安装Ubuntu
* 下载一个虚拟机软件(例如: [Oracle VM VirtualBox](https://www.virtualbox.org/), 如何安装VirtalBox到Windows参考[Oracle® VM VirtualBox® User Manual - 2.1. Installing on Windows Hosts](https://www.virtualbox.org/manual/ch02.html#installation_windows), 而如何在Windows上安装Ubuntu的系统, 参考VirutalBox手册中的第3章学会如何配置一个虚拟机, 然后按照下文的系统安装步骤开始(如果你没看懂, 那一定是Oracle的手册写得太烂了, 不要灰心. ), 对于这件事一个更精简的参考: [Install Ubuntu on Oracle VirtualBox](https://brb.nci.nih.gov/seqtools/installUbuntu.html))
无论何种方式, 尝试一次安装的全过程总是有很多好处的.  

**注意:**   
1. 对于购买硬盘安装Ubuntu这件事, 资料远比一块普通的机械硬盘或固态硬盘重要得多, 所以, 购买硬盘或使用虚拟机都是保护资料的最好方式. 
2. 对于虚拟机, 可能会带来不少的性能问题以及数据交换上的麻烦, 虽然有写资料(例如如何在Ubuntu的虚拟机上共享Windows主机中的文件: )

#### 系统的安装
强烈建议按照官方文档([Install Ubuntu desktop](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview))来操作, 文档中的内容已经很详细了, 请按照步骤一步一步进行.