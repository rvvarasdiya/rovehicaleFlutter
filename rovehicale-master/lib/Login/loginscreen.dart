import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rovehiclefinal/ui/Buttons/gradient_button.dart';
import 'package:rovehiclefinal/ui/Buttons/roundedButton.dart';
import 'package:rovehiclefinal/ui/Buttons/textButton.dart';
import 'package:rovehiclefinal/ui/TextFields/inputField.dart';
import 'package:rovehiclefinal/ui/login_background.dart';
import 'package:rovehiclefinal/ui/theme/style.dart';
import 'package:rovehiclefinal/services/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  BuildContext context;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool autovalidate = false;
  Validations validations = new Validations();
  static String _email;
  static String _password;
  String url;
  SharedPreferences prefs;
  String button="";


  //Function
//--------------------------------
  Future init()
  async {
    prefs=await SharedPreferences.getInstance();
    if(prefs.getString("id")!=null)
    {
      Navigator.of(context).pushReplacementNamed("/HomePage");

    }
  }



  @override
  void initState (){
    super.initState();
    setState(() {
      button="Sign In";
    });
    init();


  }

  loaddata() async
  {
    var response=await http.get(url);
    debugPrint(url);
    if(response.statusCode==200)
    {

      String data=response.body;
      var data1=json.decode(data);

      debugPrint(data1[0]["result"]);
      if(data1[0]['result']=="false")
      {
        Navigator.pop(context);
        SnackBar snackBar=new SnackBar(content: new Text("Enter the Valid Username or Password"),);
        _scaffoldKey.currentState.showSnackBar(snackBar);

      }
      else
      {
        //showSuccess(context, "Success", Icons.check);


        prefs.setString("id", data1[0]['user_id']);
        // hideProgress(context);

//                  SnackBar snackBar=new SnackBar(content: new Text("dnjdcn"),);
//                  _scaffoldKey.currentState.showSnackBar(snackBar);
//


        Navigator.pop(context);
       Navigator.of(context).pushReplacementNamed("/HomePage");

      }
    }
    else
    {
      Navigator.pop(context);
      SnackBar snackBar=new SnackBar(content: new Text("Some thing is wrong"),);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      debugPrint("some thig is wrong");
      setState(() {
        button="Sign In";
      });
    }
  }
  _onPressed() {
    print("button clicked");
  }

  onPressed(String routeName) {

    Navigator.of(context).pushNamed(routeName);


  }



  //--------------------------------


  showProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(

          ),
        ));
  }
  //--------------------------------

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }


  //--------------------------------
  void _handleSubmitted() {
    final FormState form = formKey.currentState;

    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();

      // Navigator.pushNamed(context, "/HomePage");
      url="http://manishvvasaniya.000webhostapp.com/rovehicle/login.php?username=$_email&password=$_password";
      debugPrint(url);
      showProgress(context);
      loaddata();

      setState(() {
        button="Loading....";
      });
    }
  }


  //function over





  @override
  Widget build(BuildContext context) {
    var deviceSize=MediaQuery.of(context).size;
    this.context = context;

    var logincardlayou= new Card(
       elevation: 3.0,
        color: Colors.green.shade50,
shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child:  new SingleChildScrollView(
            controller: scrollController,

            padding: new EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                new Container(

                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Center(
                          child: new Image(
                            image: AssetImage("assets/logo.png"),
                            width: (deviceSize.width < 500)
                                ? 200.0
                                : (deviceSize.width / 4) + 12.0,
                            height: deviceSize.height / 4 + 120,
                          ))
                    ],
                  ),
                ),
                new Container(

                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Form(
                        key: formKey,
                        autovalidate: autovalidate,
                        child: new Column(
                          children: <Widget>[
                            new InputField(
                                hintText: "Email Id or Contact No",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                textStyle: textStyle,
                                textFieldColor: textFieldColor,
                                icon: Icons.person,
                                iconColor: Colors.green.shade800,
                                bottomMargin: 20.0,

                                validateFunction: (String value){
                                  if(value.isEmpty)
                                  {
                                    return "Please enter the userID";
                                  }else
                                  {
                                    return null;
                                  }
                                },
                                onSaved: (String email) {
                                  _email=email;
                                }),
                            new InputField(
                                hintText: "Password",
                                obscureText: true,
                                textInputType: TextInputType.text,
                                textStyle: textStyle,
                                textFieldColor: textFieldColor,
                                icon: Icons.lock_open,
                                iconColor: Colors.green.shade800,
                                bottomMargin: 30.0,
                            validateFunction:
                            validations.validatePassword,
                                onSaved: (String password) {
                                  _password=password;
                                }),
                            new GradientButton(

                              onPressed: _handleSubmitted,
                              text: "Login",

                            ),
                          ],
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new TextButton(
                              buttonName: "Create Account",

                           onPressed: () => onPressed("/SignUp"),
                              buttonTextStyle: buttonTextStyle),
                          new TextButton(
                              buttonName: "Forgot Password?",
                            onPressed: ()=>onPressed("/forgotPage"),
                              buttonTextStyle: buttonTextStyle)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );

    var LoginWidgets=Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[


            SizedBox(
              height: deviceSize.height-30,
              width: deviceSize.width * 0.95,
              child:logincardlayou),



            // new Pashdding(
            //   padding: const EdgeInsets.only(top: 30.0),
            //   child: new Text(
            //     ISRData.forgot_password,
            //     style: new TextStyle(fontWeight: FontWeight.normal),
            //   ),
            // )
          ],
        ),
      ),
    );

    return Scaffold(
    key: _scaffoldKey,
    backgroundColor: Colors.green.shade100,
    body: Stack(
    fit: StackFit.expand,
    children: <Widget>[LoginBackground(),  LoginWidgets,
    ],
    ),
    );
  }
}

