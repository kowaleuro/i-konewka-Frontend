import 'package:flutter/material.dart';
import 'package:i_konewka_app/screens/elements/PlantImage.dart';

class PlantContainer extends StatefulWidget {

  const PlantContainer({
    super.key,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.name,
    required this.icon,
  });

  final double height;
  final double width;
  final double fontSize;
  final String name;
  // final Image image;
  final IconData icon;
  final colorWhite = Colors.white;
  final colorGreen = Colors.green;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() => _PlantContainerState();
}

class _PlantContainerState extends State<PlantContainer>{
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Padding(
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
                child: PlantImage(image: Image.asset('assets/images/plant.jpg'), radius: 50,),
              ),
              Flexible(child: Text(widget.name,style: TextStyle(fontSize: widget.fontSize),)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(widget.icon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}