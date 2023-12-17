import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_konewka_app/screens/HomeScreen.dart';
import 'package:i_konewka_app/screens/elements/CameraPage.dart';
import 'package:i_konewka_app/screens/elements/CustomButton.dart';
import 'package:i_konewka_app/screens/elements/CustomTextFormField.dart';
import 'package:i_konewka_app/screens/elements/CustomToggleButton.dart';

import '../core/RequestHandler.dart';
import '../main.dart';
import 'elements/Bar.dart';

class EditPlantScreen extends StatefulWidget {

  const EditPlantScreen({super.key,required this.startName,required this.plantId});

  static const routeName = '/EditPlantScreen';

  final startName;
  final plantId;

  @override
  State<StatefulWidget> createState() {
    return _EditPlantScreen();
  }
}

class _EditPlantScreen extends State<EditPlantScreen>{

  @override
  void initState() {
    super.initState();
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding?.addPostFrameCallback((callback) {
      RequestHandler requestHandler = RequestHandler();
      // var plantsData = requestHandler.getPlants();
      setState(() {
        // plants = plantsData;
      });
    });
  }

  final _formEditPlantKey = GlobalKey<FormState>();
  late String _name = '';
  late String _health = '';
  late XFile? _imgFile;
  late int _waterMl;
  late List<bool> _wateringDaysList = List.generate(7, (_)=>false );
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const Bar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: size.height/15),
            child: Center(
              child: Form(
                key: _formEditPlantKey,
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
                        initialValue: widget.startName,
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
                    CustomTextFormField(
                        label: 'Watering',
                        hintText: 'Amount of water for watering',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (val){
                          if (val!.isEmpty){
                            return 'Watering is empty!';
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
                          if (_formEditPlantKey.currentState!.validate()) {Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);}
                        },
                        height: 50,
                        width: size.width/2,
                        fontSize: 30,
                        textButton: 'Confirm'
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

