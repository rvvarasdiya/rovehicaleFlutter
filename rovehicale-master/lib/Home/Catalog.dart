import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:rovehiclefinal/Home/CustomCamera.dart';
import 'package:rovehiclefinal/Home/Search.dart';
import 'package:rovehiclefinal/Home/VehicleDetail.dart';
import 'package:rovehiclefinal/Home/fillter.dart';
import 'package:rovehiclefinal/model/modelvehicledetail.php.dart';
import 'package:rovehiclefinal/ui/theme/constunt.dart';
import 'package:image/image.dart' as Img;
import 'package:http/http.dart' as http;

import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';





List<CameraDescription> cameras;
class Catalog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    // TODO: implement createState
    return _catalogstate();
  }

}
class _catalogstate extends State {
  List wallpapersList=[];

  String value1="Choose Vehicle type";



  @override
  void initState() {
    super.initState();
    loaddata("http://manishvvasaniya.000webhostapp.com/rovehicle/showvehicle.php");

  }
  static const int _kItemCount = 1000;
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("RO_VEHICAL");
  String search;
  TextEditingController controller=new TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar:new AppBar(

        title:appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon,onPressed:(){
            setState(() {
              if ( this.actionIcon.icon == Icons.search){
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  maxLines: 1,
                  controller: controller,
                  onSubmitted: submit,
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search,color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );}
              else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("RO_VEHICAL");
              }



            });
          } ,),
        new IconButton(icon: Icon(Icons.filter_list), onPressed:(){_showDialog();})]
    ),
      body:  wallpapersList.length != 0
          ? new StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(1.0),
        crossAxisCount: 4,
        itemCount: wallpapersList.length,
        itemBuilder: (context, i) {


          String img = wallpapersList[i]['v_photo'];

          List image=img.split("^");
          String imgPath=image[0];
          debugPrint("-----------------------------------------------");
          debugPrint(imgPath);
          debugPrint("-----------------------------------------------");
          return new Material(
            elevation: 2.0,
            borderRadius:
            new BorderRadius.all(new Radius.circular(2.0)),
            child: new InkWell(
                onTap: () {
                  List<modeldetail> datalist=new List<modeldetail>();
                        //debugPrint(wallpapersList[i]['v_photo']);
                        modeldetail model=new modeldetail(wallpapersList[i]['u_id'], wallpapersList[i]['v_photo'], wallpapersList[i]['v_type'], wallpapersList[i]['v_sub_type'], wallpapersList[i]['v_model'], wallpapersList[i]['v_brand'], wallpapersList[i]['v_rent'],wallpapersList[i]['v_licence_plate'], wallpapersList[i]['id'], wallpapersList[i]['v_tnc']);
                        datalist.add(model);
                        debugPrint(datalist[0].getuid());
                      Navigator.push(context, new MaterialPageRoute(builder: (context)=>VehicalDetail(datalist:datalist)));
                },
                child: new Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    new Hero(
                        tag: imgPath,
                        child: Expanded(child:
                        new FadeInImage(
                          image: new NetworkImage(image.isEmpty?img:imgPath),

                          placeholder: new AssetImage("assets/wallfy.png"),
                        ),)
                    ),
                    Divider(
                      height: 10.0,

                      color: Colors.black,
                    ),
                    new Container(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 2.0)
                            ,child: new Text("Vehicle Name : "+wallpapersList[i]['v_model'],textAlign: TextAlign.start,),
                          ),
                          new Padding(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 10.0)
                              ,child: new Text("Price per Km: "+wallpapersList[i]['v_rent']+" INR")
                          ),

                        ],
                      ),
                    )

                  ],
                )
            ),
          );
        },
        staggeredTileBuilder: (i) =>
        new StaggeredTile.count(2, i.isEven ? 3 : 3),
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      )
          : new Center(
        child: new CircularProgressIndicator(),
      ),




    );
  }



  void _showDialog() async{
    List<String> _locations = [ 'Motorcycles', 'Car'];
    // flutter defined function
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          titlePadding: EdgeInsets.all(0.0),
          title:  new Card(
            elevation: 10.0,
            margin: EdgeInsets.all(0.0),
            child: new Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.green.shade800,
              padding: EdgeInsets.all(20.0),
              child: new Text("FIllter",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.white)),
            ),
          ),
          content: new SingleChildScrollView(


              child: Dialog_Control()


          ),

          actions: <Widget>[

            new FlatButton(
              child: new Text("Apply Fillter"),
              onPressed: () {


                Navigator.push(context, new MaterialPageRoute(builder: (context)=>new Fillter(value:_Dialog_ControlState.value,value1:_Dialog_ControlState.value1,value2:_Dialog_ControlState.value2,value3:_Dialog_ControlState.value3,value4:_Dialog_ControlState.value4,value5:_Dialog_ControlState.value5)));




              },),// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {

                _Dialog_ControlState.value="Please Choose Any One";
                _Dialog_ControlState.value1="Please Choose Any One";
                _Dialog_ControlState.value2="Please Choose Any One";
                _Dialog_ControlState.value3="Please Choose Any One";
                _Dialog_ControlState.value4="Please Choose Any One";
                _Dialog_ControlState.value5="Please Choose Any One";
                Navigator.of(context).pop();
              },

            ),
          ],

        );

      },
    );
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


  loaddata(String url) async
  {
    http.Response response=await http.get(url);

    if(response.statusCode==200)
    {
      String data=response.body;
      var data1=json.decode(data);
      setState(() {

        wallpapersList=data1;
        debugPrint(data1.toString());
      });

    }
    else
    {

    }
  }

  loaddata1(String url) async
  {
    http.Response response=await http.get(url);

    if(response.statusCode==200)
    {
      String data=response.body;
      var data1=json.decode(data);
      setState(() {

        wallpapersList=data1;
        debugPrint(data1.toString());

      });
      Navigator.of(context).pop();

    }
    else
    {

    }
  }


  void submit(String value) {
    debugPrint(controller.text);

    String data=controller.text;

    Navigator.push(context, new MaterialPageRoute(builder: (context)=>new Search(value:data)));
    //Navigator.push(context, new MaterialPageRoute(builder: (context)=>new search(image: image,)));
    //String url1="http://manishvvasaniya.000webhostapp.com/rovehicle/search.php?search="+controller.text;
    //loaddata1(url1);


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

class Dialog_Control extends StatefulWidget {
  @override
  _Dialog_ControlState createState() => _Dialog_ControlState();
}

class _Dialog_ControlState extends State<Dialog_Control> {
  List<String> _locations = [ 'Motorcycle', 'Car'];
  List<String> _subType=['Please Choose Any One'];
  List<String> _brand=['Please Choose Any One'];
  List<String> _model=['Please Choose Any One'];
  List<String> _state=['Please Choose Any One'];
  List<String> _city=['Please Choose Any One'];

  Size size;
  static String value="Please Choose Any One";
  static String value1="Please Choose Any One";
  static String value2="Please Choose Any One";
  static String value3="Please Choose Any One";
  static String value4="Please Choose Any One";
  static String value5="Please Choose Any One";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata1("http://manishvvasaniya.000webhostapp.com/rovehicle/list.php?type=state","state");
    getdata1("http://manishvvasaniya.000webhostapp.com/rovehicle/list.php?type=brand","brand");
    getdata1("http://manishvvasaniya.000webhostapp.com/rovehicle/list.php?type=model","model");
    getdata1("http://manishvvasaniya.000webhostapp.com/rovehicle/list.php?type=subtype","vtype");



  }

  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    return new SingleChildScrollView(

      child: new Padding(padding: EdgeInsets.all(23.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
              child: Text("Select Vehicle Type :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
            ),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,2.0,10.0,00.0),
              child:DropdownButton<String>(
                  items: _locations.map((String val) {
                    return new DropdownMenuItem<String>(

                      value: val,
                      child: new Container(

                        child:new Text(val),
                        width: size.width-162,


                      ),
                    );
                  }).toList(),
                  hint: Text(value),



                  onChanged: (newVal) {

                    this.setState(() {
                      value =newVal;
                      String url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=brand&cat="+newVal;
                      getdata(url,"brand");
                      String url1="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=1brand&cat="+newVal;

                      getdata1(url1, "model");
                      debugPrint(url1);
                      String url2="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=2brand&cat="+newVal;
                      debugPrint(url2);
                      getdata1(url2, "vtype");

//                      setState(() {
//                        _subType=['Please Choose Any One'];
//                        _brand=['Please Choose Any One'];
//                        _model=['Please Choose Any One'];
                      value1="Please Choose Any One";
                      value2="Please Choose Any One";
                      value3="Please Choose Any One";
//
//
//                      });


                    });
                  }),


            ),


            SizedBox(height: 20.0),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
              child: Text("Select Vehicle Brand :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
            ),
            new Padding(padding: EdgeInsets.fromLTRB(00.0,2.0,10.0,00.0),
              child:DropdownButton<String>(

                  items: _brand.map((String val) {
                    return new DropdownMenuItem<String>(

                      value: val,
                      child: new Container(
                        child:new Text(val),
                        width: size.width-162,


                      ),
                    );
                  }).toList(),
                  hint: Text(value1),



                  onChanged: (newVal) {
                    value1 =newVal;
                    String url;
                    this.setState(() {
                      if(value!="Please Choose Any One")
                      {
                        url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=subtype&brand="+value1+"&vtype="+value;

                      }
                      else
                      {
                        url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=1subtype&brand="+value1;


                      }
                      getdata(url,"vtype");
                      String url2="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=2subtype&brand="+value1;
                      getdata1(url2,"model");

                      setState(() {
//                        _subType=['Please Choose Any One'];
//                        _model=['Please Choose Any One'];
                        value2="Please Choose Any One";
                        value3="Please Choose Any One";

                      });


                    });
                  }),


            ),


            SizedBox(height: 20.0),


            new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
              child: Text("Select Vehicle Sub Type :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
            ),
            new Padding(padding: EdgeInsets.fromLTRB(00.0,2.0,10.0,00.0),
              child:DropdownButton<String>(

                  items: _subType.map((String val) {
                    return new DropdownMenuItem<String>(

                      value: val,
                      child: new Container(
                        child:new Text(val),
                        width: size.width-162,

                      ),
                    );
                  }).toList(),
                  hint: Text(value2),



                  onChanged: (newVal) {
                    value2 =newVal;
                    String url;
                    this.setState(() {
                      if(value1!="Please Choose Any One")
                      {
                        url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=model&brand="+value1+"&cat="+value2;

                      }
                      else{
                        url="http://manishvvasaniya.000webhostapp.com/rovehicle/vehiclecategory.php?type=1model&cat="+value2;

                      }
                      getdata(url,"model");
                      debugPrint(url);
                      setState(() {

//                        _model=['Please Choose Any One'];
//
                        value3="Please Choose Any One";

                      });


                    });
                  }),


            ),

            SizedBox(height: 20.0),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
              child: Text("Select Vehicle Model :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
            ),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,2.0,10.0,00.0),
              child:DropdownButton<String>(

                  items: _model.map((String val) {
                    return new DropdownMenuItem<String>(

                      value: val,
                      child: new Container(
                        child:new Text(val),
                        width: size.width-162,

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

            SizedBox(height: 20.0),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
              child: Text("Select State :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
            ),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,2.0,10.0,00.0),
              child:DropdownButton<String>(

                  items: _state.map((String val) {
                    return new DropdownMenuItem<String>(

                      value: val,
                      child: new Container(
                        child:new Text(val),
                        width: size.width-162,

                      ),
                    );
                  }).toList(),
                  hint: Text(value4),



                  onChanged: (newVal) {
                    value4 =newVal;
                    String url="http://manishvvasaniya.000webhostapp.com/rovehicle/list.php?type=city&state="+value4;
                    getdata1(url, "city");
                    setState(() {
                      _city=['Please Choose Any One'];

                      value5="Please Choose Any One";

                    });

                  }),


            ),
            SizedBox(height: 20.0),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,10.0,00.0),
              child: Text("Select City :",style: TextStyle(color:Colors.black54,fontSize: 17.0)),
            ),
            new Padding(padding: EdgeInsets.fromLTRB(0.0,2.0,10.0,00.0),
              child:DropdownButton<String>(

                  items: _city.map((String val) {
                    return new DropdownMenuItem<String>(

                      value: val,
                      child: new Container(
                        child:new Text(val),
                        width: size.width-162,

                      ),
                    );
                  }).toList(),
                  hint: Text(value5),



                  onChanged: (newVal) {
                    value5 =newVal;
                    setState(() {

                    });

                  }),


            ),






          ],
        ),
      ),
    );
  }
  getdata(String url,String cat)async{
    showProgress(context);
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
          // debugPrint(_brand.toString());
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
          // debugPrint(_subType.toString());
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
          //debugPrint(_model.toString());
        }
      }
      Navigator.of(context).pop();



    }


  }



  getdata1(String url,String cat)async{

    http.Response res=await http.get(url);

    debugPrint(url);
    if(res.statusCode==200)
    { if(cat=="brand" )
    {
      List data=json.decode(res.body);
      _brand.clear();
      for (int i=0;i<data.length;i++)
      {
        setState(() {
          _brand.add(data[i]['brand']);

        });
        // debugPrint(_brand.toString());
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
        //debugPrint(_subType.toString());
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
        // debugPrint(_model.toString());
      }
    }

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