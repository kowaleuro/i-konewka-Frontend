import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:i_konewka_app/core/BluetoothHelper.dart';
import 'package:i_konewka_app/screens/EditPlantScreen.dart';
import 'package:i_konewka_app/screens/elements/AlertStyle.dart';
import 'package:i_konewka_app/screens/elements/CustomLoadingPopUp.dart';
import 'package:i_konewka_app/screens/elements/PlantImage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../main.dart';

class PlantContainer extends StatefulWidget {

  const PlantContainer({
    super.key,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.name,
    required this.icon,
    required this.image,
    required this.water,
  });

  final double height;
  final double width;
  final double fontSize;
  final String? name;
  final Uint8List image;
  final IconData icon;
  final String water;
  final colorWhite = Colors.white;
  final colorGreen = Colors.green;

  @override
  State<StatefulWidget> createState() => _PlantContainerState();
}

class _PlantContainerState extends State<PlantContainer>{
  BluetoothHelper helper = BluetoothHelper.instance;
  bool isConnected = false;
  BluetoothConnection? ikonewka_connection;

  @override
  void initState() {
    super.initState();
    helper.returnConnection().then((connection) {ikonewka_connection = connection;});
    helper.verifyIkonewkaConnection(ikonewka_connection!).then((bool _isConnected) {isConnected = _isConnected;});
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
                  child: PlantImage(image: widget.image, radius: 50,),
                ),
                Flexible(child: Text(widget.name!, style: TextStyle(fontSize: widget.fontSize),)),
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
        if (isConnected) {
          // Display alert for watering
          Alert(
            type: AlertType.warning,
            style: CustomAlertStyle.alertStyle,
            context: context,
            title: "Do you want to start watering?",
            desc: "Watch out! If you press START, water will begin to flow.",
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.green,
                child: const Text(
                  "CANCEL",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, fontSize: 20),
                ),
              ),
              DialogButton(
                onPressed: () {
                  Navigator.pop(context);
                  var popUp = CustomLoadingPopUp(context: context);
                  popUp.show();
                  // TODO: implement blueetooh-watering and uncomment dismiss
                  helper.sendWater(ikonewka_connection!, widget.water);
                  popUp.dismiss();
                },
                color: Colors.green,
                child: const Text(
                  "START",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, fontSize: 20),
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
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
                child: const Text(
                  "OK",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ).show();
        }
      },
      onLongPress: () {
        navigatorKey.currentState?.pushNamed(EditPlantScreen.routeName);
      },
    );
  }
}