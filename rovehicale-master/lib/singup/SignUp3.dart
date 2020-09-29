import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:rovehiclefinal/Login/loginscreen.dart';
import 'package:rovehiclefinal/model/regmodel.dart';
import 'package:rovehiclefinal/ui/Buttons/gradient_button.dart';
import 'dart:convert';
import 'dart:math' as Math;


import 'package:rovehiclefinal/ui/Buttons/roundedButton.dart';
import 'package:rovehiclefinal/ui/login_background.dart';
class SignUp3 extends StatefulWidget {
  final List<Regmodel> todos;

  SignUp3({Key key, @required this.todos}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp3> {

  BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize ;
  File _image;
  String name="Sign Up";

  Future getImageCamera() async{
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
    });
  }

  @override
  Widget build(BuildContext context){
    this.context=context;
    screenSize= MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Registration"),
      ),
      body: new Stack(

              children: <Widget>[
                LoginBackground(),
             new Container(
               height: MediaQuery.of(context).size.height,
               child:  new Center(
                 child: new SingleChildScrollView(
                   child: new Card(
                    margin: EdgeInsets.all(10.0),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                     child:   new Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         SizedBox(height: 20.0,),
                         GestureDetector(
                           onTap: getImageCamera,
                           child: CircleAvatar(
                             backgroundColor: Colors.green,
                             radius: 80.00,
                             backgroundImage:
                             _image==null?AssetImage("assets/user.png",):FileImage(_image),
                           ),
                         ),
                         SizedBox(height: 10.0,),
                         new GestureDetector(
                           child: new Text("Uploade Profile",style: TextStyle(color: Colors.green.shade800),),

                           onTap: (){
                             getImageCamera();
                           },
                         ),
                         new Padding(padding: EdgeInsets.all(40.00),

                             child:new GestureDetector(
                                 onTap: (){

                                 },

                                 child:  new GradientButton(

                                   onPressed:_handleSubmitted,
                                   text: "Sign Up",

                                 )
                             )
                         )
                       ],
                     ),
                   ),
                 ),
               )
             )
              ]
          )

    );
  }

  void _handleSubmitted() {
    var mapp={
      'name':widget.todos[0].getname(),
      'email':widget.todos[0].getemail(),
      'password':widget.todos[0].getpassword(),
      'contact_no':widget.todos[0].getphoneno(),
      'address':widget.todos[0].getaddress(),
      'city':widget.todos[0].getcity(),
      'state':widget.todos[0].getstate(),

    };

    showProgress(context);
    postData(mapp);

  }
  void postData(Map data1) async {

    debugPrint(data1.toString());
    String url1="http://manishvvasaniya.000webhostapp.com/rovehicle/insert.php";
    http.Response res = await http.post(url1, body: data1); // post api call
    if(res.statusCode==200)
    {
      var data2 = json.decode(res.body);
      debugPrint(data2[0]['result'].toString());

      if(_image!=null)
      {
        uploadimage(_image,data2[0]['result'].toString());
      }
      else
      {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_LONG,

            timeInSecForIos: 1
        );
        var ru=new MaterialPageRoute(builder: (context)=>new LoginScreen());
        Navigator.of(context).pushAndRemoveUntil(ru,(Route<dynamic> route) => false);

      }

    }
    else
    {
      Navigator.of(context).pop();
      SnackBar snackBar=new SnackBar(content: new Text("Some thing Wrong"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
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
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Registration Success",
          toastLength: Toast.LENGTH_LONG,

          timeInSecForIos: 1
      );
      var ru=new MaterialPageRoute(builder: (context)=>new LoginScreen());
      Navigator.of(context).pushAndRemoveUntil(ru,(Route<dynamic> route) => false);
    }else
    {
      Navigator.of(context).pop();
      SnackBar snackBar=new SnackBar(content: new Text("Some thing Wrong"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
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