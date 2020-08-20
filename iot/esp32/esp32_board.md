# 一块ESP32的小板子

## 购买信息
购买地址:  
[Goouuu-ESP32模块开发板 无线WiFi+蓝牙 2合1 双核CPU 物联网](https://item.taobao.com/item.htm?spm=a1z09.2.0.0.409c2e8dZy2D7B&id=547082402418&_u=joued4v6c86)

卖家提供的资料:  
[ESP-32F资料(1)](https://pan.baidu.com/s/1mRs0VI9ByT0g8YMhH61Kfg)

卖家提供的视频教程:  
[视频教程(1)](https://pan.baidu.com/s/1Oqo79lZwB9BqRCkdo18wWA)

## 乐鑫提供的资料
[ESP32-WROOM-32D & ESP32-WROOM-32U 技术规格书](https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32d_esp32-wroom-32u_datasheet_cn.pdf)  
[ESP32-WROOM-32D-V2.2 & ESP32-WROOM-32U-V2.1 模组参考设计 r1.0](https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32desp32-wroom-32u_mo_zu_can_kao_she_ji_.zip)

## 为什么没有I2C总线的标识?
因为I2C的bus可以映射到任意引脚.

## 引脚定义(USB下)
### 左侧(自上而下)
|板子标记|模组标记|F0|F1|F2|F3|F4|F5|
|:-|:-|:-|:-|:-|:-|:-|:-|:-|
|3V3|3V3||||||||
|EN|EN||||||||
|SP|SENSOR_VP|<span style="background:red;color:white;">GPIO36</span>|<font style="background:green;color:white;">ADC1_CH0</span>|<font style="background:green;color:white;">ADC_H</span>|<font style="background:yellow;color:black;">RTC_GPIO0</span>|SENSOR_VP||
|SN|SNESOR_VN|<span style="background:red;color:white;">GPIO39</span>|<font style="background:green;color:white;">ADC1_CH3</span>|<font style="background:green;color:white;">ADC_H|<font style="background:yellow;color:black;">RTC_GPIO3</span>|SENSOR_VN||
|G34|IO34|<span style="background:red;color:white;">GPIO34</span>|<font style="background:green;color:white;">ADC1_CH6</span>||<font style="background:yellow;color:black;">RTC_GPIO4</span>|||
|G35|IO35|<span style="background:red;color:white;">GPIO35</span>|<font style="background:green;color:white;">ADC1_CH7</span>||<font style="background:yellow;color:black;">RTC_GPIO5</span>|||
|G32|IO32|<span style="background:red;color:white;">GPIO32</span>|<font style="background:green;color:white;">ADC1_CH4</span>|<font style="background:pink;color:white;">TOUCH9|<font style="background:yellow;color:black;">RTC_GPIO9</span>|XTAL_32K_P||
|G33|IO33|<span style="background:red;color:white;">GPIO33</span>|<font style="background:green;color:white;">ADC1_CH5</span>|<font style="background:pink;color:white;">TOUCH8|<font style="background:yellow;color:black;">RTC_GPIO8</span>|XTAL_32K_N||
|G25|IO25|<span style="background:red;color:white;">GPIO25</span>|<font style="background:green;color:white;">ADC2_CH8</span>|DAC_1|<font style="background:yellow;color:black;">RTC_GPIO6</span>|EMAC_RXD0||
|G26|IO25|<span style="background:red;color:white;">GPIO26</span>|<font style="background:green;color:white;">ADC2_CH9</span>|DAC_2|<font style="background:yellow;color:black;">RTC_GPIO7|EMAC_RXD1</span>||
|G27|IO27|<span style="background:red;color:white;">GPIO27</span>|<font style="background:green;color:white;">ADC2_CH7</span>|<font style="background:pink;color:white;">TOUCH7|<font style="background:yellow;color:black;">RTC_GPIO17|EMAC_RX_DV||
|G14|IO14|<span style="background:red;color:white;">GPIO14</span>|<font style="background:green;color:white;">ADC2_CH6</span>|<font style="background:pink;color:white;">TOUCH6|<font style="background:yellow;color:black;">RTC_GPIO16|MTMS|HSPICLK|HS2_CLK|<font style="background:gray;color:black;">SD_CLK|EMAC_TX2|
|G12|IO12|<span style="background:red;color:white;">GPIO12</span>|<font style="background:green;color:white;">ADC2_CH5</span>|<font style="background:pink;color:white;">TOUCH5|<font style="background:yellow;color:black;">RTC_GPIO15|MTDI|HSPIQ|HS2_DATA2|<font style="background:gray;color:black;">SD_DATA2|EMAC_TXD3|
|GND|GND||||||||
|G13|IO13|<span style="background:red;color:white;">GPIO13</span>|<font style="background:green;color:white;">ADC2_CH4</span>|<font style="background:pink;color:white;">TOUCH4|<font style="background:yellow;color:black;">RTC_GPIO14</span>|MTCK|HSPID|HS2_DATA3|<font style="background:gray;color:black;">SD_DATA3|EMAC_RX_ER||
|SD2|SHD/SD2|<span style="background:red;color:white;">GPIO9</span>|<font style="background:gray;color:black;">SD_DATA2</span>|SPIHD|HS1_DATA2|U1RXD||
|SD3|SWP/SD|<span style="background:red;color:white;">GPIO10</span>|<font style="background:gray;color:black;">SD_DATA3</span>|SPIWP|HS1_DATA3|U1TXD||
|CMD|SCS/CMD|<span style="background:red;color:white;">GPIO11</span>|<font style="background:gray;color:black;">SD_CMD</span>|SPICS0|HS1_CMD|U1RTS||

### 右侧(自上而下)
|板子标记|模组标记|F0|F1|F2|F3|F4|F5|F6|F7|F8|
|:-|:-|:-|:-|:-|:-|:-|:-|:-|:-|:-|:-|
|GND|GND|
|G23|IO23|<span style="background:red;color:white;">GPIO23</span>|VSPID|HS1_STORE|
|G22|IO22|<span style="background:red;color:white;">GPIO22</span>|VSPIWP|U0RTX|EMAC_TXD1|
|TXD0|TXD0|<span style="background:red;color:white;">GPIO1</span>|<span style="background:blue;color:white;">U0TXD</span>|CLK_OUT3|EMAC_RXD2|
|RXD0|RXD0|<span style="background:red;color:white;">GPIO3</span>|<span style="background:blue;color:white;">U0RXD</span>|CLK_OUT2|
|G21|IO21|<span style="background:red;color:white;">GPIO21</span>|VSPIHD|EMAC_TX_EN|
|NC|NC|
|G19|IO19|<span style="background:red;color:white;">GPIO19</span>|VSPIQ|U0CTS|EMAC_TXD0|
|G18|IO18|<span style="background:red;color:white;">GPIO18</span>|VSPICLK|HS1_DATA7|
|G5|IO5|<span style="background:red;color:white;">GPIO5</span>|VSPICS0|HS1_DATA6|EMAC_RX_CLK|
|G17|IO17|<span style="background:red;color:white;">GPIO17</span>|HS1_DATA5|U2TXD|EMAC_CLK_OUT|180|
|G16|IO16|<span style="background:red;color:white;">GPIO16</span>|HS1_DATA4|U2RXD|EMAC_CLK_OUT|
|G4|IO4|<span style="background:red;color:white;">GPIO4</span>|<font style="background:green;color:white;">ADC2_CH0|<font style="background:pink;color:white;">TOUCH0</span>|<font style="background:yellow;color:black;">RTC_GPIO10|HSPIHD|HS2_DATA1|EMAC_TX_ER|
|G0|IO0|<span style="background:red;color:white;">GPIO0</span>|<font style="background:green;color:white;">ADC2_CH1</span>|<font style="background:pink;color:white;">TOUCH1</span>|<font style="background:yellow;color:black;">RTC_GPIO11|CLK_OUT1|EMAC_TX_CLK|
|G2|IO2|<span style="background:red;color:white;">GPIO2</span>|<font style="background:green;color:white;">ADC2_CH2</span>|<font style="background:pink;color:white;">TOUCH2</span>|<font style="background:yellow;color:black;">RTC_GPIO12|HSPIWP|HS2_DATA0|<font style="background:gray;color:black;">SD_DATA0</span>|
|G15|IO15|<span style="background:red;color:white;">GPIO15</span>|<font style="background:green;color:white;">ADC3_CH3|<font style="background:pink;color:white;">TOUCH3</span>|MTDO|HSPICS0|<font style="background:yellow;color:black;">RTC_GPIO13|HS2_CMD|<font style="background:gray;color:black;">SD_CMD</span>|EMAC_RXD3|
|SD1|SD1/SD1|<span style="background:red;color:white;">GPIO8</span>|<font style="background:gray;color:black;">SD_DATA1</span>|SPID|HS1_DATA1|U2CTS|
|SD0|SD0/SD0|<span style="background:red;color:white;">GPIO7</span>|<font style="background:gray;color:black;">SD_DATA0</span>|SPIQ|HS1_DATA0|U2RTS|
|CLK|SCK/CLK|<span style="background:red;color:white;">GPIO6</span>|<font style="background:gray;color:black;">SD_CLK</span>|SPICLK|HS1_CLK|U1CTS|