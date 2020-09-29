import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rovehiclefinal/ui/login_background.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Stack(
children: <Widget>[
  LoginBackground()
],

      ),
    );
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}