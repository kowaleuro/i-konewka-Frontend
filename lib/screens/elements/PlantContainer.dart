import 'dart:typed_data';

import 'package:flutter/material.dart';
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
  });

  final double height;
  final double width;
  final double fontSize;
  final String? name;
  final Uint8List image;
  final IconData icon;
  final colorWhite = Colors.white;
  final colorGreen = Colors.green;

  @override
  State<StatefulWidget> createState() => _PlantContainerState();
}

class _PlantContainerState extends State<PlantContainer>{

  @override
  void initState() {
    super.initState();
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
                Flexible(child: Text(widget.name!,style: TextStyle(fontSize: widget.fontSize),)),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(widget.icon),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: (){
        Alert(
            type:AlertType.warning,
            style:CustomAlertStyle.alertStyle,
            context: context,
            title: "Do you want to start watering?",
            desc: "Watch out! If you will press START, water will begin to flow.",
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
                onPressed: (){
                  Navigator.pop(context);
                  var popUp = CustomLoadingPopUp(context: context);
                  popUp.show();
                  // TODO: implement blueetooh-watering and uncomment dismiss
                  // popUp.dismiss();
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
        ).show();},
      onLongPress: (){navigatorKey.currentState?.pushNamed(EditPlantScreen.routeName);},
    );
  }
}