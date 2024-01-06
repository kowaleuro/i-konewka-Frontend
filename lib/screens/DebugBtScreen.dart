import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

class DebugBtScreen extends StatefulWidget {
  const DebugBtScreen({super.key});
  static const routeName = '/DebugBtScreen';

  @override
  State<DebugBtScreen> createState() => _DebugBtScreenState();
}

class _DebugBtScreenState extends State<DebugBtScreen> {
  final String deviceAddress = 'B4:E6:2D:86:FC:4F';
  final String defaultUuid = "00001101-0000-1000-8000-00805f9b34fb";
  String _platformVersion = 'Unknown';
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  int _deviceStatus = Device.disconnected;
  String? _ikonewkaConnectionConfirm;
  Uint8List _data = Uint8List(0);
  @override
  void initState() {
    super.initState();
    initPlatformState();
    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      print('device state changed: $_deviceStatus -> $event');
      setState(() {
        _deviceStatus = event;
      });
    });
    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      print('data received: $event');
      setState(() {
        _data = Uint8List.fromList([..._data, ...event]);
      });
    });
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("Device status is $_deviceStatus"),
              TextButton(
                onPressed: () async {
                  await _bluetoothClassicPlugin.initPermissions();
                },
                child: const Text("Check Permissions"),
              ),
              TextButton(
                onPressed: _getDevices,
                child: const Text("Get Paired Devices"),
              ),
              TextButton(
                onPressed: _deviceStatus == Device.connected
                    ? () async {
                        await _bluetoothClassicPlugin.disconnect();
                      }
                    : null,
                child: const Text("disconnect"),
              ),
              TextButton(
                onPressed: _deviceStatus == Device.connected
                    ? () async {
                        _bluetoothClassicPlugin.write("connect,ok");
                        _bluetoothClassicPlugin
                            .onDeviceDataReceived()
                            .listen((event) {
                          setState(() {
                            print(
                                'data received: ${String.fromCharCodes(event)}');
                            _ikonewkaConnectionConfirm =
                                String.fromCharCodes(event);
                            _data = Uint8List.fromList([..._data, ...event]);
                          });
                        });
                      }
                    : null,
                child: const Text("send 'connect,ok'"),
              ),
              TextButton(
                onPressed: _deviceStatus == Device.connected
                    ? () async {
                        await _bluetoothClassicPlugin.write("water,123");
                      }
                    : null,
                child: const Text("send 'water,123'"),
              ),
              TextButton(
                onPressed: _deviceStatus != Device.connected
                    ? () async {
                        await _bluetoothClassicPlugin
                            .connect(deviceAddress, defaultUuid)
                            .then((result) {
                          print(
                              'ikonewka: ${result ? "connected" : "not connected"}');
                          setState(() {
                            _discoveredDevices = [];
                            _devices = [];
                          });
                        });
                      }
                    : null,
                child: const Text("connect ikonewka"),
              ),
              Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
              ...[
                for (var device in _devices)
                  TextButton(
                      onPressed: () async {
                        await _bluetoothClassicPlugin.connect(
                            device.address, defaultUuid);
                        setState(() {
                          _discoveredDevices = [];
                          _devices = [];
                        });
                      },
                      child: Text(device.name ?? device.address))
              ],
              TextButton(
                onPressed: _scan,
                child: Text(_scanning ? "Stop Scan" : "Start Scan"),
              ),
              ...[
                for (var device in _discoveredDevices)
                  Text(device.name ?? device.address)
              ],
              Text("Received data: ${String.fromCharCodes(_data)}"),
            ],
          ),
        ),
      ),
    );
  }
}
