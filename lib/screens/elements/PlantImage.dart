import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantImage extends StatelessWidget {
  const PlantImage(
      {
        super.key,
        required this.radius,
        required this.image,
      });

  final double radius;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          'assets/images/plant.jpg'),
        fit: BoxFit.fill,),
        shape: BoxShape.circle,
      )
    );
  }

}