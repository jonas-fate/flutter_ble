import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

// import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_ble_001/widgets/input.dart';
import 'package:flutter_ble_001/widgets/button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ble_001/common/utils/utils.dart';
import 'package:flutter_ble_001/common/utils/num_tool.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'common/utils/EncryptUtil.dart';
import 'common/utils/Encrypt_Util.dart';
import 'common/utils/ble_tool.dart';

class OperationPage extends StatefulWidget {
  final ScanResult model;
  final String password;
  const OperationPage({Key? key, required this.model, required this.password})
      : super(key: key);
  // OperationPage(this.scan);

  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  //rename的控制器
  final TextEditingController _renameController = TextEditingController();
  //修改密码的控制器
  final TextEditingController _resetPWDController = TextEditingController();
  //修改密码的控制器
  final TextEditingController _setBroadcastController = TextEditingController();

  //电量
  String _battery = "电量";
  // StreamSubscription<List<int>>? _notifySubscription;
  late BluetoothCharacteristic _characteristicForNotify;
  late BluetoothCharacteristic _characteristicForWrite;
  late EncryptTool _encryptTool;
  late String _tokenStr;

  //控制loading
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();

    print('password ====== ${widget.password}');
    print('deviceName ====== ${widget.model.device.name}');

    String keyString = "3A60432F5C01211F291E0F4E0C132825";
    List<int> keyBytes = listFromHexString(keyString);
    print('keyBytes --- $keyBytes');
    _encryptTool = EncryptTool(keyBytes);

    _discoverServices();
  }

  void dispose() {
    super.dispose();
    BleManager.instance.disconnectDevice(widget.model.device).then((value) {
      print("disconnected !!");
      // _notifySubscription!.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Operation"),
      ),
      // body: Center(
      //   child: _showLoading
      //       ? CircularProgressIndicator()
      //       : Column(
      //           children: [
      //             _renameWidget(),
      //             SizedBox(height: 10),
      //             _resetPWDWidget(),
      //             SizedBox(height: 10),
      //             _setBroadcastWidget(),
      //             SizedBox(height: 180),
      //             _getBatteryWidget(),
      //           ],
      //         ),
      // ),
      body: _showBodyWidget(),
    );
  }

  //主控件
  _showBodyWidget() {
    if (_showLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("正在连接设备......")
          ],
        ),
      );
    } else {
      return Column(
        children: [
          _renameWidget(),
          SizedBox(height: 10),
          _resetPWDWidget(),
          SizedBox(height: 10),
          _setBroadcastWidget(),
          SizedBox(height: 180),
          _getBatteryWidget(),
        ],
      );
    }
  }

  //更改名称Widget
  Widget _renameWidget() {
    return Container(
      // height: 80.h,
      margin: EdgeInsets.all(10.w),
      child: Row(
        children: [
          Expanded(
            child: inputTextEdit(
              controller: _renameController,
              hintText: "请输入9位以内字母或数字",
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(9)],
            ),
          ),
          // Spacer(),
          SizedBox(width: 15.w),
          globalFlatButton(
            width: 80.w,
            height: 40.h,
            onPressed: () {
              // 收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
              _setDeviceName();
            },
            title: "更改名称",
          ),
        ],
      ),
    );
  }

  //修改密码Widget
  Widget _resetPWDWidget() {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Row(
        children: [
          Expanded(
            child: inputTextEdit(
              controller: _resetPWDController,
              hintText: "请输入6位字母或数字",
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              onChangedHandler: (text) {
                if (text.length >= 6) {
                  // 收起键盘
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
            ),
          ),
          // Spacer(),
          SizedBox(width: 15.w),
          globalFlatButton(
            width: 80.w,
            height: 40.h,
            onPressed: () {
              // 收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
              _resetPassword();
            },
            title: "更改密码",
          ),
        ],
      ),
    );
  }

  //设置广播频率Widget
  Widget _setBroadcastWidget() {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Row(
        children: [
          Expanded(
            child: inputTextEdit(
              controller: _setBroadcastController,
              hintText: "请输入广播频率",
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: 15.w),
          globalFlatButton(
            width: 80.w,
            height: 40.h,
            onPressed: () {
              // 收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
              _setBroadcastRate();
            },
            title: "设置频率",
          ),
        ],
      ),
    );
  }

  //获取电量Widget
  Widget _getBatteryWidget() {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Text(
            _battery,
            style: TextStyle(
              fontSize: 30.0, // 文字大小
              color: Colors.blue, // 文字颜色
            ),
          ),
          SizedBox(height: 30),
          globalFlatButton(
            onPressed: () {
              print("获取电量");
              _getBatteryLevel();
            },
            title: "获取电量",
          ),
        ],
      ),
    );
  }

  //获取读写服务
  _discoverServices() async {
    List<BluetoothService> services =
        await BleManager.instance.deviceToDiscoverServices(widget.model.device);
    print("+++++++$services");

    if (services.isEmpty) return;
    services.forEach((service) {
      print("uuid=${service.uuid}  deviceId=${service.deviceId}");
      if (service.uuid.toString() == "0000fff0-0000-1000-8000-00805f9b34fb") {
        print("---service is fff0---");

        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          // print("----BluetoothCharacteristic-->$c");
          // print("----BluetoothCharacteristicUUID-->${c.uuid}");
          if (c.uuid.toString().contains("a304d2495cba")) {
            print("is for write");
            _characteristicForWrite = c;
            Future.delayed(Duration(milliseconds: 100), () {
              _getToken();
            });
          } else if (c.uuid.toString().contains("a304d2495cb8")) {
            print("is for notify");
            _characteristicForNotify = c;
            _characteristicSetNotify();
          }
        }
      }
    });
  }

  //设置监听特征值
  _characteristicSetNotify() async {
    print("设置监听---------");
    await _characteristicForNotify.setNotifyValue(true);

    BleManager.instance.listenCharacteristicValue(_characteristicForNotify,
        (data) {
      print("data=>>>>>>$data");
      if (data!.isEmpty) {
        print("data=null>>>>>>");
        return;
      }

      Uint8List dataList = Uint8List.fromList(data);
      print("dataList=>>>>>>$dataList");

      List<int> decryptList = _encryptTool.aesDecode(dataList);
      print('decryptList --- $decryptList');

      String result = intArrayToHexString(decryptList);
      print('result --- $result');
      if (result.contains("0601")) {
        int length = decryptList[2];
        if (length == 1) {
          print("密码错误");
          _showWrongPasswordToast();
          Navigator.of(context).pop();
        } else {
          if (mounted) {
            setState(() {
              _showLoading = false;
            });
          }
          List<int> tokenList = decryptList.sublist(3, 3 + length);
          print('tokenList --- $tokenList');
          String tokenStr = intArrayToHexString(tokenList);
          print('tokenStr --- $tokenStr');
          _tokenStr = tokenStr;
        }
      } else if (result.contains("0602")) {
        String value1 = intToFormatHex(decryptList[4]);
        String value2 = intToFormatHex(decryptList[3]);
        String hexStr = value1 + value2;
        print('hexStr --- $hexStr');
        int battery = hexToInt(hexStr);
        print('battery --- $battery');
        if (mounted) {
          setState(() {
            _battery = battery.toString() + 'mV';
          });
        }
      } else if (result.contains("0603")) {
        if (decryptList[3] == 1) {
          Fluttertoast.showToast(
            msg: "名称修改成功",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        } else if (decryptList[3] == 0) {
          Fluttertoast.showToast(
            msg: "名称修改失败",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        }
      } else if (result.contains("0604")) {
        if (decryptList[3] == 1) {
          Fluttertoast.showToast(
            msg: "广播频率设置成功",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        } else if (decryptList[3] == 0) {
          Fluttertoast.showToast(
            msg: "广播频率设置失败",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        }
      } else if (result.contains("0605")) {
        if (decryptList[3] == 1) {
          Fluttertoast.showToast(
            msg: "密码修改成功",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        } else if (decryptList[3] == 0) {
          Fluttertoast.showToast(
            msg: "密码修改失败",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        }
      }

      // Uint8List uint8list = Uint8List.fromList(data);
      // Uint8List subList = Uint8List.sublistView(uint8list, 6, 8);
      // String value1 = intToFormatHex(subList[1]);
      // String value2 = intToFormatHex(subList[0]);
      // String hexStr = value1 + value2;
      // print('------- $hexStr');
      // int battery = hexToInt(hexStr);
      // print('battery ----- $battery');
      // setState(() {
      //   _battery = battery.toString() + 'mV';
      // });
    });

    // await widget.model.device.disconnect();
    // _notifySubscription!.cancel();
  }

  //写数据
  _writeDataWithDataList(List<int> dataList) async {
    print('dataList ----- $dataList');
    BleManager.instance
        .characteristicToWriteValue(_characteristicForWrite, dataList)
        .then((value) => print("write result:$value"));
  }

  //获取token
  _getToken() async {
    // String dataString = "06010631323334353600000000000000";
    String headerString = "060106";
    String passwordHex = stringToHex(widget.password);
    String tailString = "00000000000000";
    List<int> dataBytes =
        listFromHexString(headerString + passwordHex + tailString);
    print('dataBytes --- $dataBytes');

    List<int> encryptList = _encryptTool.aesEncode(dataBytes);
    print('encryptList --- $encryptList');
    String hexData = intArrayToHexString(encryptList);
    print('hexData --- $hexData');

    _writeDataWithDataList(encryptList);
  }

  //获取电量
  _getBatteryLevel() async {
    String dataString = "060204" + _tokenStr + "000000000000000000";
    print('dataString --- $dataString');
    List<int> dataBytes = listFromHexString(dataString);
    print('dataBytes --- $dataBytes');

    List<int> encryptList = _encryptTool.aesEncode(dataBytes);
    print('encryptList --- $encryptList');

    _writeDataWithDataList(encryptList);
  }

  //设置名称
  _setDeviceName() async {
    String name = _renameController.value.text;
    if (name.isNotEmpty) {
      print(name);
      List<int> headerList = [6, 3];
      List<int> nameList = stringToIntArray(name);
      headerList.add(4 + nameList.length);
      String headerString = intArrayToHexString(headerList);
      String nameString = intArrayToHexString(nameList);
      String tailString =
          "0" * (32 - (headerString + _tokenStr + nameString).length);
      String dataString = headerString + _tokenStr + nameString + tailString;
      print('dataString --- $dataString');
      List<int> dataBytes = listFromHexString(dataString);
      print('dataBytes --- $dataBytes');

      List<int> encryptList = _encryptTool.aesEncode(dataBytes);
      print('encryptList --- $encryptList');

      _writeDataWithDataList(encryptList);
    }
  }

  //修改密码
  _resetPassword() async {
    String password = _resetPWDController.value.text;
    if (password.isNotEmpty) {
      print(password);

      String headerString = "06050A";
      List<int> passwordList = stringToIntArray(password);
      String passwordString = intArrayToHexString(passwordList);
      String tailString =
          "0" * (32 - (headerString + _tokenStr + passwordString).length);
      String dataString =
          headerString + _tokenStr + passwordString + tailString;
      print('dataString --- $dataString');
      List<int> dataBytes = listFromHexString(dataString);
      print('dataBytes --- $dataBytes');

      List<int> encryptList = _encryptTool.aesEncode(dataBytes);
      print('encryptList --- $encryptList');

      _writeDataWithDataList(encryptList);
    }
  }

  //设置广播频率
  _setBroadcastRate() async {
    String rate = _setBroadcastController.value.text;
    if (rate.isNotEmpty) {
      print(rate);
      String headerString = "060406";
      String temp = intToFormat4Hex(int.parse(rate));
      String value1 = temp.substring(0, 2);
      String value2 = temp.substring(2, 4);
      String rateString = value2 + value1;
      String tailString =
          "0" * (32 - (headerString + _tokenStr + rateString).length);
      String dataString = headerString + _tokenStr + rateString + tailString;
      print('dataString --- $dataString');
      List<int> dataBytes = listFromHexString(dataString);
      print('dataBytes --- $dataBytes');

      List<int> encryptList = _encryptTool.aesEncode(dataBytes);
      print('encryptList --- $encryptList');

      _writeDataWithDataList(encryptList);
    }
  }

  //密码错误弹窗
  void _showWrongPasswordAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('温馨提示'),
          content: Container(
            width: 100,
            height: 80,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)..pop();
              },
              child: Text("确定"),
            ),
          ],
        );
      },
    );
  }

  //密码错误弹窗
  void _showWrongPasswordToast() {
    Fluttertoast.showToast(
      msg: "密码错误,请重新输入",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }
}
