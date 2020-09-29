import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:rovehiclefinal/Login/loginscreen.dart';
import 'package:rovehiclefinal/services/validations.dart';
import 'package:rovehiclefinal/ui/Buttons/gradient_button.dart';
import 'package:rovehiclefinal/ui/Buttons/roundedButton.dart';
import 'package:rovehiclefinal/ui/TextFields/inputField.dart';
import 'package:rovehiclefinal/ui/login_background.dart';
import 'package:rovehiclefinal/ui/theme/style.dart';

class Changepass extends StatefulWidget {

  String phonno;
  Changepass({Key key,this.phonno}):super(key:key);
  @override
  _ChangepassState createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {
  GlobalKey<FormState> _forgot=new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey=new GlobalKey<ScaffoldState>();
  Validations _validations = new Validations();
  String password1;
  String password2;
  bool autovalidate = false;
  void _handleSubmitted() {
    final FormState form = _forgot.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      if(password2==password1)
      {

//


        loaddata();
      }
      else
      {
        SnackBar snackBar=new SnackBar(content: Text("Password Does not Match"));
        globalKey.currentState.showSnackBar(snackBar);
      }

      //  Navigator.pushNamed(context, "/Home");
    }
  }
  @override
  Widget build(BuildContext context) {
    var data;

    var screenSize=MediaQuery.of(context).size;
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Forgot Password"),
        ),
        key: globalKey,
        body: new Stack(
              children: <Widget>[
               new LoginBackground(),
               new Container(
                   height: MediaQuery.of(context).size.height,
                   child:  new Center(
                     child: new SingleChildScrollView(
                       child: new Card(
                         margin: EdgeInsets.all(10.0),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                         child:new Container(
                           padding: EdgeInsets.fromLTRB(16.0, 65.0, 16.0, 40.0),
                           child:  new Form(
                             key: _forgot,
                             autovalidate: autovalidate,
                             child: new Column(
                               children: <Widget>[

                                 new InputField(
                                     hintText: "Enter The New Password",
                                     obscureText: true,
                                     textInputType: TextInputType.text,
                                     textStyle: textStyle,
                                     textFieldColor: textFieldColor,
                                     icon: Icons.lock_open,
                                     iconColor: Colors.green.shade800,
                                     bottomMargin: 25.0,
                                     validateFunction: _validations.validatePassword,
                                     onSaved: (String password) {
                                       password1=password;
                                     }),
                                 new InputField(
                                     hintText: "Conform Password",
                                     obscureText: true,
                                     textInputType: TextInputType.text,
                                     textStyle: textStyle,
                                     textFieldColor: textFieldColor,
                                     icon: Icons.lock_open,
                                     iconColor: Colors.green.shade800,
                                     bottomMargin: 25.0,
                                     validateFunction:_validations.validatePassword,
                                     onSaved: (String password) {
                                       password2=password;

                                     }),

                                 new GradientButton(

                                   onPressed:_handleSubmitted,
                                   text: "Continue",

                                 )
                               ],

                             ),),
                         )
                       ),
                     ),
                   )
               )
              ],

            ));
  }



  void loaddata() async {


    showProgress(context);
    String url="http://manishvvasaniya.000webhostapp.com/rovehicle/forget.php?username="+widget.phonno+"&password="+password2;
    var response=await http.get(url);
    debugPrint(url);
    if(response.statusCode==200) {
      String data = response.body;
      var data1 = json.decode(data);
      if(data1[0]["result"]=="success")
      {
       Navigator.of(context).pop();
       Fluttertoast.showToast(
           msg: "Password Successfully Changed",
           toastLength: Toast.LENGTH_LONG,

           timeInSecForIos: 1
       );
        var ru=new MaterialPageRoute(builder: (context)=>new LoginScreen());
        Navigator.of(context).pushAndRemoveUntil(ru,(Route<dynamic> route) => false);
      }
      else
      {
        Navigator.of(context).pop();
        SnackBar snackBar=new SnackBar(content:new Text("Some Thing Wrong") );
        globalKey.currentState.showSnackBar(snackBar);
      }
    }else
    {

    }

  }
  showProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(

          ),
        ));
  }
}
