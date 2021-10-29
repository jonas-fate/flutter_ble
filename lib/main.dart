import 'package:flutter/material.dart';
import 'package:flutter_ble_001/ble.dart';
// import 'package:flutter_ble_001/common/utils/EncryptUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'common/utils/encrypt_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ble"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BlePage();
              }));

              // String str = "111";
              // List<int> list = [];
              // for (int i = 0; i < str.length; i++) {
              //   int num = str.codeUnitAt(i);
              //   list.add(num);
              // }

              // print('list ----- $list');
              // print('length ==== ${list.length}');

              // int temp = 11 - list.length;
              // List<int> tempList = [];
              // for (var i = 0; i < temp; i++) {
              //   tempList.add(0);
              // }
              // print('length ==== $tempList');

              // var tList = list + tempList;
              // print('tList ==== $tList');

              // List<int> keyBytes = [
              //   32,
              //   87,
              //   47,
              //   82,
              //   54,
              //   75,
              //   63,
              //   71,
              //   48,
              //   80,
              //   65,
              //   88,
              //   17,
              //   99,
              //   45,
              //   43
              // ];
              // print('keyBytes --- $keyBytes');

              // List<int> dataBytes = [
              //   6,
              //   1,
              //   1,
              //   48,
              //   48,
              //   48,
              //   48,
              //   48,
              //   48,
              //   0,
              //   0,
              //   0,
              //   0,
              //   0,
              //   0,
              //   0
              // ];
              // print('dataBytes --- $dataBytes');
              // var encryptUtil = EncryptUtil();
              // String encryptStr = encryptUtil.aesEncode(dataBytes);
              // print('encryptStr --- $encryptStr');
              // List<int> decryptList = encryptUtil.aesDecode(encryptStr);
              // print('decryptList --- $decryptList');
            },
            child: Text("Ble Test")),
      ),
    );
  }
}
