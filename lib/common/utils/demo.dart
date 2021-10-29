import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_ble_001/common/utils/num_tool.dart';

main(List<String> args) {
  List<int> keyBytes = [
    58,
    96,
    67,
    47,
    92,
    1,
    33,
    31,
    41,
    30,
    15,
    78,
    12,
    19,
    40,
    37
  ];
  print('keyBytes --- $keyBytes');

  List<int> dataBytes = [
    6,
    1,
    226,
    49,
    45,
    26,
    104,
    61,
    72,
    39,
    26,
    24,
    49,
    110,
    71,
    26
  ];
  print('dataBytes --- $dataBytes');

  // String keyStr = utf8.decode(keyBytes);
  // String dataStr = utf8.decode(dataBytes);
  // print('keyStr --- $keyStr');
  // print('dataStr --- $dataStr');

  final key = Key.fromBase64(base64Encode(keyBytes));
  final iv = IV.fromBase64(base64Encode(keyBytes));

  // final key = Key.fromUtf8(keyStr);
  // final iv = IV.fromUtf8(keyStr);
  // final encrypter = Encrypter(AES(key));
  final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: null));

  final encrypted = encrypter.encryptBytes(dataBytes, iv: iv);

  // final decrypted = encrypter.decryptBytes(encrypted, iv: iv);

  print('bytes --- ${encrypted.bytes}');
  print('加密指令 --- ${encrypted.base16}');
  // print('base64 --- ${encrypted.base64}');
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

  Uint8List uint8list = Uint8List.fromList(testBytes);
  print("uint8list --- $uint8list");

  Encrypted testEncrypt = Encrypted(uint8list);
  final decrypted = encrypter.decryptBytes(testEncrypt, iv: iv);
  print('decrypted --- $decrypted');
  String result = intArrayToHexString(decrypted);
  print('result --- $result');

  List<int> testArray = listFromHexString(result);
  print('testArray --- $testArray');

  if (result.contains("0601")) {
    int length = decrypted[2];
    print('length --- $length');
    List<int> tokenList = decrypted.sublist(3, 3 + length);
    print('tokenList --- $tokenList');
    String tokenStr = intArrayToHexString(tokenList);
    print('tokenStr --- $tokenStr');
  }

  print('====================================');
}
