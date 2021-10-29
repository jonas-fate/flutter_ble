import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class EncryptUtil {
  static const List<int> keyBytes = [
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

  final _key = Key.fromBase64(base64Encode(keyBytes));
  final _iv = IV.fromBase64(base64Encode(keyBytes));

  // //aes加密
  // String aesEncode(List<int> dataBytes, List<int> keyBytes) {
  //   print('keyBytes --- $keyBytes');
  //   try {
  //     String keyStr = utf8.decode(keyBytes);
  //     String dataStr = utf8.decode(dataBytes);
  //     print('keyStr --- $keyStr');
  //     print('dataStr --- $dataStr');

  //     final key = Key.fromBase64(base64Encode(keyBytes));
  //     final iv = IV.fromBase64(base64Encode(keyBytes));
  //     final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: null));
  //     // final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
  //     final encrypted = encrypter.encryptBytes(dataBytes, iv: iv);
  //     // final encrypted = encrypter.encrypt(content, iv: IV.fromLength(0));
  //     return encrypted.base16;
  //   } catch (err) {
  //     String errorStr = "aes encode error:$err";
  //     // print("aes encode error:$err");
  //     print(errorStr);
  //     return errorStr;
  //   }
  // }

  // //aes解密
  // dynamic aesDecode(dynamic base16, List<int> keyBytes) {
  //   try {
  //     final key = Key.fromBase64(base64Encode(keyBytes));
  //     final iv = IV.fromBase64(base64Encode(keyBytes));
  //     final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: null));
  //     String result = encrypter.decrypt16(base16, iv: iv);
  //     List<int> decrypStr = utf8.encode(result);
  //     return decrypStr;
  //   } catch (err) {
  //     print("aes decode error:$err");
  //     return base16;
  //   }
  // }

  //aes加密
  dynamic aesEncode(List<int> dataBytes) {
    print('keyBytes --- $keyBytes');
    try {
      final encrypter = Encrypter(AES(_key, mode: AESMode.ecb, padding: null));
      final encrypted = encrypter.encryptBytes(dataBytes, iv: _iv);
      return encrypted.bytes;
    } catch (err) {
      String errorStr = "aes encode error:$err";
      print(errorStr);
      return errorStr;
    }
  }

  //aes解密
  dynamic aesDecode(Uint8List dataList) {
    try {
      final encrypter = Encrypter(AES(_key, mode: AESMode.ecb, padding: null));
      Encrypted encrypted = Encrypted(dataList);
      final decrypted = encrypter.decryptBytes(encrypted, iv: _iv);
      print('decrypted --- $decrypted');
      return decrypted;
    } catch (err) {
      String errorStr = "aes encode error:$err";
      print(errorStr);
      return errorStr;
    }
  }
}
