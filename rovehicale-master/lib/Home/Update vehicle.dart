import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rovehiclefinal/Home/MyHome.dart';
import 'package:rovehiclefinal/Home/Person.dart';
import 'package:rovehiclefinal/model/model.dart';
import 'package:rovehiclefinal/ui/theme/constunt.dart';
import 'package:rovehiclefinal/Home/EditProfile.dart';

class Updatevehicle extends StatefulWidget {
  List<model> datalist1=new List<model>();
  Updatevehicle({Key key, this.datalist1}) : super(key: key);

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

class _AddVehicleState extends State<Updatevehicle> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext context;
  String v_type,v_sub_type,model,brand,price,licence,tnc;
  List<String> _locations = [ 'Motorcycle', 'Car'];
  List<String> _subType=['Please Choose Any One'];
  List<String> _brand=['Please Choose Any One'];
  List<String> _model=['Please Choose Any One'];

  bool _enable = true;



  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;
  String value="";
  String value1="";

  String value2="";
  String value3="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value=widget.datalist1[0].getvtype();
    value1=widget.datalist1[0].getbrand();
    value2=widget.datalist1[0].getvsubtype();
    value3=widget.datalist1[0].getmodelno();

  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      //debugPrint(name+"////"+enail+"/////"+password+"////"+phone_no+"//////"+address+"/////"+city+"////"+state);
      var mapp={
        'id':widget.datalist1[0].getid(),
        'r':price,
        'tc':tnc,


      };
      postData(mapp);


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
        title: const Text('Update Vehicle'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child:Theme(
          data:ThemeData(
              primaryColor: Colors.black54,
              accentColor: Colors.black54
          ) ,child:Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: SingleChildScrollView(


              child: new Card(
                  margin: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  elevation: 10.0,

                  child:new Padding(padding: EdgeInsets.all(20.0),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                           Container(
                            width: size.width,
                            height: size.height/2.8,
                            child: Image(image:NetworkImage(widget.datalist1[0].getphoto())),

                        ),
                            new Text("Note : Only Vehicle Rent And Vehicle T & C edit"),
                           SizedBox(height: 20.0,),
                           TextFormField(
                             initialValue: value,
                             textCapitalization: TextCapitalization.words,
                             decoration:  InputDecoration(
                               border: UnderlineInputBorder(),
                               icon: Icon(Icons.directions_car),
                               hintText: 'Vehicle Type',
                               labelText: 'Vehicle Type',


                             ),


                             enabled: false,

                             keyboardType: TextInputType.number,
                             onSaved: (String value) { this.price = value; },
                             validator:(String value){
                               if(!value.isEmpty)
                               {
                                 return null;
                               }
                               else
                               {
                                 return "Price Requred";
                               }

                             },
                           ),
                           TextFormField(
                             initialValue: value1,
                             textCapitalization: TextCapitalization.words,
                             decoration:  InputDecoration(
                               border: UnderlineInputBorder(),
                               icon: Icon(Icons.directions_car),
                               hintText: 'Vehicle Brand',
                               labelText: 'Vehicle Brand',


                             ),


                             enabled: false,

                             keyboardType: TextInputType.number,
                             onSaved: (String value) { this.price = value; },
                             validator:(String value){
                               if(!value.isEmpty)
                               {
                                 return null;
                               }
                               else
                               {
                                 return "Price Requred";
                               }

                             },
                           ),
                           TextFormField(
                             initialValue: value2,
                             textCapitalization: TextCapitalization.words,
                             decoration:  InputDecoration(
                               border: UnderlineInputBorder(),
                               icon: Icon(Icons.directions_car),
                               hintText: 'Vehicle Sub Type',
                               labelText: 'Vehicle Sub Type',


                             ),


                             enabled: false,

                             keyboardType: TextInputType.number,
                             onSaved: (String value) { this.price = value; },
                             validator:(String value){
                               if(!value.isEmpty)
                               {
                                 return null;
                               }
                               else
                               {
                                 return "Price Requred";
                               }

                             },
                           ),

                           TextFormField(
                             initialValue: value,
                             textCapitalization: TextCapitalization.words,
                             decoration:  InputDecoration(
                               border: UnderlineInputBorder(),
                               icon: Icon(Icons.directions_car),
                               hintText: 'Vehicle Model',
                               labelText: 'Vehicle Model',

                             ),


                             enabled: false,

                             keyboardType: TextInputType.number,
                             onSaved: (String value) { this.price = value; },
                             validator:(String value){
                               if(!value.isEmpty)
                               {
                                 return null;
                               }
                               else
                               {
                                 return "Price Requred";
                               }

                             },
                           ),
                        TextFormField(
                          initialValue: widget.datalist1[0].getrent(),
                          textCapitalization: TextCapitalization.words,
                          decoration:  InputDecoration(
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.monetization_on,color: Colors.grey.shade900,),
                            hintText: 'Your Vehicle Price per km',
                            labelText: 'Price Per km',

                          ),


                          enabled: _enable,

                          keyboardType: TextInputType.number,
                          onSaved: (String value) { this.price = value; },
                          validator:(String value){
                            if(!value.isEmpty)
                            {
                              return null;
                            }
                            else
                            {
                              return "Price Requred";
                            }

                          },
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          initialValue: widget.datalist1[0].getplate(),

                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.edit),
                            hintText: 'Your Vehicle Licence No ',
                            labelText: 'Licence No',
                          ),
                          enabled: false,
                          onSaved: (String value) { this.licence = value; },
                          validator:(String value){
                            if(value.isEmpty)
                            {
                              return "Number Plate Requre";
                            }
                            else
                            {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 24.0),
                        TextFormField(
                          maxLines: 3,
                          initialValue: widget.datalist1[0].gettnc(),

                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.edit,color: Colors.black),
                            filled: true,
                            hintText: 'Your Vehicle T&C',
                            labelText: 'Vehicle T&C',
                          ),
                          onSaved: (String value) { this.tnc = value; },
                          enabled: _enable,
                          validator: (String value){
                            if(value.isEmpty)
                            {
                              return "Vehicle T&C is required";
                            }
                            else
                            {
                              return null;
                            }

                          },
                        ),


                        const SizedBox(height: 24.0),
                        Align(

                          alignment: Alignment.bottomRight,
                          child: RaisedButton(

                            child: const Text('Update Vehicle',style: TextStyle(color: Colors.white),),

                            color: Colors.green,

                            onPressed:_enable?_handleSubmitted:null,
                          ),
                        ),

                        const SizedBox(height: 24.0),
                      ],
                    ),
                  )
              )
          ),
        ),),
      ),
    );
  }


  getdata(String url,String cat)async{

    http.Response res=await http.get(url);

    debugPrint(url);
    if(res.statusCode==200)
    {

      if(cat=="brand")
      {
        List data=json.decode(res.body);
        _brand.clear();
        for (int i=0;i<data.length;i++)
        {
          setState(() {
            _brand.add(data[i]['brand']);

          });
          debugPrint(_brand.toString());
        }

      }
      if(cat=="vtype")
      {
        List data=json.decode(res.body);
        _subType.clear();
        for (int i=0;i<data.length;i++)
        {
          setState(() {
            _subType.add(data[i]['type']);

          });
          debugPrint(_subType.toString());
        }

      }
      if(cat=="model")
      {
        List data=json.decode(res.body);
        _model.clear();
        for (int i=0;i<data.length;i++)
        {
          setState(() {
            _model.add(data[i]['model']);

          });
          debugPrint(_model.toString());
        }
      }



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


  Future postData(Map data1) async {
      showProgress(context);
      debugPrint(data1.toString());
    String url1="http://manishvvasaniya.000webhostapp.com/rovehicle/updatevehicle.php";
    http.Response res = await http.post(url1, body: data1); // post api call
    if(res.statusCode==200) {
      var data2 = json.decode(res.body);
      debugPrint(data2[0]['result'].toString());
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Update Success",
          toastLength: Toast.LENGTH_LONG,

          timeInSecForIos: 1
      );
      var ru=new MaterialPageRoute(builder: (context)=>new MyHome(index:1));
      Navigator.of(context).pushAndRemoveUntil(ru,(Route<dynamic> route) => false);
    }
    else
    {

    }
  }

}
