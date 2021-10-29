import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class EncryptTool {
  late List<int> keyBytes;
  late Key _key;
  late IV _iv;

  EncryptTool(List<int> keyBytes) {
    this.keyBytes = keyBytes;
    _key = Key.fromBase64(base64Encode(keyBytes));
    _iv = IV.fromBase64(base64Encode(keyBytes));
  }

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
