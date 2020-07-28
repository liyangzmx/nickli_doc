# MULTICAST

# 参考资料
* [setsocket/getsocket 函数详解](https://www.cnblogs.com/schips/p/12552308.html)
* [Multicast over TCP/IP HOWTO - 6. Multicast programming.](https://www.tldp.org/HOWTO/Multicast-HOWTO-6.html)
* [socket 地址复用 SO_REUSEADDR](https://www.cnblogs.com/schips/p/12553198.html)
* [Linux网络编程——端口复用（多个套接字绑定同一个端口）](https://blog.csdn.net/tennysonsky/article/details/44062173)

# 组播
组播只支持UDP协议。

# 组播地址的选择
组播的地址是特定的 - D类IP地址（224.0.0.0到239.255.255.255）不识别互联网内的单个接口，但识别接口组，被称为多播组，即224.0.0.0  ~ 239.255.255.255之间的IP地址：

局部组播地址：在224.0.0.0～224.0.0.255之间，这是为路由协议和其他用途保留的地址，路由器并不转发属于此范围的IP包。

预留组播地址：在224.0.1.0～238.255.255.255之间，可用于全球范围（如Internet）或网络协议。

管理权限组播地址：在239.0.0.0～239.255.255.255之间，可供组织内部使用，类似于私有IP地址，不能用于Internet，可限制多播范围。

属于永久组的地址：

224.0.0.1   所有组播主机  all-hosts group.

224.0.0.2   所有组播路由器  all-routers group. 


# setsockopt()和getsockopt()
```
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>

int getsockopt(int sockfd, int level, int optname,
               void *optval, socklen_t *optlen);
               
int setsockopt(int sockfd, int level, int optname,
               const void *optval, socklen_t optlen);
```
setsockopt()用于设置socket选项。

getsockopt() 用于得到socket选项。

常用选项：

IP_ADD_MENBERSHIP: 加入一个多播组。使用IP_ADD_MENBERSHIP每次只能加入一个网络接口的IP地址到多播组，可多次调用加入多个主机IP。group是一个包含可用多播组地址的结构体。
```
  struct ip_mreqn group;
  setsockopt(sockfd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &group, sizeof(group));
```

ip_mreq结构体：
```
struct ip_mreq
{
    struct in_addr imr_multiaddr;   /* IP multicast address of group */
    struct in_addr imr_interface;   /* local IP address of interface */
};
```
imr_multiaddr是代表多播组的地址，imr_interface代表端口地址，不同用户可以通过不同端口加入同一个组。如果用户把imr_interface设置为INADDR_ANY，系统会为其分配一个端口。

用户也可以把同一个套接字加入到不同的组里面，上限根据IP_MAX_MEMBERSHIPS而定，2.0.33版本中，这个上限为20。

 

多个不同的进程是可以加入一个多播组的同一个端口的，这些进程会同时收到发到这个端口的数据包。

IP_MULTICAST_TTL: 设置多播组的TTL阈值。路由器必须确保只有在信息包的TTL值大于或者等于接口的TTL阀值时，才允许将该信息在此接口上转发出去。

TTL定义了数据包的生存时间，每经过一次路由器转发，这个数据包的TTL值就会减一，当它的TTL值为0的时候，这个包就被丢掉。在多播中，每个接口都会都会定义一个TTL阈值（在多播中这个值可以不为0），当来的数据包的值大于阈值的时候，这个包才会被接收。

如果IP_MULTICAST_TTL没有被设置，在多播的情况下默认为1。可选的值为0到255。

```
u_char ttl;
setsockopt(socket, IPPROTO_IP, IP_MULTICAST_TTL, &ttl, sizeof(ttl));
```
IP_DROP_MEMBERSHIP: 退出组播组。
```
struct ip_mreq dropreq;
setsockopt(socket,IPPROTO_IP,IP_DROP_MEMBERSHIP,&dropreq,sizeof(dropreq));
```
如果imr_interface成员被设置为INADDR_ANY，系统会自动退出第一个找到的组。

IP_MULTICAST_LOOP: 禁止组播数据回传。bLoop 为0的时候禁止回传，为1允许回传。回传是默认被开启的。

```
unsigned char bLoop = 0;
setsockopt(sockfd, IPPROTO_IP, IP_MULTICAST_LOOP, (char *)&bLoop,sizeof(unsigned char));
```
如果你想知道当前程序是否回传，可使用：
```
u_char loop;
int size;
getsockopt(socket, IPPROTO_IP, IP_MULTICAST_LOOP, &loop, &size)
```

IP_MULTICAST_IF: 获取默认接口或设置接口。


# 服务端
```
/*
#    Copyright By Schips, All Rights Reserved
#    https://gitee.com/schips/
#
#    File Name:  group_server.c
#    Created  :  Mon 23 Mar 2020 04:02:12 PM CST
*/

#include <stdio.h>
#include <string.h>
#include <unistd.h>
//#include <linux/in.h>
#include <arpa/inet.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>

#define IP_FOUND  "IP_FOUND"
#define IP_FOUND_ACK  "IP_FOUND_ACK"
#define MCAST "224.0.0.88"

//说明:设置主机的TTL值，是否允许本地回环，加入多播组，然后服务器向加入多播组的主机发送数据，主机接收数据，并响应服务器。

int main(int argc,char **argv)
{
        int sock_fd,client_fd;
        int ret;
        struct sockaddr_in localaddr;
        struct sockaddr_in recvaddr;
        socklen_t  socklen;
        char recv_buf[20];
        char send_buf[20];
        int ttl = 10;//如果转发的次数等于10,则不再转发
        int loop=0;

        /* 创建 socket 用于UDP通讯 */
        sock_fd = socket(AF_INET, SOCK_DGRAM , 0);
        if(sock_fd == -1)
        {
                perror(" socket !");
        }

        // 本机地址并监听
        memset(&localaddr,0,sizeof(localaddr));
        localaddr.sin_family = AF_INET;
        localaddr.sin_port = htons(6666);
        localaddr.sin_addr.s_addr = htonl(INADDR_ANY);

        ret = bind(sock_fd, (struct sockaddr *)&localaddr,sizeof(localaddr));
        if(ret == -1)
        {
                perror("bind !");
        }

        socklen = sizeof(struct sockaddr);

        //设置多播的TTL值
        if(setsockopt(sock_fd, IPPROTO_IP, IP_MULTICAST_TTL, &ttl, sizeof(ttl))<0){
                perror("IP_MULTICAST_TTL");
                return -1;
        }
        //设置数据是否发送到本地回环接口
        if(setsockopt(sock_fd, IPPROTO_IP, IP_MULTICAST_LOOP, &loop, sizeof(loop))<0){
                perror("IP_MULTICAST_LOOP");
                return -1;
        }
        //加入多播组
        struct ip_mreq mreq;
        mreq.imr_multiaddr.s_addr=inet_addr(MCAST);//多播组的IP
        mreq.imr_interface.s_addr=htonl(INADDR_ANY);//本机的默认接口IP,本机的随机IP
        if(setsockopt(sock_fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq)) < 0){
                perror("IP_ADD_MEMBERSHIP");
                return -1;
        }

        while(1)
        {
                ret = recvfrom(sock_fd, recv_buf, sizeof(recv_buf), 0,(struct sockaddr *)&recvaddr, &socklen);
                if(ret < 0 )
                {
                        perror(" recv! ");
                }

                printf(" recvaddr --- recv client addr : %s \n", (char *)inet_ntoa(recvaddr.sin_addr));
                printf(" recvaddr --- recv client port : %d \n",ntohs(recvaddr.sin_port));
                printf(" recvaddr --- recv msg :%s \n", recv_buf);

               // if(strstr(recv_buf,IP_FOUND))
               // {
                        //响应客户端请求
                        //strncpy(send_buf, IP_FOUND_ACK, strlen(IP_FOUND_ACK) + 1);
                        ret = sendto(sock_fd, "message from server", strlen("message from server") + 1, 0, (struct sockaddr*)&recvaddr, socklen);//将数据发送给客户端
                        if(ret < 0 )
                        {
                                perror("server send to client! ");
                        }
                        printf(" send ack  msg to client !\n");
               // }
        }

        // 离开多播组
        ret = setsockopt(sock_fd, IPPROTO_IP, IP_DROP_MEMBERSHIP, &mreq, sizeof(mreq));
        if(ret < 0){
                perror("IP_DROP_MEMBERSHIP");
                return -1;
        }

        close(sock_fd);

        return 0;
}
```

# 客户端
```
/*
#    Copyright By Schips, All Rights Reserved
#    https://gitee.com/schips/
#
#    File Name:  group_client.c
#    Created  :  Mon 23 Mar 2020 04:00:49 PM CST
*/

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>


#define IP_FOUND "IP_FOUND"
#define IP_FOUND_ACK "IP_FOUND_ACK"


/*
广播与多播只支持UDP协议，因为TCP协议是端到端，这与广播与多播的理念相冲突
广播是局域网中一个主机对所有主机的数据通信，而多播是一个主机对一组特定的主机进行通信.多播可以是因特网，而广播只能是局域网。多播常用于视频电话，网上会议等。

setsockopt设置套接字选项可以设置多播的一些相关信息

IP_MULTICAST_TTL //设置多播的跳数值
IP_ADD_MEMBERSHIP //将主机的指定接口加入多播组，以后就从这个指定的接口发送与接收数据
IP_DROP_MEMBERSHIP //主机退出多播组
IP_MULTICAST_IF //获取默认的接口或设置多播接口
IP_MULTICAST_LOOP //设置或禁止多播数据回送，即多播的数据是否回送到本地回环接口

例子:
int ttl=255;
setsockopt(socket,IPPROTO_IP,IP_MULTICAST_TTL,&ttl,sizeof(ttl));//设置跳数

socket           -套接字描述符
PROTO_IP         -选项所在的协议层
IP_MULTICAST_TTL -选项名
&ttl             -设置的内存缓冲区
sizeof(ttl)      -设置的内存缓冲区长度

struct in_addr in;

setsockopt(socket,IPPROTO_IP,IP_MUTLICAST_IF,&in,sizeof(in));//设置组播接口

int yes=1;
setsockopt(socket,IPPROTO_IP,IP_MULTICAST_LOOP,&yes,sizeof(yes));//设置数据回送到本地回环接口

struct ip_mreq addreq;
setsockopt(socket,IPPROTO_IP,IP_ADD_MEMBERSHIP,&req,sizeof(req));//加入组播组

struct ip_mreq dropreq;
setsockopt(socket,IPPROTO_IP,IP_DROP_MEMBERSHIP,&dropreq,sizeof(dropreq));//离开组播组


*/


#define MCAST_ADDR "224.0.0.88"

int main(int argc ,char **argv)
{
        int ret,count;
        int sock_fd;
        char send_buf[20];
        char recv_buf[20];

        struct sockaddr_in server_addr; //多播地址
        struct sockaddr_in our_addr;
        struct sockaddr_in recvaddr;
        int so_broadcast=1;

        socklen_t  socklen;

        sock_fd =  socket(AF_INET, SOCK_DGRAM, 0);

        memset(&server_addr,0,sizeof(server_addr));
        server_addr.sin_family = AF_INET;
        //server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
        server_addr.sin_addr.s_addr=inet_addr(MCAST_ADDR);  //多播地址
        server_addr.sin_port = htons(6666);


        //客户端绑定通信端口，否则系统自动分配
        memset(&our_addr,0,sizeof(our_addr));
        our_addr.sin_family = AF_INET;
        our_addr.sin_port = htons(7777);
        our_addr.sin_addr.s_addr = htonl(INADDR_ANY); //MCAST_ADDR
        //自定义地址如果为有效地址
        //则协议栈将自定义地址与端口信息发送到接收方
        //否则协议栈将使用默认的回环地址与自动端口
        //our_addr.sin_addr.s_addr = inet_addr("127.0.0.10");

        ret = bind(sock_fd, (struct sockaddr *)&our_addr, sizeof(our_addr) );
        if(ret == -1)
        {
                perror("bind !");
        }

        socklen = sizeof(struct sockaddr);
        strncpy(send_buf,IP_FOUND,strlen(IP_FOUND)+1);

       // for(count=0;count<3;count++)
       while(1)
        {
                ret = sendto(sock_fd, "client", strlen("client")+1, 0,(struct sockaddr *)&server_addr, socklen);
                if(ret != strlen(send_buf)+1)
                {
                        perror(" send to !");
                }

                ret = recvfrom(sock_fd, recv_buf, sizeof(recv_buf), 0,(struct sockaddr *)&recvaddr, &socklen);
                if(ret < 0 )
                {
                        perror(" recv! ");
                }

                printf(" recv server addr : %s \n", (char *)inet_ntoa(recvaddr.sin_addr));
                printf(" recv server port : %d \n", ntohs(recvaddr.sin_port) );
                printf(" recv server msg :%s \n", recv_buf);
                sleep(1);

        }

        close(sock_fd);

        return 0;
}
```