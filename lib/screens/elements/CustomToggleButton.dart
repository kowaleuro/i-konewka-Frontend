import 'package:flutter/material.dart';
import 'package:i_konewka_app/screens/elements/PlantImage.dart';

class CustomToggleButtons extends StatefulWidget {

  final _wateringDaysList =  List.generate(7, (_)=>false );

  CustomToggleButtons({super.key});

  @override
  State<StatefulWidget> createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons>{
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
          left:size.width*0.10,
          right:size.width*0.10,
          bottom: size.width*0.10
      ),
      child: ToggleButtons(
          constraints: BoxConstraints.loose(Size.infinite),
          isSelected: widget._wateringDaysList,
          borderRadius: BorderRadius.circular(10),
          fillColor: Colors.green,
          borderColor: Colors.green,
          borderWidth: 3,
          children: const <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Mon',style: TextStyle(color: Colors.white,fontSize: 14),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Tue',style: TextStyle(color: Colors.white,fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Wed',style: TextStyle(color: Colors.white,fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Thu',style: TextStyle(color: Colors.white,fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Fri',style: TextStyle(color: Colors.white,fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sat',style: TextStyle(color: Colors.white,fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sun',style: TextStyle(color: Colors.white,fontSize: 14)),
            ),
          ],
          onPressed: (int index) {
            setState(() {
              widget._wateringDaysList[index] = !widget._wateringDaysList[index];
            });
          }
      ),
    );
  }
}