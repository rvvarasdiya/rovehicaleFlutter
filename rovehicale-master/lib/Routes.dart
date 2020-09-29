//import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rovehiclefinal/Forgot/ForgotPassword.dart';
import 'package:rovehiclefinal/Forgot/changepass.dart';
import 'package:rovehiclefinal/Home/EditProfile.dart';
import 'package:rovehiclefinal/Home/Person.dart';
import 'package:rovehiclefinal/Login/loginscreen.dart';
import 'package:rovehiclefinal/Home/MyHome.dart';

import 'package:rovehiclefinal/singup/SignUp.dart';
import 'package:rovehiclefinal/temp.dart';


class Routes {

  var routes = <String, WidgetBuilder>{
    "/SignUp": (BuildContext context) => new SignUp(),
    "/HomePage": (BuildContext context) => new MyHome(),
    "/forgotPage":(BuildContext context) => new ForgotPassword(),
//    "/verify":(BuildContext context) => new verify(),
    "/change":(BuildContext context)=>new Changepass(),
    "/login":(BuildContext context)=>new LoginScreen(),
    "/editprofile":(BuildContext context)=>new EditProfile(),
    "/profile":(BuildContext context)=>new Person()
  };

  Routes() {

    runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ROvehicle",
      onGenerateTitle: (BuildContext contex)=>"ROvehicle",
      home: new test(),
      theme: new ThemeData(
        accentColor: Colors.green.shade900,
        primaryColor: Colors.green.shade800,
        primaryColorDark: Colors.green.shade800,
        indicatorColor: Colors.green.shade800,
        inputDecorationTheme: InputDecorationTheme(

       )

      ),
      routes: routes,
    ));
  }
}
//void call () async
//{
//  try {
//    constant.cameras = await availableCameras();
//    debugPrint(constant.cameras.toString());
//  } on CameraException catch (e) {
//    //logError(e.code, e.description);
//  }
//}