# CMake 与 pkg-config

如果使用的是Linux的系统, 并包含`pkg-config`命令, 可以考虑采用如下方式查找需要的库, 以`ffmpeg`和`SDL`为例.

假设需要的库是`libavcodec`, 通常使用`pkg-config`的命令为:
```
pkg-config --libs --cflags libavdevice libavfilter libavformat libavcodec libswresample libswscale libavutil sdl SDL_image
----- <Output> -----
-D_GNU_SOURCE=1 -D_REENTRANT -I/usr/include/x86_64-linux-gnu -I/usr/include/SDL -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lSDL_image -lSDL
```

如果使用`CMakeLists.txt`那么可以写为:
```
find_package(PkgConfig REQUIRED)

pkg_check_modules(LIBAV REQUIRED IMPORTED_TARGET
    libavdevice
    libavfilter
    libavformat
    libavcodec
    libswresample
    libswscale
    libavutil
)

pkg_check_modules(LIBSDL REQUIRED IMPORTED_TARGET
    sdl2
    SDL_image
)

add_executable(test main.cpp)

target_link_libraries(
    test
    PkgConfig::LIBAV
    PkgConfig::LIBSDL
)
```

# 关于undefined的问题
如果出现类似的情况:
```
[build] /usr/bin/ld: CMakeFiles/ffmpeg_sdl_learn.dir/main.cpp.o: in function `main':
[build] /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:18: undefined reference to `av_register_all()'
[build] /usr/bin/ld: /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:19: undefined reference to `avformat_network_init()'
[build] /usr/bin/ld: /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:20: undefined reference to `avformat_alloc_context()'
[build] /usr/bin/ld: /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:21: undefined reference to `avformat_open_input(AVFormatContext**, char const*, AVInputFormat*, AVDictionary**)'
[build] /usr/bin/ld: /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:25: undefined reference to `avformat_find_stream_info(AVFormatContext*, AVDictionary**)'
[build] /usr/bin/ld: /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:41: undefined reference to `avcodec_find_decoder(AVCodecID)'
[build] /usr/bin/ld: /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:46: undefined reference to `avcodec_open2(AVCodecContext*, AVCodec const*, AVDictionary**)'
[build] /usr/bin/ld: /home/liyang/doc/learn/ffmpeg_sdl/build/../main.cpp:51: undefined reference to `av_frame_alloc()'
```
可能需要注意下, 是否使用的是C++开发环境, 例如文件名是`main.cpp`, 其中的c的头文件应该类似:
```
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libavutil/imgutils.h>
    #include <SDL/SDL.h>
    #include <SDL/SDL_video.h>
    #include <libswscale/swscale.h>
}
```

然后重新编译.