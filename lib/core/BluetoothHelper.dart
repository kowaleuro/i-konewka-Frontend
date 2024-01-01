import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothHelper {
  final String deviceAddress = "00:11:22:33:FF:EE";
  bool isConnected = false;
  bool? isEnabled = false;
  bool get isBonded => bondState.isBonded;
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  BluetoothBondState bondState = BluetoothBondState.unknown;
  static BluetoothHelper? _instance;

  BluetoothHelper._(){
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
    });
    FlutterBluetoothSerial.instance.isEnabled.then((state) {
      isEnabled = state;
    });
  }

  static BluetoothHelper get instance {
    _instance ??= BluetoothHelper._();
    return _instance!;
  }

  Future<bool> bondDevice() async {
    FlutterBluetoothSerial.instance.bondDeviceAtAddress(deviceAddress).then((bool? bondResult){
      // black wizardy
      if(bondResult ?? true) return false;
      print('Bonded with i-konewka.');
      FlutterBluetoothSerial.instance.getBondStateForAddress(deviceAddress).then((BluetoothBondState state){
        bondState = state;
      });
      return true;
    });
    // when bond does not complete
    return false;
  }

  Future<BluetoothConnection> returnConnection() async {
    return BluetoothConnection.toAddress(deviceAddress);
  }

  Future<bool> verifyIkonewkaConnection(BluetoothConnection connection) async {
    // sends 'connect,' and expects to receive 'ok'
    bool _is_connected = false;
    Uint8List connection_data = ascii.encode('connect,');

    try {
      connection.input!.listen((Uint8List data) {
        print('encoded data: $connection_data');
        print('decoded data: ${ascii.decode(connection_data)}');
        connection.output.add(connection_data);
        print('Data incoming: ${ascii.decode(data)}');

        if (ascii.decode(data) == 'ok') {
          _is_connected = true;
        }
      }).onDone(() {
        print('Disconnected by remote request');
      });
    }
    catch (exception) {
      print('Cannot connect, exception occured');
    }
    return _is_connected;
  }

  Future<bool> sendWater(BluetoothConnection connection, String water) async {
    // sends 'water,{water}' and returns
    Uint8List water_data = ascii.encode('water,$water');
    if (await verifyIkonewkaConnection(connection)) {
      try {
        print('encoded data: $water_data');
        print('decoded data: ${ascii.decode(water_data)}');

        connection.output.add(water_data);
        await connection.output.allSent;
      }
      catch (exception) {
        print('Cannot write, exception occured');
      }
      return true;
    }
    return false;
  }
}