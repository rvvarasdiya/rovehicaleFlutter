import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rovehiclefinal/Home/VehicleDetail.dart';
import 'package:rovehiclefinal/model/modelvehicledetail.php.dart';
import 'package:http/http.dart' as http;


class Fillter extends StatefulWidget {
  String value,value1,value2,value3,value4,value5;
  Fillter({Key key,this.value,this.value1,this.value2,this.value3,this.value4,this.value5}): super(key : key);

  @override
  _Fllterstate createState() => _Fllterstate();
}

class _Fllterstate extends State<Fillter> {
  static const int _kItemCount = 1000;
  int flag=0;
  Icon actionIcon = new Icon(Icons.search);
  BuildContext context;
  String search;
  List wallpapersList=[];



  TextEditingController controller=new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();





  }
  loaddata1(String url) async
  {

    var data={
      "v_type":widget.value,
      "v_brand":widget.value1,
      "v_subtype":widget.value2,
      "v_model":widget.value3,
      "state":widget.value4,
      "city":widget.value5,


    };
    debugPrint(data.toString());
    // showProgress(context);
    http.Response response=await http.post(url,body: data);

    if(response.statusCode==200)
    {
      String data=response.body;
      var data1=json.decode(data);
      debugPrint(data1.toString());
      if(data1==null)
      {
        debugPrint("maligayu");
        setState(() {
          flag=1;
        });

      }
      else
      {
        debugPrint("nomalyu");
        setState(() {

          wallpapersList=data1;
          debugPrint(data1.toString());


        });

      }



    }
    else
    {

    }
  }

  @override
  Widget build(BuildContext context) {
    String url="http://manishvvasaniya.000webhostapp.com/rovehicle/filter.php";
    loaddata1(url);
    this.context=context;
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar:new AppBar(

        title:new Text("Fillter Data"),

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
          debugPrint(imgPath);
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
                    new Expanded(
                        flex: 1
                        ,child:  Container(child:
                    new FadeInImage(
                      image: new NetworkImage(image.isEmpty?img:imgPath),


                      placeholder: new AssetImage("assets/wallfy.png"),
                    ),)),
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
        child: flag==0?new CircularProgressIndicator():new Text("No Data Found"),
      ),




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
}
