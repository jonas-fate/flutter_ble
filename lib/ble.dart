import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_001/common/utils/utils.dart';
import 'package:flutter_ble_001/operation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'common/utils/ble_tool.dart';

class BlePage extends StatefulWidget {
  const BlePage({Key? key}) : super(key: key);

  @override
  _BlePageState createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  bool isDebug = false;
  bool isBleOn = false;
  bool isConnecting = false;
  List<ScanResult> _bleDevices = [];
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requesBleState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ble Test"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemBuilder: _deviceBuilder,
          itemCount: _bleDevices.length,
          separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Divider(
                height: 1,
                color: Colors.black,
              )),
        ),
      ),
      // body: ListView.separated(
      //   itemBuilder: _deviceBuilder,
      //   itemCount: _bleDevices.length,
      //   separatorBuilder: (BuildContext context, int index) => Padding(
      //       padding: EdgeInsets.only(top: 20, bottom: 20),
      //       child: Divider(
      //         height: 1,
      //         color: Colors.black,
      //       )),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (BleManager.isBleOn) {
            searchBle();
          } else {
            Fluttertoast.showToast(
              msg: "???????????????",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          }
          // searchBle();
        },
        tooltip: '??????????????????',
        child: Icon(Icons.search),
      ),
    );
  }

  Widget _deviceBuilder(BuildContext context, int index) {
    ScanResult model = _bleDevices[index];
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: Row(
        children: <Widget>[
          Text(model.rssi.toString()),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(model.device.id.toString()),
              Text("name: " + model.device.name),
              Text("connectable: " +
                  model.advertisementData.connectable.toString()),
            ],
          ),
          Expanded(
            child: Text(''),
          ),
          // ignore: unrelated_type_equality_checks
          model.device.state != BluetoothDeviceState.connected
              ? ElevatedButton(
                  child: Text('connect'),
                  // onPressed: () => connectToBleDevice(model),
                  onPressed: () => _inputPassword(context, model),
                )
              : ElevatedButton(
                  child: Text('disConnect'),
                  onPressed: () => model.device.disconnect()),
        ],
      ),
    );
  }

  ///????????????

  // //??????????????????
  // requestBle() async {
  //   FlutterBlue flutterBlue = FlutterBlue.instance;
  //   print("????????????-----");

  //   if (await Permission.bluetooth.request().isGranted) {
  //     print("?????????????????????-----");
  //   } else {
  //     print("????????????????????????-----");
  //   }

  //   flutterBlue.isAvailable.then((value) {
  //     print("??????????????????,$value -----");
  //   });

  //   flutterBlue.isOn.then((value) {
  //     print("????????????????????????,$value -----");
  //     isBleOn = value;
  //   });

  //   flutterBlue.state.listen((state) {
  //     if (state == BluetoothState.on) {
  //       print("?????????????????????-----");
  //       isBleOn = true;
  //     } else if (state == BluetoothState.off) {
  //       print("????????????????????? -----");
  //       isBleOn = false;
  //     }
  //   });
  // }

  //??????????????????
  requesBleState() {
    BleManager.instance.bleStateIsOn();
  }

  //??????????????????
  void searchBle() {
    // BleManager.instance.startScan(scanResultHandler, timeout: 10);
    print("???????????? -----");

    if (!BleManager.isBleOn) {
      return;
    }

    if (mounted) {
      setState(() {
        _bleDevices.clear();
      });
    }

    BleManager.instance.stopScan();

    // BleManager.instance.startScan(scanResultHandler, timeout: 10);

    Future.delayed(Duration(milliseconds: 100), () {
      BleManager.instance.startScan(scanResultHandler, timeout: 10);
    });
  }

  //??????????????????
  void scanResultHandler(List<ScanResult>? results) {
    print('results ====> $results');
    // print('?????? ====> ${results!.length}');
    List<ScanResult> devices = [];

    for (ScanResult r in results!) {
      print('${r.device.name} found! rssi: ${r.rssi}');
      // if (r.device.name == "BJP00000000") {
      //   devices.add(r);
      // }
      devices.add(r);
    }

    if (mounted) {
      setState(() {
        this._bleDevices = devices;
      });
    }
  }

  //??????????????????
  void connectToBleDevice(ScanResult model, String password) async {
    print('connecting...');
    // BleManager.instance.stopScan();
    // BleManager.instance.connectDevice(model.device).then((e) {
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => OperationPage(model: model)));
    // });

    BleManager.instance.stopScan();
    //??????
    await model.device.disconnect();
    BleManager.instance.connectDevice(model.device).then((e) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OperationPage(
                model: model,
                password: password,
              )));
    });
  }

  // _onRefresh ??????????????????
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(milliseconds: 500), () {
      // ??????0.5s????????????
      searchBle();
    });
  }

  //????????????
  void _searchDialog(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('????????????'),
          content: Container(
            width: 100,
            height: 80,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "????????????????????????",
                  ),
                  style: TextStyle(textBaseline: TextBaseline.alphabetic),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("??????"),
            ),
            ElevatedButton(
              onPressed: () {
                print(_searchController.value.text);
                Navigator.pop(context);
                _searchAction(_searchController.value.text);
              },
              child: Text("??????"),
            ),
          ],
        );
      },
    );
  }

  //????????????????????????
  void _searchAction(String param) {
    List<ScanResult> devices = [];
    for (ScanResult r in this._bleDevices) {
      if (r.device.name.contains(param)) {
        devices.add(r);
      }
    }

    if (mounted) {
      setState(() {
        _bleDevices.clear();
        this._bleDevices = devices;
      });
    }
  }

  //??????????????????
  void _inputPassword(context, ScanResult model) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('????????????'),
          content: Container(
            width: 100,
            height: 80,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "?????????6?????????",
                  ),
                  style: TextStyle(textBaseline: TextBaseline.alphabetic),
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  onChanged: (text) {
                    if (text.length >= 6) {
                      // ????????????
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("??????"),
            ),
            ElevatedButton(
              onPressed: () {
                String password = _passwordController.value.text;
                print(password);
                if (password.length != 6) {
                  Fluttertoast.showToast(
                    msg: "????????????6???",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                  );
                } else {
                  // ????????????
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                  connectToBleDevice(model, password);
                }
              },
              child: Text("??????"),
            ),
          ],
        );
      },
    );
  }
}
