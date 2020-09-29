import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rovehiclefinal/Forgot/changepass.dart';
import 'package:rovehiclefinal/singup/SignUp2.dart';
import 'package:rovehiclefinal/ui/Buttons/gradient_button.dart';
import 'package:rovehiclefinal/ui/Buttons/roundedButton.dart';
import 'package:rovehiclefinal/ui/Buttons/textButton.dart';
import 'package:rovehiclefinal/ui/TextFields/inputField.dart';
import 'package:rovehiclefinal/ui/login_background.dart';
import 'package:rovehiclefinal/ui/theme/style.dart';
import 'package:rovehiclefinal/services/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgotPassword> {

  BuildContext context;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool autovalidate = false;
  Validations validations = new Validations();
  bool isenable=true;
  bool enable=false;
  String code;

  String url;

  String button="";

  String contectNo;
  final _random = new Random();
  String phoneno;
  String url1;

  String code1;

  //Function
//--------------------------------




  @override
  void initState (){
    super.initState();
    setState(() {
      button="Sign In";
    });



  }

  loaddata() async
  {
    var response=await http.get(url1);
    debugPrint(url1);
    if(response.statusCode==200)
    {


      String data=response.body;
      var data1=json.decode(data);

      debugPrint(data1[0]["result"]);
      if(data1[0]['result']=="false")
      {
        Navigator.of(context).pop();
        SnackBar snackBar=new SnackBar(content: new Text("This User Does Not Exists"),);
        _scaffoldKey.currentState.showSnackBar(snackBar);

      }
      else
      {
        debugPrint("hello");


        code=next(1000, 9999).toString();
        String msg="Your Verificatio Code is "+code.toString();

        var response1=await http.get("https://smsapi.engineeringtgr.com/send/?Mobile=9904436106&Password=MJENISH8&Message="+msg.toString()+"&To="+phoneno+"&Key=mjenibSa7JqF45A6XBGoz2Q1");
        if(response1.statusCode==200)
        {
          Navigator.of(context).pop();
          debugPrint(response1.body);
          debugPrint(phoneno);
          debugPrint(code);


          setState(() {

            isenable=false;
            enable=true;
          });

        }



      }
    }
    else
    {
      Navigator.of(context).pop();

      debugPrint("some thig is wrong");
    }
  }
  int next(int min, int max) => min + _random.nextInt(max - min);
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

    } else {
      form.save();

      // Navigator.pushNamed(context, "/HomePage");
      // url="http://manishvvasaniya.000webhostapp.com/rovehicle/login.php?username=$_email&password=$_password";
      showProgress(context);

      url1="http://manishvvasaniya.000webhostapp.com/rovehicle/checkphoneno.php?number="+phoneno;
      debugPrint(url1);
      loaddata();


//      setState(() {
//        enable=true;
//        isenable=false;
//      });
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

        padding: EdgeInsets.fromLTRB(16.0, 65.0, 16.0, 0.0),
        child: new Column(
          children: <Widget>[

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
                            hintText: "Enter Phone No",

                            obscureText: false,
                            textInputType: TextInputType.number,
                            textStyle: textStyle,
                            enable: isenable,
                            textFieldColor: textFieldColor,
                            icon: Icons.call,
                            iconColor: Colors.green.shade800,
                            bottomMargin: 3.0,
                            limit: 10,
                            validateFunction: (String value)
                            {
                              if(value.length==10)
                              {
                                return null;
                              }
                              else
                              {
                                return "Enter the valid phone no";
                              }
                            },


                            onSaved: (String number) {
                              phoneno=number;
                            }),
                        enable?new InputField(
                            hintText: "Enter Varification Code",

                            obscureText: false,
                            textInputType: TextInputType.number,
                            textStyle: textStyle,

                            textFieldColor: textFieldColor,
                            icon: Icons.edit,
                            iconColor: Colors.green.shade800,
                            bottomMargin: 3.0,
                            limit: 4,
                            validateFunction: (String value)
                            {
                              if(value.length==4)
                              {
                                return null;
                              }
                              else
                              {
                                return "Enter the Valid code";
                              }
                            },


                            onSaved: (String number) {
                              code1=number;
                            }):SizedBox(height: 10.0),

                        enable?new GradientButton(

                          onPressed: _handleSubmitted1,
                          text: "Verify",

                        ):new GradientButton(

                          onPressed: _handleSubmitted,
                          text: "Send",

                        ),
                      ],
                    ),
                  ),

                  enable?new Align(
                    alignment: Alignment.center,
                    child:  new TextButton(
                        buttonName: "Resend",

                        onPressed: (){
                          setState(() {
                            isenable=true;
                            enable=false;
                          });
                        },
                        buttonTextStyle: buttonTextStyle),

                  ):new Container()

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
                height: enable?deviceSize.height/2:deviceSize.height/2-70,
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
      appBar: new AppBar(
        title: new Text("Forgot Password"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[LoginBackground(),  LoginWidgets,
        ],
      ),
    );
  }

  void _handleSubmitted1() {


    final FormState form = formKey.currentState;

    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.

    } else {
      form.save();
      debugPrint(code);
      debugPrint(code1);
      if(code1 == code){
        Navigator.push(context, new MaterialPageRoute(builder: (contex)=> new Changepass(phonno:phoneno)));

      }
      else
        {
          SnackBar snackBar=new SnackBar(content: new Text("Wrong Code"),);
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }

    }

  }
}

