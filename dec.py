#!/bin/python2.7

import os
import xxtea
import binascii

key = "he7#*g94hZD#@rJu"
enc = b"PxHjQq6eTmidi9VP0J1ekQx2VFlfOqoveqnmP6tRnLml5XLXZwJYnV2k8g+jVfzv1siXz0XuZOZACppTfGpy2Rv0781lNnmJvhv8PqCv913XiUSj7MTsLoI8Qvq//f32S/WEnP4uOtLwHLnx//6BZiVxj7VlPTtBvgHwNA7RNaasSOLxoUzvOXB2eStSKpsJgwL6j568JiKjvqIF0I6SHpdQ6XTLyU0R+GDaDghW9iB9tDO5k4AShNvKkZLHhktd8D0jzMRlgoHEA4SMwosgc705zxX7f5VkbNqgFLvP8WO22eH5hdQeBRtxbWqJNk4SHf+Eoed8HBtfxGttHKkrEl4dDfDu/+O8olWasWcdlszuya3pHuPUE6lBOK3RN9xrd6xZk1aangLuSM6vgSR6cbo/QEklJomyvFtlbJRX+Ksz0uVZv+pKfMEA+Rv1ZxLPlOmJQLSHj02ty4SYcTk/nrf6Uw6amfudRyk/JxOcf3c"

dec = xxtea.decrypt(enc, key)
print dec