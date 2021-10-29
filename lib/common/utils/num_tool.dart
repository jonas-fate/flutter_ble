//int ---> hex
String intToHex(int num) {
  String hexString = num.toRadixString(16);
  return hexString;
}

//hex ---> int
int hexToInt(String hex) {
  int val = 0;
  int len = hex.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = hex.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("Invalid hexadecimal value");
    }
  }
  return val;
}

//List<int> ---> hexString
String intArrayToHexString(List<int> list) {
  String result = "";
  for (var item in list) {
    String hexString = item.toRadixString(16);
    if (hexString.length == 1) {
      hexString = "0" + hexString;
    }
    result += hexString;
  }

  return result;
}

//十六进制字符串转十进制数组(每两个字符转一位)
List<int> listFromHexString(String hexString) {
  List<int> result = [];
  double length = hexString.length / 2;
  for (var i = 0; i < length; i++) {
    int start = 2 * i;
    String hex = hexString.substring(start, start + 2);
    // print('hex --- $hex');
    result.add(hexToInt(hex));
  }

  return result;
}

//---------------------------------------------------------------------------

//int ---> 指定长度的hex (如指定长度为6的情况,0x000001 0x001234, 0xefab23)
String intToFormatHex(int num) {
  String hexString = num.toRadixString(16);
  print("hexString=$hexString");
  String formatString = hexString.padLeft(2, "0");
  print("formatHexString=$formatString");
  return formatString;
}

//int ---> 指定长度4位的hex
String intToFormat4Hex(int num) {
  String hexString = num.toRadixString(16);
  print("hexString=$hexString");
  String formatString = hexString.padLeft(4, "0");
  print("formatHexString=$formatString");
  return formatString;
}

//字符串转十六进制
String stringToHex(String str) {
  String res = "";
  for (int i = 0; i < str.length; i++) {
    res = res + str.codeUnitAt(i).toRadixString(16);
  }
  print(res);
  return res;
}

//字符串转十进制数组
List<int> stringToIntArray(String str) {
  List<int> list = [];
  for (int i = 0; i < str.length; i++) {
    int num = str.codeUnitAt(i);
    list.add(num);
  }
  return list;
}

//十六进制转字符串
String hexArrayToString(List<int> hexArray) {
  // List<int> value = [0x23, 0x53, 0x74, 0x61, 0x72, 0x74, 0x23];
  String res = "";
  for (var i = 0; i < hexArray.length; i++) {
    res += String.fromCharCode(int.parse(hexArray[i].toRadixString(10)));
  }
  print(res);
  return res;
}
