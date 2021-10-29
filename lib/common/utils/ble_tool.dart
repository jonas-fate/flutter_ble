import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:developer';
import 'dart:core';
import 'package:permission_handler/permission_handler.dart';

typedef ScanResultHandler = void Function(List<ScanResult>? datas);
typedef CharacteristicHandler = void Function(List<int>? datas);

class BleManager {
  FlutterBlue? _flutterBlue;
  factory BleManager() => _getInstance();
  static BleManager get instance => _getInstance();
  static BleManager? _instance;
  static bool isBleOn = false;
  BleManager._internal() {
    _flutterBlue = FlutterBlue.instance;
  }
  static BleManager _getInstance() {
    if (_instance == null) {
      _instance = BleManager._internal();
    }
    return _instance!;
  }

  //请求蓝牙状态
  Future<void> bleStateIsOn() async {
    print("蓝牙测试-----");

    if (await Permission.bluetooth.request().isGranted) {
      // print("蓝牙权限已开启-----");
    } else {
      // print("蓝牙权限请求失败-----");
    }

    _flutterBlue?.isAvailable.then((value) {
      // print("蓝牙是否可用,$value -----");
    });

    _flutterBlue?.isOn.then((value) {
      print("蓝牙状态已经开启,$value -----");
      isBleOn = value;
    });

    _flutterBlue?.state.listen((state) {
      if (state == BluetoothState.on) {
        print("蓝牙状态为开启-----");
        isBleOn = true;
      } else if (state == BluetoothState.off) {
        print("蓝牙状态为关闭 -----");
        isBleOn = false;
      }
    });
  }

  // //蓝牙连接状态
  // Future<void> bleConnectState(BluetoothDevice device) async {
  //   device.state.listen((state) {
  //     if (state == BluetoothDeviceState.connected) {
  //       print("蓝牙连接成功-----");
  //     } else if (state == BluetoothDeviceState.disconnected) {
  //       print("蓝牙断开 -----");
  //     }
  //   });
  // }

  startScan(ScanResultHandler dataHandler, {int timeout = 15}) {
    log("_scan");
    _flutterBlue?.startScan(timeout: Duration(seconds: timeout));

    // _flutterBlue?.startScan(
    //     timeout: Duration(seconds: timeout),
    //     withServices: [Guid('0000fff0-0000-1000-8000-00805f9b34fb')]);

    // _flutterBlue?.startScan(
    //     timeout: Duration(seconds: timeout),
    //     withServices: [Guid("0000fff0-0000-1000-8000-00805f9b34fb")]);

    _flutterBlue?.scanResults.listen(dataHandler);
  }

  stopScan() {
    log("_stopScan");
    _flutterBlue?.stopScan();
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    log("_connect");
    await device.connect(autoConnect: false);
    device.state.listen((state) {
      if (state == BluetoothDeviceState.connected) {
        print("蓝牙连接成功-----");
      } else if (state == BluetoothDeviceState.disconnected) {
        print("蓝牙断开 -----");
      }
    });
  }

  Future<List<BluetoothService>> deviceToDiscoverServices(
      BluetoothDevice device) async {
    return await device.discoverServices();
  }

  Future<bool> characteristicToSetNotifyValue(
      BluetoothCharacteristic characteristic) async {
    return await characteristic.setNotifyValue(true);
  }

  // StreamSubscription<List<int>> listenCharacteristicValue(BluetoothCharacteristic characteristic,
  //     CharacteristicHandler characteristicHandler) {
  //   StreamSubscription<List<int>> notifySubscription = characteristic.value.listen(characteristicHandler);
  //   return notifySubscription;
  // }

  listenCharacteristicValue(BluetoothCharacteristic characteristic,
      CharacteristicHandler characteristicHandler) {
    characteristic.value.listen(characteristicHandler);
  }

  // //新增
  // cancelListenCharacteristicValue(BluetoothCharacteristic characteristic,
  //     CharacteristicHandler characteristicHandler) {
  //   characteristic.value.listen(characteristicHandler).cancel();
  // }

  Future<Null> characteristicToWriteValue(
      BluetoothCharacteristic characteristic, List<int> list,
      {bool withoutResponse = false}) async {
    log(
      "_write  withoutResponse = $withoutResponse",
    );
    return await characteristic.write(list, withoutResponse: withoutResponse);
  }

  Future<List<int>> characteristicToReadValue(
      BluetoothCharacteristic characteristic) async {
    log("_read");
    return await characteristic.read();
  }

  Future<List<BluetoothDevice>>? getConnectedDevices() {
    return _flutterBlue?.connectedDevices;
  }

  Future<dynamic> disconnectDevice(BluetoothDevice device) async {
    log("_disconnect");
    return await device.disconnect();
  }
}
