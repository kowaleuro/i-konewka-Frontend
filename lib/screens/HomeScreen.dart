import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:i_konewka_app/core/RequestHandler.dart';
import 'package:i_konewka_app/models/plant.dart';
import 'package:i_konewka_app/screens/AddPlantScreen.dart';
import 'package:i_konewka_app/screens/elements/PlantContainer.dart';

import '../main.dart';
import 'elements/StatefulBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  Future<List<Plant>?>? plants;

  // TODO: change address
  final String deviceAddress = "00:11:22:33:FF:EE";
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice? device;
  BluetoothConnection? connection;
  bool? bondState;

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
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        bluetoothState = state;
      });
    });
    // try until isEnabled returns true, terminating the loop
    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        print('Adapter is on. Proceeding to init connection');
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // TODO: uncomment
      // bond the device
      // FlutterBluetoothSerial.instance.bondDeviceAtAddress(deviceAddress).then((bool? bond){
      //   if(bond ?? false){
      //     print('Successfully bonded.');
      //     setState(() {
      //       bondState = bond;
      //     });
      //   } else {
      //     print('Failed to bond.');
      //   }
      // });
      // // initialize the connection
      // print('Initializing connection to device.');
      // BluetoothConnection.toAddress(deviceAddress).then((BluetoothConnection conn) {
      //   print('$conn');
      //   setState(() {
      //     connection = conn;
      //   });
      // });
    });
    // To propagate adapter state to children widgets
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothState = state;
      });
    });
    // propagate bond change
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothState = state;
      });
    });
  }

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BluetoothStatusWidgetBar(),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<List<Plant>?>(
            future: plants,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return ListView.separated(
                    shrinkWrap: true,
                    reverse: false,
                    itemBuilder: (context, index) =>
                        PlantContainer(height: 100, width: 100, fontSize: 28, name:  snapshot.data?[index].name, icon: Icons.sentiment_very_satisfied,image: snapshot.data![index].getImageWidget(),water: snapshot.data?[index].ml_per_watering as String),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (BuildContext context, int index) =>  const SizedBox(height:0)
                );

              }else{
                return const Text('');

              }
            }
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){navigatorKey.currentState?.pushNamed(AddPlantScreen.routeName);},
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),

      ),
    );
  }
}