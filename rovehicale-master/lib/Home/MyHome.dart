import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rovehiclefinal/Home/Catalog.dart';
import 'package:rovehiclefinal/Home/CustomCamera.dart';
import 'package:rovehiclefinal/Home/Person.dart';
import 'package:rovehiclefinal/ui/login_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rovehiclefinal/ui/theme/constunt.dart';
class MyHome extends StatefulWidget {
  int index;
  MyHome({Key key, this.index }) : super(key: key);
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<CameraDescription> cameras;
  final List<Widget> _children = [
    Catalog(),
    Person(),
  ];
  int _currentIndex;
  String id;
  String data = "";
  SharedPreferences preferences;


  Future init()
  async {
    preferences=await SharedPreferences.getInstance();
    id=preferences.getString("id");
    loaddata();
    getJson();
    try {
      cameras = await availableCameras();
      debugPrint(cameras.toString());
    } on CameraException catch (e) {
      //logError(e.code, e.description);
    }

  }

  @override
  initState () {
    super.initState();
    // Add listeners to this class
    //debugPrint("wnfjbvhsbvhvh");
    _currentIndex=widget.index==null?0:widget.index;
    init();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: _children[_currentIndex],
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:  FloatingActionButton(onPressed: (){
          getImageCamera();
        },
            
            child: new Icon(Icons.camera_alt)

    ),
      bottomNavigationBar: BottomAppBar(

        color: Colors.green.shade900,
        shape: CircularNotchedRectangle(),
        child:new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[

            FlatButton(
              splashColor: Colors.yellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))),


              child: new Text("Home",style: TextStyle(color: Colors.white),),

              onPressed: (){
               setState(() {
                 _currentIndex=0;
               });
              },
            ),
            FlatButton(
              splashColor: Colors.yellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))),

              child: new Text("Profile",style: TextStyle(color: Colors.white),),
              onPressed: (){
                setState(() {
                  _currentIndex=1;
                });
              },
            ),

           
          ],
        ),

      ),
    );
  }


  void loaddata() async {
    String url1 = "http://manishvvasaniya.000webhostapp.com/rovehicle/user.php?id="+id;
    debugPrint(url1);
    var response = await http.get(url1);
    debugPrint(url1);

    if (response.statusCode == 200) {
      String data1 = response.body;

      var data2=json.decode(data1);
      debugPrint(data2[0]['contact_no']);
      constant.u_name=data2[0]['name'];
      constant.u_image=data2[0]["image"];
      constant.u_email=data2[0]["email"];

      constant.u_conact_no=data2[0]["contact_no"];
      constant.u_password=data2[0]["password"];
      constant.u_address=data2[0]["address"];
      constant.u_city=data2[0]["city"];
      constant.u_state=data2[0]["state"];
      constant.u_id=id;

    }

  }
  void getJson() async{
    String apiUrl = 'http://manishvvasaniya.000webhostapp.com/rovehicle/personvhicleDetail.php?id=20';

    http.Response response = await http.get(apiUrl);
    debugPrint(response.body);

    constant.u_data=json.decode(response.body);


  }
  void getImageCamera() async {
    new CustomCamera();

    Navigator.push(context, new MaterialPageRoute(builder: (context)=>new CustomCamera(cam:cameras)));
    //debugPrint(cameras.toString());
//    Navigator.push(context,
//        new MaterialPageRoute(builder: (BuildContext)=>AddVehicle(image:imageFile))
//    );
    //Navigator.of(context).pushNamed("/profile");
//    final tempDir =await getTemporaryDirectory();
//    final path = tempDir.path;
//
//    int rand= new Math.Random().nextInt(100000);
//
//    Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
//    Img.Image smallerImg = Img.copyResize(image, 500);
//
//    var compressImg= new File("$path/image_$rand.jpg")
//      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


//    setState(() {
//      imageFile = compressImg;
//    });




  }
}
