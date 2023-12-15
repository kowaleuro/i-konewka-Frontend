import 'package:flutter/material.dart';
import 'package:i_konewka_app/core/RequestHandler.dart';
import 'package:i_konewka_app/models/plant.dart';
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

  Future<List<Plant>?>? plants;

  @override
  void initState() {
    super.initState();
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding?.addPostFrameCallback((callback) {
      if (ModalRoute
          .of(context)
          ?.settings
          .arguments != null){
        RequestHandler requestHandler = RequestHandler();
        var plantsData = requestHandler.getPlants();
        setState(() {
          plants = plantsData;
        });
      }
    });
  }

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Bar(),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<List<Plant>?>(
            future: plants,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return ListView.separated(
                    shrinkWrap: true,
                    reverse: false,
                    itemBuilder: (context, index) =>
                        PlantContainer(height: 100, width: 100, fontSize: 28, name:  snapshot.data?[index].name, icon: Icons.sentiment_very_satisfied),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (BuildContext context, int index) =>  const SizedBox(height:0)
                );

              }else{
                return const Text('');
              }
            }
          )
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