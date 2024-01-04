import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:i_konewka_app/core/BluetoothHelper.dart';

import './DiscoveryPage.dart';
import './SelectBondedDevicePage.dart';
import 'elements/StatefulBar.dart';

// import './helpers/LineChart.dart';

class MainBTDebugPage extends StatefulWidget {
  static const routeName = '/MainPage';
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainBTDebugPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothHelper bluetoothHelper = BluetoothHelper.instance;
  BluetoothConnection? connection;
  bool _ikonewkaConnection = false;
  bool _waterAbility = false;
  BluetoothBondState _ikonewkaBonded = BluetoothBondState.unknown;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  bool _autoAcceptPairingRequests = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
      bluetoothHelper.bondDevice().then((bool _bonded) {
        setState(() {
          print(
              'ikonewka bonding status: $_bonded, bluetooth bond state: ${bluetoothHelper.bondState}');
          _ikonewkaBonded = bluetoothHelper.bondState;
        });
      });
      print('Init ikonewka connection in initState()');
      bluetoothHelper
          .returnConnection()
          .then((BluetoothConnection _connection) {
        print(
            'Connection to ikonewka default: ${bluetoothHelper.address}:${_connection.isConnected}');
        connection = _connection;
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BluetoothStatusWidgetBar(),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(title: const Text('General')),
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: _bluetoothState.isEnabled,
              activeColor: Colors.greenAccent,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: const Text('Bluetooth status'),
              subtitle: Text(_bluetoothState.toString()),
              trailing: ElevatedButton(
                child: const Text('Settings'),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            ListTile(
              title: const Text('Local adapter address'),
              subtitle: Text(_address),
            ),
            ListTile(
              title: const Text('Local adapter name'),
              subtitle: Text(_name),
              onLongPress: null,
            ),
            ListTile(
              title: _discoverableTimeoutSecondsLeft == 0
                  ? const Text("Discoverable")
                  : Text(
                      "Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _discoverableTimeoutSecondsLeft != 0,
                    onChanged: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      print('Discoverable requested');
                      final int timeout = (await FlutterBluetoothSerial.instance
                          .requestDiscoverable(60))!;
                      if (timeout < 0) {
                        print('Discoverable mode denied');
                      } else {
                        print(
                            'Discoverable mode acquired for $timeout seconds');
                      }
                      setState(() {
                        _discoverableTimeoutTimer?.cancel();
                        _discoverableTimeoutSecondsLeft = timeout;
                        _discoverableTimeoutTimer =
                            Timer.periodic(Duration(seconds: 1), (Timer timer) {
                          setState(() {
                            if (_discoverableTimeoutSecondsLeft < 0) {
                              FlutterBluetoothSerial.instance.isDiscoverable
                                  .then((isDiscoverable) {
                                if (isDiscoverable ?? false) {
                                  print("Discoverable after timeout");
                                  _discoverableTimeoutSecondsLeft += 1;
                                }
                              });
                              timer.cancel();
                              _discoverableTimeoutSecondsLeft = 0;
                            } else {
                              _discoverableTimeoutSecondsLeft -= 1;
                            }
                          });
                        });
                      });
                    },
                  )
                ],
              ),
            ),
            Divider(),
            // ListTile(title: const Text('Devices discovery and connection')),
            // SwitchListTile(
            //   title: const Text('Auto-try specific pin when pairing'),
            //   subtitle: const Text('Pin 1234'),
            //   value: _autoAcceptPairingRequests,
            //   onChanged: (bool value) {
            //     setState(() {
            //       _autoAcceptPairingRequests = value;
            //     });
            //     if (value) {
            //       FlutterBluetoothSerial.instance.setPairingRequestHandler(
            //               (BluetoothPairingRequest request) {
            //             print("Trying to auto-pair with Pin 1234");
            //             if (request.pairingVariant == PairingVariant.Pin) {
            //               return Future.value("1234");
            //             }
            //             return Future.value(null);
            //           });
            //     } else {
            //       FlutterBluetoothSerial.instance
            //           .setPairingRequestHandler(null);
            //     }
            //   },
            // ),
            ListTile(
              title: ElevatedButton(
                  child: const Text('Explore discovered devices'),
                  onPressed: () async {
                    final BluetoothDevice? selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DiscoveryPage();
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Discovery -> selected ' + selectedDevice.address);
                    } else {
                      print('Discovery -> no device selected');
                    }
                  }),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Connect to paired device'),
                onPressed: () async {
                  final BluetoothDevice? selectedDevice =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(checkAvailability: false);
                      },
                    ),
                  );

                  if (selectedDevice != null) {
                    print('Connect -> selected ' + selectedDevice.address);
                  } else {
                    print('Connect -> no device selected');
                  }
                },
              ),
            ),
            Divider(
              color: Colors.red,
            ),
            ListTile(
              title: const Text('DEBUG IKONEWKA BT'),
            ),
            ListTile(
              title: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white),
                  child: const Text('SEND CONNECT TO IKONEWKA'),
                  onPressed: () async {
                    var connection = await bluetoothHelper.returnConnection();
                    bluetoothHelper
                        .verifyIkonewkaConnection(connection)
                        .then((bool status) {
                      setState(() {
                        _ikonewkaConnection = status;
                        if (!_ikonewkaConnection) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(connection.isConnected
                                      ? 'Error occurred while sending \'connect,\''
                                      : 'Cannot connect to IKONEWKA'),
                                  content: Text(""),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else if (_ikonewkaConnection &&
                            connection.isConnected) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Received ok from IKONEWKA'),
                                  content: Text(""),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      });
                    });
                  }),
            ),
            ListTile(
              title: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white),
                  child: const Text('SEND WATER TO IKONEWKA'),
                  onPressed: () async {
                    var connection = await bluetoothHelper.returnConnection();
                    bluetoothHelper
                        .sendWater(connection, '123')
                        .then((bool status) {
                      setState(() {
                        _waterAbility = status;
                        if (!_waterAbility) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(connection.isConnected
                                      ? 'Error occurred while sending \'water,123\''
                                      : 'Cannot connect to IKONEWKA'),
                                  content: Text(""),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('No error from IKONEWKA'),
                                  content: Text(""),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      });
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
