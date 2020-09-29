import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:rovehiclefinal/ui/theme/constunt.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}
class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.enable,
    this.initialvalue
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final bool enable;
  final String initialvalue;


  @override
  _PasswordFieldState createState() => _PasswordFieldState();
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
      initialValue: widget.initialvalue,
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

class _EditProfileState extends State<EditProfile> {
  BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize ;
  File _image;

  Size size;



  String name,enail,password,phone_no,address,city,state;

  bool _enable = true;


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      debugPrint(name+"////"+enail+"/////"+password+"////"+phone_no+"//////"+address+"/////"+city+"////"+state);
      var mapp={
        'name':name,
        'email':enail,
        'password':password,
        'contact_no':phone_no,
        'address':address,
        'city':city,
        'state':state,
        'id':constant.u_id,

      };
      postData(mapp);


    }
  }

  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
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
  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Edit Profile"),
      ),
      body:new SingleChildScrollView(

        child:new Column(
          children: <Widget>[
            new Container(
              height: size.height/3,
              child: Center(
                  child:new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        new Positioned(
                          top: 0.0,
                          child: Image.asset(
                            'assets/signup-screen-background.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: getImageCamera,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 70.00,
                                backgroundImage:
                                _image==null?NetworkImage(constant.u_image):FileImage(_image),
                              ),

                            ),
                            SizedBox(height: 15.0),
                            new GestureDetector(
                              child: new Center(child: new Text("Edit Profile Photo",style: TextStyle(color: Colors.green.shade900,fontWeight: FontWeight.bold),)),
                              onTap: getImageCamera,
                            )
                          ],
                        )])
              ),

            ),
            Container(

              child:Theme(
                data:ThemeData(
                  primaryColor: Colors.black54,
                  accentColor: Colors.black54
                ) ,
                child:Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration:InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.person),
                          hintText: 'Your Name',
                          labelText: 'Name',
                          enabled: _enable,

                        ),
                        initialValue: constant.u_name,
                        onSaved: (String value) { this.name = value; },
                        validator:validateName,
                      ),


                      TextFormField(
                        decoration:InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.email),
                          hintText: 'Your email address',
                          labelText: 'E-mail',
                          enabled: _enable,

                        ),
                        initialValue: constant.u_email,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String value) { this.enail = value; },
                        validator: validateEmail,
                      ),

                     PasswordField(

                        initialvalue: constant.u_password,
                        labelText: 'Password',
                        validator:validatePassword,
                        enable: true,
                        onSaved: (String value) {
                          this.password = value;
                        },
                      ),


                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.call),
                          hintText: 'Your Phone No',
                          labelText: 'Phone No',
                        ),
                        initialValue: constant.u_conact_no,
                        maxLength: 10,
                        enabled: _enable,

                        keyboardType: TextInputType.number,
                        onSaved: (String value) { this.phone_no = value; },
                        validator:(String value){
                          if(value.length==10)
                          {
                            return null;
                          }
                          else
                          {
                            return "Enter the valid phone no";
                          }

                        },
                      ),

                      TextFormField(
                        maxLines: 3,

                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.edit),
                          filled: true,
                          hintText: 'Your Address',
                          labelText: 'Address',
                        ),
                        initialValue: constant.u_address,
                        onSaved: (String value) { this.address = value; },
                        enabled: _enable,
                        validator: (String value){
                          if(value.isEmpty)
                          {
                            return "Address is required";
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
                          hintText: 'Your City',
                          labelText: 'City',
                        ),
                        initialValue: constant.u_city,
                        enabled: _enable,
                        onSaved: (String value) { this.city = value; },
                        validator:(String value){
                          if(value.isEmpty)
                          {
                            return "City is Required";
                          }
                          else
                          {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.edit),
                          hintText: 'Your State',
                          labelText: 'State',
                        ),
                        initialValue: constant.u_state,
                        enabled: _enable,
                        onSaved: (String value) { this.state = value; },
                        validator:(String value){
                          if(value.isEmpty)
                          {
                            return "State is Required";
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

                          child: const Text('UPDATE',style: TextStyle(color: Colors.white),),

                          color: Colors.green,

                          onPressed:_enable?_handleSubmitted:null,
                        ),
                      ),

                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),),
            ),
          ],
        )

      )

    );
  }
  Future getImageCamera() async{
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
    });
    uploadimage(_image, constant.u_id);

  }
  Future postData(Map data1) async {

    String url1="http://manishvvasaniya.000webhostapp.com/rovehicle/update.php";
    http.Response res = await http.post(url1, body: data1); // post api call
    if(res.statusCode==200) {
      var data2 = json.decode(res.body);
      debugPrint(data2[0]['result'].toString());
      loaddata();
      SnackBar snackBar=new SnackBar(content: new Text("success"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    else
    {

    }
  }
  Future uploadimage(File imageFile,String id)
  async {
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://manishvvasaniya.000webhostapp.com/rovehicle/image.php");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    request.fields['id']=id ;
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

      loaddata();
      SnackBar snackBar=new SnackBar(content: new Text("Success"));
      _scaffoldKey.currentState.showSnackBar(snackBar);



    }else
    {
      SnackBar snackBar=new SnackBar(content: new Text("Some thing Wrong"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
  void loaddata() async {
    String url1 = "http://manishvvasaniya.000webhostapp.com/rovehicle/user.php?id="+constant.u_id;
    debugPrint(url1);
    var response = await http.get(url1);
    debugPrint(url1);
    if (response.statusCode == 200) {
      String data1 = response.body;
      var data2=json.decode(data1);


        constant.u_name=data2[0]['name'];
        constant.u_image=data2[0]["image"];
        constant.u_email=data2[0]["email"];
        constant.u_conact_no=data2[0]["contact_no"];
        debugPrint(constant.u_conact_no);
        constant.u_password=data2[0]["password"];
        constant.u_address=data2[0]["address"];
        constant.u_city=data2[0]["city"];
        constant.u_state=data2[0]["state"];




    }

  }
}
