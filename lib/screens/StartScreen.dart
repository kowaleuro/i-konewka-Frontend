import 'package:flutter/material.dart';
import 'package:i_konewka_app/screens/LoginScreen.dart';
import 'package:i_konewka_app/screens/elements/CustomButton.dart';

import '../main.dart';

class StartScreen extends StatelessWidget {

  const StartScreen({super.key, required this.title});

  final String title;

  static const routeName = '/StartScreen';

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: size.width*0.10,
          children:[
            CustomButton(fontSize: 30,height: 50,width: size.width/1.5,onPressed: (){navigatorKey.currentState?.pushNamed(LoginScreen.routeName);} ,textButton: 'Login'),
            CustomButton(fontSize: 30,height: 50,width: size.width/1.5,onPressed: (){} ,textButton: 'Register',),
          ],
        )
      );
  }
}