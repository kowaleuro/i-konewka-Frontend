import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_konewka_app/core/RequestHandler.dart';
import 'package:i_konewka_app/models/plant.dart';
import 'package:i_konewka_app/screens/AddPlantScreen.dart';
import 'package:i_konewka_app/screens/elements/CustomButton.dart';
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
  int _deviceStatus = Device.disconnected;
  final String deviceAddress = 'B4:E6:2D:86:FC:4F';
  final String defaultUuid = "00001101-0000-1000-8000-00805f9b34fb";
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
    if (!IS_LISTENED_TO) {
      _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
        setState(() {
          _deviceStatus = event;
        });
      });
    }
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
    Color? color;
    if (0 == _deviceStatus) {
      color = Colors.red;
    } else if (_deviceStatus == 1) {
      color = Colors.orange;
    } else {
      color = Colors.greenAccent;
    }

    return Scaffold(
      appBar: const Bar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.01,
                      bottom: MediaQuery.of(context).size.width * 0.01),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width / 1.5, 30),
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: color),
              child: Text(
                "Device status: $_deviceStatus",
                style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(color: Colors.white, fontSize: 30)),
              )),
          Divider(),
          SingleChildScrollView(
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
                              waterAmount:
                                  snapshot.data![index].ml_per_watering),
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 0));
                    } else {
                      return const Text('');
                    }
                  })),
        ],
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
