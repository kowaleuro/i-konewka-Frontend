import 'package:flutter/material.dart';
import 'package:i_konewka_app/main.dart';
import 'package:i_konewka_app/screens/AddPlantScreen.dart';
import 'package:i_konewka_app/screens/EditPlantScreen.dart';
import 'package:i_konewka_app/screens/HomeScreen.dart';
import 'package:i_konewka_app/screens/LoginScreen.dart';
import 'package:i_konewka_app/screens/RegisterScreen.dart';
import 'package:i_konewka_app/screens/StartScreen.dart';
import 'package:i_konewka_app/screens/MainBtPage.dart';
import 'package:i_konewka_app/screens/DiscoveryPage.dart';
import 'package:i_konewka_app/screens/SelectBondedDevicePage.dart';
import 'package:i_konewka_app/AppTheme.dart';
import 'package:i_konewka_app/screens/elements/Bar.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:i_konewka_app/screens/elements/StatefulBar.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final String title = 'I-Konewka';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: AppTheme.theme,
      home: Scaffold(
        appBar: const BluetoothStatusWidgetBar(),
        body: StartScreen(title: title,),
      ),
      navigatorKey: navigatorKey,
      routes:{
        StartScreen.routeName: (context) =>
             StartScreen(title: title),
        LoginScreen.routeName: (context) =>
            const LoginScreen(),
        HomeScreen.routeName: (context) =>
            const HomeScreen(),
        RegisterScreen.routeName: (context) =>
            const RegisterScreen(),
        AddPlantScreen.routeName: (context) =>
            const AddPlantScreen(),
        EditPlantScreen.routeName: (context) =>
            const EditPlantScreen(startName: null,plantId: null,),
        MainBTDebugPage.routeName: (context) =>
             MainBTDebugPage(),
        SelectBondedDevicePage.routeName: (context) =>
            const SelectBondedDevicePage(),
        DiscoveryPage.routeName: (context) =>
            const DiscoveryPage(),
      }
    );
  }
}

