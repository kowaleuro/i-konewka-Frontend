
import 'dart:convert';

import 'package:flutter_session_jwt/flutter_session_jwt.dart';

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

  Future<bool> getPlants() async {
    try {
      var responsePost = await api.get('/api/user_flowers');
      print('Register Response: $responsePost');
      return true;
    }catch (e) {
      print(e);
      return false;
    }
  }


}