import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rovehiclefinal/model/regmodel.dart';
import 'package:rovehiclefinal/services/validations.dart';
import 'package:rovehiclefinal/singup/SignUp3.dart';
import 'package:rovehiclefinal/ui/Buttons/gradient_button.dart';
import 'package:rovehiclefinal/ui/TextFields/inputField.dart';
import 'package:rovehiclefinal/ui/login_background.dart';
import 'package:rovehiclefinal/ui/theme/constunt.dart';
import 'package:rovehiclefinal/Home/EditProfile.dart';
import 'package:rovehiclefinal/ui/theme/style.dart';

class SignUp2 extends StatefulWidget {
  String  phoneno;

  SignUp2({Key key, this.phoneno}) : super(key: key);

  @override
  _AddVehicleState createState() => _AddVehicleState();
}
class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      key: widget.fieldKey,

      obscureText: _obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        icon: Icon(Icons.lock),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        enabled: widget.enable,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}

class _AddVehicleState extends State<SignUp2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext context;
  String email,password,name,contectNo,addresses,city,state;
  final List<Regmodel> listdata=new List<Regmodel>();
  Validations _validations = new Validations();
  List<String> _state=['Please Select State'];
  List<String> _city=['Please Select City'];
  bool autovalidate = false;
  String url;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool _enable = true;





  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;

  static String value4="Please Select State";
  static String value5="Please Select City";


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value4="Please Select State";
    value5="Please Select City";
    getdata1("http://manishvvasaniya.000webhostapp.com/rovehicle/list.php?type=state","state");
  }
  void _handleSubmitted() {

    showProgress(context);
    final FormState form = formKey.currentState;

    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.

    } else {
      if(value4=="Please Select State")
        {
          SnackBar snackBar=new SnackBar(content: new Text("Please select The State"));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
        else if(value5=="Please Select City")
          {
            SnackBar snackBar=new SnackBar(content: new Text("Please select The City"));
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        else
          {
            form.save();
            url="http://manishvvasaniya.000webhostapp.com/rovehicle/check.php?username="+email+"&num="+widget.phoneno;
            loaddata();
          }




    }

  }
  loaddata() async
  {
    var response=await http.get(url);
    debugPrint(url);
    if(response.statusCode==200)
    {
      Navigator.of(context).pop();
      String data=response.body;
      var data1=json.decode(data);

      debugPrint(data1[0]["result"]);

      if(data1[0]['result'].toString()=="email")
      {
        SnackBar snackBar=new SnackBar(content: new Text("This Email Already Use By SomeOne"),);
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }else if(data1[0]['result'].toString()== "phoneNo" )
      {
        SnackBar snackBar=new SnackBar(content: new Text("Phone No is Already Registerd"),);
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      else
      {

        Regmodel regmodel=new Regmodel(name, email, password, widget.phoneno, addresses, value5,value4);
        listdata.add(regmodel);

        debugPrint(listdata[0].getemail());
        debugPrint(listdata[0].getname());
        debugPrint(listdata[0].getpassword());
        debugPrint(listdata[0].getphoneno());
        debugPrint(listdata[0].getaddress());
        debugPrint(listdata[0].getcity());
        debugPrint(listdata[0].getstate());
        debugPrint('fcfcf');
        Navigator.push(context,MaterialPageRoute(builder:(context)=>new SignUp3(todos:listdata)));
//        SnackBar snackBar=new SnackBar(content: new Text("Success"),);
//        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
    else
    {
      Navigator.of(context).pop();
      SnackBar snackBar=new SnackBar(content: new Text("Some thing is wrong"),);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      debugPrint("some thig is wrong");
    }
  }

  String validateName(String value) {
    if (value.isEmpty) return 'Please choose a Vehicle';

    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Invalid email address';
    return null;
  }
  String validatePassword(String value) {
    if (value.isEmpty) return 'Please choose a password.';
    return null;
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    // debugPrint(widget.image.toString());

    this.context=context;
    size=MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green.shade100,
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Registration'),
        ),
        body: SafeArea(

          top: false,
          bottom: false,
          child:new Stack(

            children: <Widget>[
              LoginBackground(),

              Container(


                child: SingleChildScrollView(


                    child: new Card(
                        margin: EdgeInsets.all(13.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        elevation: 3.0,

                        child:new Padding(padding: EdgeInsets.all(20.0),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new Form(
                                key: formKey,
                                autovalidate: autovalidate,
                                child: new Column(
                                  children: <Widget>[
                                    new InputField(
                                      hintText: "Username",
                                      obscureText: false,
                                      textInputType: TextInputType.text,
                                      textStyle: textStyle,
                                      textFieldColor: textFieldColor,
                                      icon: Icons.person_outline,
                                      iconColor: Colors.green.shade800,
                                      bottomMargin: 20.0,
                                        validateFunction: _validations.validateName,
                                      onSaved: (String name) {
                                          this.name=name;
                                      },
                                    ),
                                    new InputField(
                                        hintText: "Email",
                                        obscureText: false,
                                        textInputType: TextInputType.emailAddress,
                                        textStyle: textStyle,
                                        textFieldColor: textFieldColor,
                                        icon: Icons.mail_outline,
                                        iconColor: Colors.green.shade800,
                                        bottomMargin: 20.0,
                                           validateFunction: _validations.validateEmail,
                                        onSaved: (String email) {

                                           this.email=email;
                                        }),


                                    new InputField(
                                        hintText: "Password",
                                        obscureText: true,
                                        textInputType: TextInputType.text,
                                        textStyle: textStyle,
                                        textFieldColor: textFieldColor,
                                        icon: Icons.lock_open,
                                        iconColor: Colors.green.shade800,
                                        bottomMargin: 20.0,
                                         validateFunction: _validations.validatePassword,
                                        onSaved: (String password) {
                                           this.password=password;
                                        }),


                                    new Container(

                                        decoration: BoxDecoration(
                                            borderRadius:BorderRadius.circular(100.0),
                                            border: Border.all(width: 1.0,color: Colors.grey.shade600)

                                        ),
                                        child:  new Row(
                                          children: <Widget>[
                                            new Padding(padding: EdgeInsets.fromLTRB(10.0,2.0,10.0,00.0),
                                                child: new Icon(Icons.location_on,color: Colors.green.shade800,) ),

                                            new Padding(padding: EdgeInsets.fromLTRB(0.0,2.0,10.0,00.0),

                                                child:new DropdownButtonHideUnderline(child:
                                                DropdownButton<String>(

                                                    items: _state.map((String val) {
                                                      return new DropdownMenuItem<String>(

                                                        value: val,
                                                        child: new Container(
                                                          child:new Text(val),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10000.0)),
                                                          width: size.width-146,

                                                        ),
                                                      );
                                                    }).toList(),
                                                    hint: Text(value4),



                                                    onChanged: (newVal) {
                                                      value4 =newVal;
                                                      String url="http://manishvvasaniya.000webhostapp.com/rovehicle/list.php?type=city&state="+value4;
                                                      getdata1(url, "city");
                                                      showProgress(context);
                                                      setState(() {
                                                        _city=['Please Select City '];

                                                        value5="Please Select City";

                                                      });

                                                    }),


                                                )


                                            ),
                                          ],
                                        )
                                    ),

                                    new SizedBox(height: 20.0),
                                    new Container(

                                        decoration: BoxDecoration(
                                            borderRadius:BorderRadius.circular(100.0),
                                            border: Border.all(width: 1.0,color: Colors.grey.shade600)

                                        ),
                                        child:  new Row(
                                          children: <Widget>[
                                            new Padding(padding: EdgeInsets.fromLTRB(10.0,2.0,10.0,00.0),
                                                child: new Icon(Icons.location_city,color: Colors.green.shade800,) ),


                                            new Padding(padding: EdgeInsets.fromLTRB(0.0,2.0,10.0,00.0),
                                                child:new DropdownButtonHideUnderline(child:
                                                DropdownButton<String>(

                                                    items: _city.map((String val) {
                                                      return new DropdownMenuItem<String>(

                                                        value: val,
                                                        child: new Container(
                                                          child:new Text(val),
                                                          width: size.width-146,

                                                        ),
                                                      );
                                                    }).toList(),
                                                    hint: Text(value5),



                                                    onChanged: (newVal) {
                                                      value5 =newVal;
                                                      setState(() {

                                                      });

                                                    }),

                                                )

                                            ),
                                          ],
                                        )
                                    ),


                                    SizedBox(height: 20.0),
                                    new InputField(
                                      hintText: "Address",
                                      obscureText: false,
                                      textInputType: TextInputType.text,
                                      textStyle: textStyle,
                                      textFieldColor: textFieldColor,
                                      icon: Icons.edit,
                                      iconColor: Colors.green.shade800,
                                      bottomMargin: 20.0,
                                      maxline: 5,
                                      validateFunction:(String value){
                                        if(value.isEmpty)
                                        {
                                          return "Address is required";
                                        }
                                        else
                                        {
                                          return null;
                                        }
                                      },
                                      onSaved: (String Address) {
                                          addresses=Address;
                                      },
                                    ),



                                    new GradientButton(

                                      onPressed:_handleSubmitted,
                                      text: "Next",

                                    )


                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                    )
                ),
              )

            ],
          ),
        )
    );
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

  getdata1(String url,String cat)async{

    http.Response res=await http.get(url);

    debugPrint(url);
    if(res.statusCode==200)
    {

      if(cat=="state")
      {
        List data=json.decode(res.body);
        _state.clear();
        for (int i=0;i<data.length;i++)
        {
          setState(() {
            _state.add(data[i]['state']);

          });
          //  debugPrint(_state.toString());
        }

      }
      if(cat=="city")
      {
        Navigator.of(context).pop();
        List data=json.decode(res.body);
        _city.clear();
        for (int i=0;i<data.length;i++)
        {
          setState(() {
            _city.add(data[i]['city']);

          });
          //  debugPrint(_city.toString());
        }

      }



    }


  }

}
