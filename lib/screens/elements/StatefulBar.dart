import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothStatusWidgetBar extends StatefulWidget implements PreferredSizeWidget {
  const BluetoothStatusWidgetBar({Key? key}) : super(key: key);

  @override
  _BluetoothStatusWidgetStateBar createState() => _BluetoothStatusWidgetStateBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BluetoothStatusWidgetStateBar extends State<BluetoothStatusWidgetBar> {
  bool isBluetoothEnabled = false;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothBondState _bondState = BluetoothBondState.unknown;
  Color backgroundColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _checkAdapterStatus();
    _checkBluetoothStatus();
    _checkBluetoothBondStatus();
  }

  Future<void> _checkAdapterStatus() async {
    try {
      print('Initiating adapter status check');
      isBluetoothEnabled = (await FlutterBluetoothSerial.instance.isEnabled)!;
      backgroundColor = isBluetoothEnabled ? Colors.green : Colors.red;
      print("Adapter status check result: $isBluetoothEnabled; setting color $backgroundColor");
    } catch (error) {
      print("Error checking Bluetooth status: $error");
    }
  }

  Future<void> _checkBluetoothStatus() async {

    FlutterBluetoothSerial.instance.state.then((state) {
      _bluetoothState = state;
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        print("Bluetooth state changed: $_bluetoothState -> $state");
        _bluetoothState = state;
        backgroundColor = ('STATE_ON' == _bluetoothState.stringValue) ? Colors.green : Colors.red;
      });
    });
  }

  Future<void> _checkBluetoothBondStatus() async {
    // TODO: podmienic na adres urzadzenia
    FlutterBluetoothSerial.instance.getBondStateForAddress("00:11:22:33:FF:EE").then((BluetoothBondState state){
      _bondState = state;
    });

    FlutterBluetoothSerial.instance
        .onBondChanged()
        .listen((BluetoothBondState state) {
      setState(() {
        print("Bond state changed: $_bondState -> $state");
        FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> dev){
          print(dev);
        });
        _bondState = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: const Text('I-Konewka'),
      centerTitle: true,
      backgroundColor: backgroundColor,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              _bondState.stringValue,
              style: const TextStyle(color: Colors.black),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            _bluetoothState.stringValue,
            style: const TextStyle(color: Colors.cyanAccent),
          )
        ),
      ],
    );
  }
}
