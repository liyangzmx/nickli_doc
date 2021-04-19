# LLDB

官网: [The LLDB Debugger](https://lldb.llvm.org/index.html)

GDB到LLDB的命令映射: [GDB to LLDB command map](https://lldb.llvm.org/use/map.html)

## LLDB一些查看变量的技巧
### 打印数据
打印数组:
```
(lldb) parray 10 av_packet.data
(uint8_t *) $0 = 0x000000743d14a5c0 "" {
  (uint8_t) [0] = '\0' 0 '\0'
  (uint8_t) [1] = '\0' 0 '\0'
  (uint8_t) [2] = '\0' 0 '\0'
  (uint8_t) [3] = '\x01' 1 '\x01'
  (uint8_t) [4] = '\x06' 6 '\x06'
  (uint8_t) [5] = '\x05' 5 '\x05'
  (uint8_t) [6] = '\xff' 255 '\xff'
  (uint8_t) [7] = '\xff' 255 '\xff'
  (uint8_t) [8] = '\x9d' 157 '\x9d'
  (uint8_t) [9] = '\xdc' 220 '\xdc'
}
```
带有偏移量的打印:
```
(lldb) parray 3 av_packet.data + 3
(uint8_t *) $4 = 0x000000743d14a5c3 "\x01\x06\x05... ..." {
  (uint8_t) [0] = '\x01' 1 '\x01'
  (uint8_t) [1] = '\x06' 6 '\x06'
  (uint8_t) [2] = '\x05' 5 '\x05'
}
```