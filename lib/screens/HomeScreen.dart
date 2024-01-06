import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_konewka_app/core/RequestHandler.dart';
import 'package:i_konewka_app/models/plant.dart';
import 'package:i_konewka_app/screens/AddPlantScreen.dart';
import 'package:i_konewka_app/screens/elements/PlantContainer.dart';

import '../main.dart';
import 'elements/Bar.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  Future<List<Plant>?>? plants;

  // BT BLOCK
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  String _platformVersion = 'Unknown';
  int _deviceStatus = Device.disconnected;
  Uint8List _data = Uint8List(0);
  // BT BLOCK

  @override
  void initState() {
    super.initState();
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding?.addPostFrameCallback((callback) {
      RequestHandler requestHandler = RequestHandler();
      var plantsData = requestHandler.getPlants();
      setState(() {
        plants = plantsData;
      });
    });
    // BT init
    _bluetoothClassicPlugin.initPermissions().then((value) => null);
    initPlatformState();
    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      setState(() {
        _deviceStatus = event;
      });
    });
    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      setState(() {
        _data = Uint8List.fromList([..._data, ...event]);
      });
    });
    // BT init
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _bluetoothClassicPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      _devices = res;
    });
  }

  Future<void> _scan() async {
    if (_scanning) {
      await _bluetoothClassicPlugin.stopScan();
      setState(() {
        _scanning = false;
      });
    } else {
      await _bluetoothClassicPlugin.startScan();
      _bluetoothClassicPlugin.onDeviceDiscovered().listen(
        (event) {
          setState(() {
            _discoveredDevices = [..._discoveredDevices, event];
          });
        },
      );
      setState(() {
        _scanning = true;
      });
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Bar(),
      body: Center(
        child: SingleChildScrollView(
            child: FutureBuilder<List<Plant>?>(
                future: plants,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return ListView.separated(
                        shrinkWrap: true,
                        reverse: false,
                        itemBuilder: (context, index) => PlantContainer(
                              height: 100,
                              width: 100,
                              fontSize: 28,
                              name: snapshot.data?[index].name,
                              icon: Icons.sentiment_very_satisfied,
                              image: snapshot.data![index].getImageWidget(),
                              plantId: snapshot.data![index].fid,
                              waterAmount: snapshot.data![index].ml_per_watering
                                  as String,
                            ),
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 0));
                  } else {
                    return const Text('');
                  }
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorKey.currentState?.pushNamed(AddPlantScreen.routeName);
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
