import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CameraPage.dart';

class CameraComponent extends StatefulWidget{
  const CameraComponent({super.key});

  @override
  State<CameraComponent> createState() => _CameraComponent();
}

class _CameraComponent extends State<CameraComponent> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    onPressed: () async {
      await availableCameras().then((value) => Navigator.push(context,
        MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
    },
    child: const Text("Take a Picture"),
    );
  }
  
}