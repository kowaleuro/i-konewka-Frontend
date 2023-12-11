import 'package:flutter/material.dart';
import 'package:i_konewka_app/core/RequestHandler.dart';
import 'package:i_konewka_app/screens/HomeScreen.dart';
import 'package:i_konewka_app/screens/elements/CustomButton.dart';
import 'package:i_konewka_app/screens/elements/CustomTextFormField.dart';

import '../main.dart';
import 'elements/Bar.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  static const routeName = '/LoginScreen';

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen>{

  final _formLoginKey = GlobalKey<FormState>();
  late String _email = '';
  late String _password = '';

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
              key: _formLoginKey,
              child: Column(
                children: <Widget>[
                  CustomTextFormField(
                    label: 'Email',
                    hintText: 'Provide email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val){
                      if (val!.isEmpty){
                        return 'Email is empty!';
                      }
                      return null;
                    },
                    onChanged: (val){
                      _email = val;
                    }),
                  CustomTextFormField(
                      label: 'Password',
                      hintText: 'Provide password',
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val){
                        if (val!.isEmpty){
                          return 'Password is empty!';
                        }
                        return null;
                      },
                      onChanged: (val){
                        _password = val;
                      }),
                  CustomButton(
                    onPressed: () {
                      if (_formLoginKey.currentState!.validate()){
                        _login();
                      }
                    },
                    height: 50,
                    width: size.width/2,
                    fontSize: 30,
                    textButton: 'Login'
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  void _login() async{
    RequestHandler requestHandler = RequestHandler();
    bool result = (await requestHandler.login(_email,_password));
    if (result == true){
      navigatorKey.currentState?.pushNamed(HomeScreen.routeName);
    }
  }
}

