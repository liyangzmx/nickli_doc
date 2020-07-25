# OpenSSL in Linux

## 参考
* [OpenSSL](https://openssl.org/)
* [Manpages for 1.1.1](https://www.openssl.org/docs/man1.1.1/)
* [OpenSSL - HMAC](https://www.openssl.org/docs/man1.1.1/man3/HMAC.html)

## Demo(with CMake)
### CMakeLists.txt
```
cmake_minimum_required(VERSION 3.0.0)
project(ssl_c_test VERSION 0.1.0)

link_directories(/usr/lib/x86_64-linux-gnu/)

add_executable(ssl_c_test main.cpp)
target_link_libraries(
    ssl_c_test
    crypto
    ssl
)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
```

### main.cpp
```
#include <iostream>
#include <openssl/hmac.h>
#include <string.h>

using namespace std;

int HmacEncode( char *algo, 
                const char *key,
                unsigned int key_length, 
                const char *input, 
                unsigned int input_length, 
                unsigned char *&output,
                unsigned int &output_length) {
    const EVP_MD *engine = NULL;
    if(strcasecmp("sha256", algo) == 0) {
        engine = EVP_sha256();
    }else if(strcasecmp("sha1", algo) == 0) {
            engine = EVP_sha1();
    }
    output = (unsigned char *) malloc(EVP_MAX_MD_SIZE);
    HMAC_CTX *ctx = HMAC_CTX_new();
    HMAC_Init_ex(ctx, key, strlen(key), engine, NULL);
    HMAC_Update(ctx, (unsigned char *)input, strlen(input));
    HMAC_Final(ctx, output, &output_length);
    HMAC_CTX_free(ctx);
}

int main(int, char**) {
    char key[] = "012345678";
    string data = "Hello World";
    unsigned char *mac = NULL;
    unsigned int mac_length = 0;
    int ret = HmacEncode("sha1", key, strlen(key), 
            data.c_str(), (unsigned int)data.length(), mac, mac_length);
    if(0 == ret) {
        cout << "ok." << endl;
    }
    cout << "mac:";
    for(int i = 0; i < mac_length; i++) {
            printf("%-02x", (unsigned int)mac[i]);
    }
    cout << endl;
    if(mac) free(mac);
}
```