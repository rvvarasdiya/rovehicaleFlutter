import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  SharedPreferences prefs;


  Future init()
  async {
    prefs=await SharedPreferences.getInstance();
    if(prefs.getString("id")!=null)
    {
      Navigator.of(context).pushReplacementNamed("/HomePage");

    }
    else
      { 
        Navigator.of(context).pushReplacementNamed("/login");
      }
  }
  @override
  void initState (){
    super.initState();

    init();


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

    );
  }
}
