import 'dart:typed_data';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:i_konewka_app/screens/EditPlantScreen.dart';
import 'package:i_konewka_app/screens/elements/AlertStyle.dart';
import 'package:i_konewka_app/screens/elements/CustomLoadingPopUp.dart';
import 'package:i_konewka_app/screens/elements/PlantImage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../main.dart';

class PlantContainer extends StatefulWidget {
  const PlantContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.fontSize,
      required this.name,
      required this.icon,
      required this.image,
      required this.plantId,
      required this.waterAmount});

  final double height;
  final double width;
  final double fontSize;
  final String? name;
  final Uint8List image;
  final IconData icon;
  final colorWhite = Colors.white;
  final colorGreen = Colors.green;
  final int? plantId;
  final int waterAmount;

  @override
  State<StatefulWidget> createState() => _PlantContainerState();
}

class _PlantContainerState extends State<PlantContainer> {
  final _bluetoothClassicPlugin = BluetoothClassic();
  bool? connectionUp = true;
  final String deviceAddress = 'B4:E6:2D:86:FC:4F';
  final String defaultUuid = "00001101-0000-1000-8000-00805f9b34fb";
  // int _deviceStatus = Device.disconnected;

  @override
  void initState() {
    super.initState();
    initConnection();
    // _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
    //   print('device state changed: $_deviceStatus -> $event');
    //   setState(() {
    //     _deviceStatus = event;
    //   });
    // });
  }

  Future<void> initConnection() async {
    // await _bluetoothClassicPlugin.initPermissions();
    await _bluetoothClassicPlugin
        .connect(deviceAddress, defaultUuid)
        .then((bool result) {
      print('connection result in plant container: $result');
      setState(() {
        connectionUp = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: widget.width,
            height: widget.height,
            color: widget.colorGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PlantImage(
                    image: widget.image,
                    radius: 50,
                  ),
                ),
                Flexible(
                    child: Text(
                  widget.name!,
                  style: TextStyle(fontSize: widget.fontSize),
                )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(widget.icon),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        if (connectionUp!) {
          Alert(
            type: AlertType.warning,
            style: CustomAlertStyle.alertStyle,
            context: context,
            title: "Do you want to start watering?",
            desc:
                "Watch out! If you will press START, water will begin to flow.",
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.green,
                child: const Text(
                  "CANCEL",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
              DialogButton(
                onPressed: () async {
                  Navigator.pop(context);
                  var popUp = CustomLoadingPopUp(context: context);
                  popUp.show();
                  _bluetoothClassicPlugin.write("water ${widget.waterAmount}");
                  popUp.dismiss();
                },
                color: Colors.green,
                child: const Text(
                  "START",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              )
            ],
          ).show();
        } else {
          // Display alert for not connected
          Alert(
            type: AlertType.error,
            style: CustomAlertStyle.alertStyle,
            context: context,
            title: "Cannot water the plant",
            desc: "Please make sure the device is connected before watering.",
            buttons: [
              DialogButton(
                onPressed: () {
                  initConnection();
                  Navigator.pop(context);
                },
                color: Colors.red,
                child: const Text(
                  "OK, redo connection",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ],
          ).show();
        }
      },
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPlantScreen(
                      plantId: widget.plantId,
                      startName: widget.name,
                    )));
      },
    );
  }
}
