import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_konewka_app/screens/elements/CameraPage.dart';
import 'package:i_konewka_app/screens/elements/CustomButton.dart';
import 'package:i_konewka_app/screens/elements/CustomTextFormField.dart';
import 'package:i_konewka_app/screens/elements/CustomToggleButton.dart';

import '../main.dart';
import 'elements/Bar.dart';

class AddPlantScreen extends StatefulWidget {

  const AddPlantScreen({super.key});

  static const routeName = '/AddPlantScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddPlantScreen();
  }
}

class _AddPlantScreen extends State<AddPlantScreen>{

  final _formAddPlantKey = GlobalKey<FormState>();
  late String _name = '';
  late String _health = '';
  late XFile? _imgFile;
  late List<bool> _wateringDaysList = List.generate(7, (_)=>false );
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const Bar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: size.height/7),
            child: Center(
              child: Form(
                key: _formAddPlantKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left:size.width*0.10,
                          right:size.width*0.10,
                          bottom: size.width*0.10
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(size.width/2,90),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await availableCameras().then((value) => _navigateAndGetData(context,value));
                        },
                        child: Text("Take a Picture",
                          style:GoogleFonts.nunitoSans(
                              textStyle: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 22
                              )
                          ),
                        ),
                      ),
                    ),
                    CustomTextFormField(
                        label: 'Name',
                        hintText: 'Provide name of a plant',
                        keyboardType: TextInputType.text,
                        validator: (val){
                          if (val!.isEmpty){
                            return 'Name is empty!';
                          }
                          return null;
                        },
                        onChanged: (val){
                          _name = val;
                        }),
                    CustomTextFormField(
                        label: 'Health',
                        hintText: 'Provide health of a plant',
                        keyboardType: TextInputType.text,
                        validator: (val){
                          if (val!.isEmpty){
                            return 'Health is empty!';
                          }
                          return null;
                        },
                        onChanged: (val){
                          _health = val;
                        }),
                    CustomToggleButtons(isSelected: _wateringDaysList,onPressed: (int index)
                    {
                      setState(() {
                        _wateringDaysList[index] = !_wateringDaysList[index];
                      });
                    }),
                    CustomButton(
                        onPressed: () {
                          if (_formAddPlantKey.currentState!.validate()) {Navigator.of(context).pop();}
                        },
                        height: 50,
                        width: size.width/2,
                        fontSize: 30,
                        textButton: 'Create'
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
  Future<void> _navigateAndGetData(BuildContext context,List<CameraDescription> cameras) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage(cameras: cameras)),
    );

    if (!mounted) return;

    _imgFile = result;
  }
}

