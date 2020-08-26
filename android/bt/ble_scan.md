# BLE Scan(待完善)

## Application
根据Android SDK资料, 需要:
1. 从[BluetoothManager](https://developer.android.com/reference/android/bluetooth/BluetoothManager)中通过[getAdapter()](https://developer.android.com/reference/android/bluetooth/BluetoothManager#getAdapter())方法获取到BluetoothAdapter[](https://developer.android.com/reference/android/bluetooth/BluetoothAdapter)  
2. 然后通过其[getBluetoothLeScanner()](https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#getBluetoothLeScanner())方法得到一个:[BluetoothLeScanner](https://developer.android.com/reference/android/bluetooth/le/BluetoothLeScanner)  
3. 创建一个[ScanCallback](https://developer.android.com/reference/android/bluetooth/le/ScanCallback), 重写其[onBatchScanResults](https://developer.android.com/reference/android/bluetooth/le/ScanCallback#onBatchScanResults(java.util.List%3Candroid.bluetooth.le.ScanResult%3E))/[onScanFailed()](https://developer.android.com/reference/android/bluetooth/le/ScanCallback#onScanFailed(int))/[onScanResult()](https://developer.android.com/reference/android/bluetooth/le/ScanCallback#onScanResult(int,%20android.bluetooth.le.ScanResult))等方法
4. 执行[BluetoothLeScanner](https://developer.android.com/reference/android/bluetooth/le/BluetoothLeScanner)的:
   * [public void startScan (ScanCallback callback)](https://developer.android.com/reference/android/bluetooth/le/BluetoothLeScanner#startScan(android.bluetooth.le.ScanCallback))
   * [public void startScan (List<ScanFilter> filters, ScanSettings settings, ScanCallback callback)](https://developer.android.com/reference/android/bluetooth/le/BluetoothLeScanner#startScan(java.util.List%3Candroid.bluetooth.le.ScanFilter%3E,%20android.bluetooth.le.ScanSettings,%20android.bluetooth.le.ScanCallback))  
    其中连个参数:
     * 
  
   两个方法,在其[onScanResult()](https://developer.android.com/reference/android/bluetooth/le/ScanCallback#onScanResult(int,%20android.bluetooth.le.ScanResult))方法中, 你将得到扫描的结果: [ScanResult](https://developer.android.com/reference/android/bluetooth/le/ScanResult)
5. 通过[ScanResult](https://developer.android.com/reference/android/bluetooth/le/ScanResult)的[getDevice()](https://developer.android.com/reference/android/bluetooth/le/ScanResult#getDevice())方法得到[BluetoothDevice](https://developer.android.com/reference/android/bluetooth/BluetoothDevice), 而对于[BluetoothDevice](https://developer.android.com/reference/android/bluetooth/BluetoothDevice)而言, 可以获取到各种BLE设备的信息.