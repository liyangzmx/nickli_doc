# json-rpc-cpp


```

$ mkdir build/
$ cd build/
$ cmake ..
-- The C compiler identification is GNU 9.3.0
-- The CXX compiler identification is GNU 9.3.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
CMake Deprecation Warning at CMakeLists.txt:21 (cmake_policy):
  The OLD behavior for policy CMP0042 will be removed from a future version
  of CMake.

  The cmake-policies(7) manual explains that the OLD behaviors of all
  policies are deprecated and that a policy should be set to OLD only under
  specific short-term circumstances.  Projects should be ported to the NEW
  behavior and not rely on setting a policy to OLD.


-- UNIX_DOMAIN_SOCKET_SERVER: NO
-- UNIX_DOMAIN_SOCKET_CLIENT: NO
-- TCP_SOCKET_SERVER: NO
-- TCP_SOCKET_CLIENT: NO
-- HTTP_SERVER: YES
-- HTTP_CLIENT: YES
-- REDIS_SERVER: YES
-- REDIS_CLIENT: YES
-- UNIXDOMAINSOCKET_SERVER: NO
-- UNIXDOMAINSOCKET_CLIENT: NO
-- COMPILE_TESTS: YES
-- COMPILE_STUBGEN: YES
-- COMPILE_EXAMPLES: YES
-- Found jsoncpp: /usr/include  
-- Jsoncpp header: /usr/include
-- Jsoncpp lib   : /usr/lib/x86_64-linux-gnu/libjsoncpp.so
-- Could NOT find argtable (missing: ARGTABLE_INCLUDE_DIR ARGTABLE_LIBRARY) 
-- Argtable header: ARGTABLE_INCLUDE_DIR-NOTFOUND
-- Argtable lib   : ARGTABLE_LIBRARY-NOTFOUND
-- Found CURL: /usr/lib/x86_64-linux-gnu/libcurl.so (found version "7.68.0")  
-- Looking for include file pthread.h
-- Looking for include file pthread.h - found
-- Looking for pthread_create
-- Looking for pthread_create - not found
-- Looking for pthread_create in pthreads
-- Looking for pthread_create in pthreads - not found
-- Looking for pthread_create in pthread
-- Looking for pthread_create in pthread - found
-- Found Threads: TRUE  
-- CURL header: /usr/include/x86_64-linux-gnu
-- CURL lib   : /usr/lib/x86_64-linux-gnu/libcurl.so
-- Found mhd: /usr/include  
-- MHD header: /usr/include
-- MHD lib   : /usr/lib/x86_64-linux-gnu/libmicrohttpd.so
-- Could NOT find hiredis (missing: HIREDIS_INCLUDE_DIR HIREDIS_LIBRARY) 
-- Hiredis header: HIREDIS_INCLUDE_DIR-NOTFOUND
-- Hiredis lib   : HIREDIS_LIBRARY-NOTFOUND
-- Found Doxygen: /usr/bin/doxygen (found version "1.8.17") found components: doxygen dot 
-- Could NOT find catch (missing: CATCH_INCLUDE_DIR) 
-- Could not find catch, downloading it now
-- Catch directory: /media/nickli/webrtc/libjson-rpc-cpp/build/catch/src/catch/single_include 
-- Found doxygen: /usr/bin/doxygen
CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
Please set them or make sure they are set and tested correctly in the CMake files:
ARGTABLE_INCLUDE_DIR (ADVANCED)
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
ARGTABLE_LIBRARY (ADVANCED)
    linked by target "libjsonrpcstub" in directory /media/nickli/webrtc/libjson-rpc-cpp/src/stubgenerator
HIREDIS_INCLUDE_DIR (ADVANCED)
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
   used as include directory in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
HIREDIS_LIBRARY (ADVANCED)
    linked by target "jsonrpcserver" in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp
    linked by target "jsonrpcclient" in directory /media/nickli/webrtc/libjson-rpc-cpp/src/jsonrpccpp

-- Configuring incomplete, errors occurred!
See also "/media/nickli/webrtc/libjson-rpc-cpp/build/CMakeFiles/CMakeOutput.log".
See also "/media/nickli/webrtc/libjson-rpc-cpp/build/CMakeFiles/CMakeError.log".
```

对于`argtable`的报错:
```
$ sudo apt-get install libargtable2-dev
```

对于`hiredis`的报错:
```
$ sudo apt-get install libhiredis-dev
```