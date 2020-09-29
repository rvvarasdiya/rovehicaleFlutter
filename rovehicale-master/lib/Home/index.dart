import 'dart:async';

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
const HomeScreen({ Key key }) : super(key: key);

@override
HomeScreenState createState() => new HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {

  String data = "";
  SharedPreferences preferences;

  getid()
  async {

    setState(() {
      data=preferences.getString("id");
      debugPrint(preferences.getString("id").toString());


    });
  }
  Future init()
  async {
    preferences=await SharedPreferences.getInstance();
    getid();

  }
  @override
  initState () {
    super.initState();
    // Add listeners to this class
    //debugPrint("wnfjbvhsbvhvh");
  init();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(body:new Center(child: new RaisedButton(onPressed: (){preferences.clear();Navigator.of(context).pushReplacementNamed("/login");
    ;},child: new Text("Logout"),),),
      
    );
  }
}