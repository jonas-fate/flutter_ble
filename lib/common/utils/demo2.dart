import 'dart:typed_data';

import 'package:flutter_ble_001/common/utils/Encrypt_Util.dart';

import 'num_tool.dart';

main(List<String> args) {
  String keyString = "3A60432F5C01211F291E0F4E0C132825";
  String dataString = "0601E2312D1A683D48271A18316E471A";

  List<int> keyBytes = listFromHexString(keyString);
  List<int> dataBytes = listFromHexString(dataString);

  print('keyBytes --- $keyBytes');
  print('dataBytes --- $dataBytes');

  EncryptTool encryptTool = EncryptTool(keyBytes);
  List<int> encryptList = encryptTool.aesEncode(dataBytes);
  print('encryptList --- $encryptList');
  String enResult = intArrayToHexString(encryptList);
  print('加密指令 --- $enResult');

  print('----------------------------------------------------');

  List<int> testBytes = [
    140,
    54,
    206,
    113,
    91,
    171,
    163,
    202,
    73,
    34,
    101,
    245,
    115,
    182,
    199,
    26
  ];
  Uint8List dataList = Uint8List.fromList(testBytes);
  print("dataList --- $dataList");

  List<int> decryptList = encryptTool.aesDecode(dataList);
  print('decryptList --- $decryptList');

  String deResult = intArrayToHexString(decryptList);
  print('result --- $deResult');
  if (deResult.contains("0601")) {
    int length = decryptList[2];
    List<int> tokenList = decryptList.sublist(3, 3 + length);
    print('tokenList --- $tokenList');
    String tokenStr = intArrayToHexString(tokenList);
    print('tokenStr --- $tokenStr');
  }

  print('================================================');
  int num = 13;
  String hexNum = intToHex(num);
  String hexString = num.toRadixString(16);
  print('hexNum --- $hexNum');
  print('hexString --- $hexString');

  String name = "abc";
  List<int> nameList = stringToIntArray(name);
  print('nameList --- $nameList');

  // List<int> batteryList = [6, 2, 2, 250, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  // String value1 = intToFormatHex(batteryList[4]);
  // String value2 = intToFormatHex(batteryList[3]);
  // String hexStr = value1 + value2;
  // print('hexStr --- $hexStr');
  // int battery = hexToInt(hexStr);
  // print('battery --- $battery');

  // int rate = 500;
  // String rateString = intToFormatHex(rate);
  // print('rateString --- $rateString');
  // String value1 = rateString.substring(0, 2);
  // String value2 = rateString.substring(2, 4);
  // print('value1 --- $value1');
  // print('value2 --- $value2');

  String a = "123456";
  String b = stringToHex(a);
  print('b ----- $b');
}
