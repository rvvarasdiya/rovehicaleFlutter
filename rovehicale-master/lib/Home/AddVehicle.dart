import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rovehiclefinal/Home/MyHome.dart';
import 'package:rovehiclefinal/ui/theme/constunt.dart';
import 'package:rovehiclefinal/Home/EditProfile.dart';

class AddVehicle extends StatefulWidget {
  List<File> image;
  AddVehicle({Key key, this.image}) : super(key: key);

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

class _AddVehicleState extends State<AddVehicle> {
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
  String value="Please Choose Any One";
  String value1="Please Choose Any One";

  String value2="Please Choose Any One";
  String value3="Please Choose Any One";


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      //  showInSnackBar('Please fix the errors in red before submitting.');
    } else {

      if(value=="Please Choose Any One" && value1=="Please Choose Any One"&& value2=="Please Choose Any One"&& value3=="Please Choose Any One" )
      {
        SnackBar snackBar=new SnackBar(content: new Text("Please select The Value"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      else {
        form.save();
        showProgress(context);
//        debugPrint(
//            name + "////" + enail + "/////" + password + "////" + phone_no +
//                "//////" + address + "/////" + city + "////" + state);
//        var mapp = {
//          "v_type":value,
//          "v_sub_type":value2,
//          "uid":constant.u_id,
//          "model":value3,
//          "brand":value2,
//          "licence":licence,
//          "tnc":tnc,
//          "mobileNo":constant.u_conact_no,
//          "city":constant.u_city,
//          "state":constant.u_state
//        };
      uploadimage();
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


              child: new Card(
                  margin: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  elevation: 10.0,

                  child:new Padding(padding: EdgeInsets.all(20.0),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
                          child: Text("Select Vehicle Type :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
                        ),
                        new Padding(padding: EdgeInsets.fromLTRB(40.0,10.0,10.0,00.0),
                          child:DropdownButton<String>(

                              items: _locations.map((String val) {
                                return new DropdownMenuItem<String>(

                                  value: val,
                                  child: new Container(
                                    child:new Text(val),
                                    width: size.width-140,


                                  ),
                                );
                              }).toList(),
                              hint: Text(value),



                              onChanged: (newVal) {
                                value =newVal;
                                this.setState(() {

                                  String url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=brand&cat="+newVal;
                                  getdata(url,"brand");
                                  setState(() {
                                    _subType=['Please Choose Any One'];
                                    _brand=['Please Choose Any One'];
                                    _model=['Please Choose Any One'];
                                    value1="Please Choose Any One";
                                    value2="Please Choose Any One";
                                    value3="Please Choose Any One";

                                  });


                                });
                              }),


                        ),


                        new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
                          child: Text("Select Vehicle Brand :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
                        ),
                        new Padding(padding: EdgeInsets.fromLTRB(40.0,10.0,10.0,00.0),
                          child:DropdownButton<String>(

                              items: _brand.map((String val) {
                                return new DropdownMenuItem<String>(

                                  value: val,
                                  child: new Container(
                                    child:new Text(val),
                                    width: size.width-140,


                                  ),
                                );
                              }).toList(),
                              hint: Text(value1),



                              onChanged: (newVal) {
                                value1 =newVal;
                                this.setState(() {

                                  String url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=subtype&brand="+value1+"&vtype="+value;
                                  getdata(url,"vtype");
                                  setState(() {
                                    _subType=['Please Choose Any One'];
                                    _model=['Please Choose Any One'];
                                    value2="Please Choose Any One";
                                    value3="Please Choose Any One";

                                  });


                                });
                              }),


                        ),





                        new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
                          child: Text("Select Vehicle Sub Type :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
                        ),
                        new Padding(padding: EdgeInsets.fromLTRB(40.0,10.0,10.0,00.0),
                          child:DropdownButton<String>(

                              items: _subType.map((String val) {
                                return new DropdownMenuItem<String>(

                                  value: val,
                                  child: new Container(
                                    child:new Text(val),
                                    width: size.width-140,


                                  ),
                                );
                              }).toList(),
                              hint: Text(value2),



                              onChanged: (newVal) {
                                value2 =newVal;
                                this.setState(() {

                                  String url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=model&brand="+value1+"&cat="+value2;
                                  getdata(url,"model");
                                  setState(() {

                                    _model=['Please Choose Any One'];

                                    value3="Please Choose Any One";

                                  });


                                });
                              }),


                        ),


                        new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
                          child: Text("Select Vehicle Model :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
                        ),
                        new Padding(padding: EdgeInsets.fromLTRB(40.0,10.0,10.0,00.0),
                          child:DropdownButton<String>(

                              items: _model.map((String val) {
                                return new DropdownMenuItem<String>(

                                  value: val,
                                  child: new Container(
                                    child:new Text(val),
                                    width: size.width-140,


                                  ),
                                );
                              }).toList(),
                              hint: Text(value3),



                              onChanged: (newVal) {
                                value3 =newVal;
                                setState(() {

                                });

                              }),


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
                            hintText: 'Your Vehicle Licence No ',
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

                            child: const Text('Add Vehicle',style: TextStyle(color: Colors.white),),

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

  Future uploadimage()
  async {
    var uri = Uri.parse("http://manishvvasaniya.000webhostapp.com/rovehicle/addvehicle.php");

    var request = new http.MultipartRequest("POST", uri);
    for(int i=0;i<widget.image.length;i++)
      {
        debugPrint(widget.image[i].toString());
        File imageFile=widget.image[i];
        var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();
        var multipartFile = new http.MultipartFile('image[]', stream, length,
            filename: basename(imageFile.path));
        request.files.add(multipartFile);
      }



    // get file length


    // string to uri

    // create multipart request


    // multipart that takes file



    request.fields['uid']=constant.u_id ;
    request.fields['v_type']=value ;
    request.fields['v_sub_type']=value2 ;
    request.fields['model']=value3;
    request.fields['brand']=value1;
    request.fields['licence']=licence;
    request.fields['tnc']=tnc ;
    request.fields['price']=price;
    request.fields['city']=constant.u_city;
    request.fields['state']=constant.u_state;
    request.fields['number']=constant.u_conact_no;





    // add file to multipart


    // send
    var response = await request.send();
    print(response.statusCode);
    if(response.statusCode==200)
    {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        debugPrint(value);

      });

     // Navigator.popUntil(context, ModalRoute.withName('/screen2'));
      Fluttertoast.showToast(
          msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        bgcolor: "#FF2E7D32",
        textcolor: "#fff"


      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      var ru=new MaterialPageRoute(builder: (context)=>new MyHome(index:0));
      Navigator.of(context).pushAndRemoveUntil(ru,(Route<dynamic> route) => false);
//      _scaffoldKey.currentState.showSnackBar(snackBar);



    }else
    {
      SnackBar snackBar=new SnackBar(content: new Text("Some thing Wrong"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
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
}
