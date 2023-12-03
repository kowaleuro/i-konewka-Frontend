import 'package:flutter/material.dart';
import 'package:i_konewka_app/screens/AddPlantScreen.dart';
import 'package:i_konewka_app/screens/elements/PlantContainer.dart';

import '../main.dart';
import 'elements/Bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Bar(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            PlantContainer(height: 100, width: 100, fontSize: 28, name: "fdfdfdfdfdfdf", icon: Icons.sentiment_very_satisfied),
            PlantContainer(height: 100, width: 100, fontSize: 28, name: "Kwiatek", icon: Icons.sentiment_very_satisfied)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){navigatorKey.currentState?.pushNamed(AddPlantScreen.routeName);},
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),

      ),
    );
  }
}