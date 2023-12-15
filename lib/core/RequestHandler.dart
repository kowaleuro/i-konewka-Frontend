
import 'dart:convert';

import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:i_konewka_app/models/plant.dart';

import 'ApiHelper.dart';

class RequestHandler {

  final api = ApiHelper('https://ikonewka.panyre.pl');

  Future<bool> login(String email, String password) async {
    try {
      var postData = {'email': email, 'password': password};
      var responsePost = await api.post('/auth/login', postData);
      var token = responsePost['message'];
      await FlutterSessionJwt.saveToken(token);
      return true;
    }catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password, String nick, String wateringHour) async {
    try {
      var postData = {'email': email, 'password': password, 'nick': nick, 'watering_hour': wateringHour};
      var responsePost = await api.post('/auth/register', postData);
      print('Register Response: $responsePost');
      return true;
    }catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Plant>?> getPlants() async {
    try {
      var response = await api.get('/api/user_flowers');
      print('Register Response: $response');
      var parsedPlants = response["user_flowers"] as List;
      List<Plant> plantList = parsedPlants.map((tagJson) => Plant.fromJson(tagJson))
          .toList();
      return plantList;
    }catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> addPlant(String name, String image, int fid) async {
    try {
      var postData = {'name': name, 'image': image};
      var response = await api.postAuth('/api/flower/',postData);
      print('Register Response: $response');
      return true;
    }catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> editPlant(String name, String image, int fid) async {
    try {
      var postData = {'name': name, 'image': image};
      var parameters = {'fid': fid};
      var response = await api.postAuthParams('/api/flower/',postData,parameters);
      print('Register Response: $response');
      return true;
    }catch (e) {
      print(e);
      return false;
    }
  }


}