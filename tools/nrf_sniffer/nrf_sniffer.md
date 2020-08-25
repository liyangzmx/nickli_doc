# nRF Sniffer安装

## 评价
可以用...

## 软件下载地址
[nRF Sniffer for Bluetooth LE - Development tool](https://www.nordicsemi.com/Software-and-tools/Development-Tools/nRF-Sniffer-for-Bluetooth-LE/Download)

## 官方参考资料  
[nRF Sniffer for Bluetooth LE](https://infocenter.nordicsemi.com/index.jsp?topic=%2Fug_sniffer_ble%2FUG%2Fsniffer_ble%2Fintro.html)  
[Installing nRF Sniffer](https://infocenter.nordicsemi.com/index.jsp?topic=%2Fug_sniffer_ble%2FUG%2Fsniffer_ble%2Fintro.html)

## 命令记录
```
cd /opt/
mkdir nrf_sniffer_for_bluetooth_le_3
cd nrf_sniffer_for_bluetooth_le_3
cp -r Profile_nRF_Sniffer_Bluetooth_LE ~/.config/wireshark/profiles/
cp -r extcap/ ~/.config/wireshark/
cd ~/.config/wireshark/extcap/
sudo apt install python3-pip
pip3 install -r requirements.txt
./nrf_sniffer_ble.sh --extcap-interfaces

--- < OUTPUT > ---
Traceback (most recent call last):
  File "./nrf_sniffer_ble.py", line 52, in <module>
    from SnifferAPI import Sniffer, myVersion, Logger, UART, Devices
  File "/opt/nrf_sniffer_for_bluetooth_le_3/extcap/SnifferAPI/Sniffer.py", line 37, in <module>
    from . import UART
  File "/opt/nrf_sniffer_for_bluetooth_le_3/extcap/SnifferAPI/UART.py", line 40, in <module>
    import serial.tools.list_ports as list_ports
ModuleNotFoundError: No module named 'serial.tools'
```

执行:
```
pip3 uninstall serial
./nrf_sniffer_ble.sh --extcap-interfaces

--- < OUTPUT > ---
extcap {version=3.0.0}{display=nRF Sniffer for Bluetooth LE}{help=https://www.nordicsemi.com/Software-and-Tools/Development-Tools/nRF-Sniffer-for-Bluetooth-LE}
interface {value=/dev/ttyUSB0}{display=nRF Sniffer for Bluetooth LE}
control {number=0}{type=selector}{display=Device}{tooltip=Device list}
control {number=1}{type=string}{display=Passkey / OOB key}{tooltip=6 digit temporary key or 16 byte Out-of-band (OOB) key in hexadecimal starting with '0x', big endian format. If the entered key is shorter than 16 bytes, it will be zero-padded in front'}{validation=\b^(([0-9]{6})|(0x[0-9a-fA-F]{1,32}))$\b}
control {number=2}{type=string}{display=Adv Hop}{default=37,38,39}{tooltip=Advertising channel hop sequence. Change the order in which the siffer switches advertising channels. Valid channels are 37, 38 and 39 separated by comma.}{validation=^\s*((37|38|39)\s*,\s*){0,2}(37|38|39){1}\s*$}{required=true}
control {number=3}{type=button}{role=help}{display=Help}{tooltip=Access user guide (launches browser)}
control {number=4}{type=button}{role=restore}{display=Defaults}{tooltip=Resets the user interface and clears the log file}
control {number=5}{type=button}{role=logger}{display=Log}{tooltip=Log per interface}
value {control=0}{value= }{display=All advertising devices}{default=true}
```