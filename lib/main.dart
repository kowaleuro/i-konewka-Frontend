import 'package:flutter/material.dart';
import 'package:i_konewka_app/App.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i_konewka_app/core/BluetoothHelper.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final storage = new FlutterSecureStorage();
final device = BluetoothHelper.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
