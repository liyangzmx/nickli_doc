# libsdptransfrom的Android编译(C++)

## 参考资料
* [Github - ibc/libsdptransform](https://github.com/ibc/libsdptransform)  
* [Github - clux/sdp-transform](https://github.com/clux/sdp-transform/)

## 代码下载
```
$ git clone --depth=1 https://github.com/ibc/libsdptransform.git
cd libsdptransform
```

## 编译
```
$ export ABI=arm64-v8a
$ export API_LEVEL=24
$ cmake -DCMAKE_TOOLCHAIN_FILE=~/Android/Sdk/ndk/21.3.6528147/build/cmake/android.toolchain.cmake -DANDROID_ABI=${ABI} -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} ..
$ make -j16
Scanning dependencies of target sdptransform
[ 11%] Building CXX object CMakeFiles/sdptransform.dir/src/parser.cpp.o
[ 22%] Building CXX object CMakeFiles/sdptransform.dir/src/grammar.cpp.o
[ 33%] Building CXX object CMakeFiles/sdptransform.dir/src/writer.cpp.o
[ 44%] Linking CXX static library libsdptransform.a
[ 44%] Built target sdptransform
Scanning dependencies of target sdptransform_readme_helper
Scanning dependencies of target test_sdptransform
[ 55%] Building CXX object readme-helper/CMakeFiles/sdptransform_readme_helper.dir/readme.cpp.o
[ 66%] Building CXX object test/CMakeFiles/test_sdptransform.dir/tests.cpp.o
[ 77%] Building CXX object test/CMakeFiles/test_sdptransform.dir/parse.test.cpp.o
[ 88%] Linking CXX executable sdptransform_readme_helper
[ 88%] Built target sdptransform_readme_helper
[100%] Linking CXX executable test_sdptransform
CMakeFiles/test_sdptransform.dir/tests.cpp.o: In function `Catch::writeToDebugConsole(std::__ndk1::basic_string<char, std::__ndk1::char_traits<char>, std::__ndk1::allocator<char> > const&)':
/home/nickli/work/webrtc/libsdptransform/test/include/catch.hpp:10249: undefined reference to `__android_log_write'
clang++: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [test/CMakeFiles/test_sdptransform.dir/build.make:100：test/test_sdptransform] 错误 1
make[1]: *** [CMakeFiles/Makefile2:144：test/CMakeFiles/test_sdptransform.dir/all] 错误 2
make: *** [Makefile:130：all] 错误 2
```

## 报错解决
```
$ cd ..
$ git diff
diff --git a/CMakeLists.txt b/CMakeLists.txt
index bd36212..b427b7b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -28,5 +28,7 @@ set(
 
 add_library(sdptransform STATIC ${SOURCE_FILES} ${HEADER_FILES})
 
+target_link_libraries(sdptransform log)
+
 install(TARGETS sdptransform DESTINATION lib)
 install(FILES ${HEADER_FILES} DESTINATION include/sdptransform)

$ cd out/
$ rm -r *
$ cmake -DCMAKE_TOOLCHAIN_FILE=~/Android/Sdk/ndk/21.3.6528147/build/cmake/android.toolchain.cmake -DANDROID_ABI=${ABI} -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} ..
$ make -j16
Scanning dependencies of target sdptransform
[ 11%] Building CXX object CMakeFiles/sdptransform.dir/src/grammar.cpp.o
[ 22%] Building CXX object CMakeFiles/sdptransform.dir/src/parser.cpp.o
[ 33%] Building CXX object CMakeFiles/sdptransform.dir/src/writer.cpp.o
[ 44%] Linking CXX static library libsdptransform.a
[ 44%] Built target sdptransform
Scanning dependencies of target sdptransform_readme_helper
Scanning dependencies of target test_sdptransform
[ 55%] Building CXX object readme-helper/CMakeFiles/sdptransform_readme_helper.dir/readme.cpp.o
[ 66%] Building CXX object test/CMakeFiles/test_sdptransform.dir/parse.test.cpp.o
[ 77%] Building CXX object test/CMakeFiles/test_sdptransform.dir/tests.cpp.o
[ 88%] Linking CXX executable sdptransform_readme_helper
[ 88%] Built target sdptransform_readme_helper
[100%] Linking CXX executable test_sdptransform
[100%] Built target test_sdptransform
```