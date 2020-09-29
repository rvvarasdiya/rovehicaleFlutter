import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:rovehiclefinal/Home/EditProfile.dart';
import 'package:rovehiclefinal/model/model.dart';
import 'package:rovehiclefinal/ui/theme/constunt.dart';


class UpdateProfile extends StatefulWidget {

  List<model> datalist1;
  UpdateProfile({Key key, this.datalist1}):super(key:key);
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
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
class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext context;
  String v_type,v_sub_type,model,brand,price,licence,tnc;

  bool _enable = true;



  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;
  String value;
  String value1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value=widget.datalist1[0].getvtype();
    value1=widget.datalist1[0].getvsubtype();
  }
  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      //  showInSnackBar('Please fix the errors in red before submitting.');
    } else {

      if(value=="Please Choose Any One" && value1=="Please Choose Any One")
      {
        SnackBar snackBar=new SnackBar(content: new Text("Please select The Value"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      else {
        form.save();
//        debugPrint(
//            name + "////" + enail + "/////" + password + "////" + phone_no +
//                "//////" + address + "/////" + city + "////" + state);
        var mapp = {
          "v_type":value,
          "v_sub_type":value1,
          "uid":constant.u_id,
          "model":model,
          "brand":brand,
          "licence":licence,
          "tnc":tnc
        };
       // uploadimage(widget.image);
      }

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
  List<String> _locations = [ 'Motorcycles', 'Car'];
  List<String> _subType=[''];
  Size size;
  @override
  Widget build(BuildContext context) {
    this.context=context;
    size=MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Add Vehicle'),
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
            padding: const EdgeInsets.symmetric(horizontal: 00.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Card(
                  elevation: 3.0,
                  child:new Container(

                    width: size.width,
                    height:size.height/2,
                    child: Image.network(widget.datalist1[0].getphoto()),
                  ),
                ),



                new Card(
                    elevation: 3.0,

                    child:new Padding(padding: EdgeInsets.all(20.0),child:
                    new Text("Add Vehilce Detail",style: TextStyle(fontSize: 24.0),),)
                ),


                new Card(
                  child: new Padding(padding:EdgeInsets.all(20.0),
                    child: new Column(children: <Widget>[


                      new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
                          child:Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child:Text("Select Vehicle Type :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),

                          )
                      ),
                      new Padding(padding: EdgeInsets.fromLTRB(40.0,10.0,10.0,00.0),
                        child:DropdownButton<String>(

                            items: _locations.map((String val) {
                              return new DropdownMenuItem<String>(

                                value: val,
                                child: new Container(
                                  child:new Text(val),
                                  width: size.width-130,


                                ),
                              );
                            }).toList(),
                            hint: Text(value),



                            onChanged: (newVal) {
                              value =newVal;
                              this.setState(() {
                                if(newVal=="Motorcycles")
                                {
                                  _subType=['Without gear','With gear','Sport bike'];
                                }
                                else
                                {
                                  _subType=['Sudan','SUV','Hatchback','Compect'];
                                }
                              });
                            }),


                      ),

                      new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
                          child:Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child:Text("Select Vehicle Sub Type :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),

                          )
                      ),
                      new Padding(padding: EdgeInsets.fromLTRB(40.0,10.0,10.0,00.0),
                        child:DropdownButton<String>(

                            items: _subType.map((String val) {
                              return new DropdownMenuItem<String>(

                                value: val,
                                child: new Container(
                                  child:new Text(val),
                                  width: size.width-130,


                                ),
                              );
                            }).toList(),
                            hint: Text(value1),



                            onChanged: (newVal) {
                              value1 =newVal;
                              this.setState(() {});
                            }),


                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.edit),
                          hintText: 'Vehicle Model',
                          labelText: 'Your Vehicle Model',
                        ),
                        enabled: _enable,
                        onSaved: (String value) { this.model = value; },
                        validator:(String value){
                          if(value.isEmpty)
                          {
                            return "Vehicle Model Requred";
                          }
                          else
                          {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.edit),
                          hintText: 'Your Vehicle Brand',
                          labelText: 'Vehicle Brand',
                        ),
                        enabled: _enable,
                        onSaved: (String value) { this.brand = value; },
                        validator:(String value){
                          if(value.isEmpty)
                          {
                            return "Vehicle Brand Requred";
                          }
                          else
                          {
                            return null;
                          }
                        },
                      ),


                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.monetization_on),
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
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.edit),
                          hintText: 'Your Licence Plate',
                          labelText: 'Licence No',
                        ),
                        enabled: _enable,
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

                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.edit),
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

                          child: const Text('ADD VEHICLE',style: TextStyle(color: Colors.white),),

                          color: Colors.green,

                          onPressed:_enable?_handleSubmitted:null,
                        ),
                      ),

                      const SizedBox(height: 24.0),],),),
                )
              ],
            ),
          ),
        ),),
      ),
    );
  }
  Future uploadimage(File imageFile)
  async {
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://manishvvasaniya.000webhostapp.com/rovehicle/addvehicle.php");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    request.fields['uid']=constant.u_id ;
    request.fields['v_type']=value ;
    request.fields['v_sub_type']=value1 ;
    request.fields['model']=model ;
    request.fields['brand']=brand ;
    request.fields['licence']=licence;
    request.fields['tnc']=tnc ;
    request.fields['price']=price;






    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);
    if(response.statusCode==200)
    {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        debugPrint(value);

      });

      Navigator.of(context).pushReplacementNamed("/profile");
      SnackBar snackBar=new SnackBar(content: new Text("Success"));
      _scaffoldKey.currentState.showSnackBar(snackBar);



    }else
    {
      SnackBar snackBar=new SnackBar(content: new Text("Some thing Wrong"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

}


