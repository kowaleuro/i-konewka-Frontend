import 'package:flutter/material.dart';
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
  late List<bool> _wateringDaysList = List<bool>.filled(7, false);
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const Bar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: size.height/4),
            child: Center(
              child: Form(
                key: _formAddPlantKey,
                child: Column(
                  children: <Widget>[
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
                    CustomToggleButtons(),
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
}

