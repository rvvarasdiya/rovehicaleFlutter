import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rovehiclefinal/Home/Update%20vehicle.dart';
import 'package:rovehiclefinal/Home/UpdateProfile.dart';
import 'package:rovehiclefinal/model/model.dart';
import 'package:rovehiclefinal/ui/theme/constunt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Person extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _personstate();
  }

}
class _personstate extends State with TickerProviderStateMixin{

  String data;
  String id;
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;
  SharedPreferences preferences;
  Size size;

  List _data;

  @override
  void initState() {

    super.initState();
    getJson();
    init();
  }



  Widget _buildAvatar() {
    return new Center(

//      tag: avatarTag,
      child: new Padding(padding: EdgeInsets.all(5.0),
        child: new CircleAvatar(
          backgroundImage: NetworkImage(constant.u_image),
          radius: 50.0,
        ),
      ),
    );
  }
//

  Widget _buildActionButtons() {
    return new Padding(
      padding: const EdgeInsets.only(


      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createPillButton(
            'Log-Out',
            backgroundColor: Colors.green.shade50,
          ),
          _createPillButton1(
            "Edit Profile",
            backgroundColor: Colors.green.shade50,
          ),

        ],
      ),
    );
  }

  Widget _createPillButton(
      String text, {
        Color backgroundColor = Colors.green,
        Color textColor = Colors.green,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),

      child: new MaterialButton(
        minWidth: 100.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {preferences.clear();Navigator.of(context).pushReplacementNamed("/login");},
        child: new Text(text),
      ),
    );
  }
  Widget _createPillButton1(
      String text, {
        Color backgroundColor = Colors.green,
        Color textColor = Colors.green,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),

      child: new MaterialButton(
        minWidth: 100.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {

          Navigator.of(context).pushNamed("/editprofile");
        },
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    size=MediaQuery.of(context).size;
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(constant.u_name),
      ),
      body: new Container(
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/signup-screen-background.png"),fit: BoxFit.fill)
                  ),
                  child:Padding(
                    padding: EdgeInsets.all(16.0),
                    child:Column(
                      children: <Widget>[
                        _buildAvatar(),
                        _buildActionButtons(),
                      ],
                    ),
                  )

              )
              ,
              Card(
                child:Container(
                  width: size.width,
                  padding: EdgeInsets.all(10.0),
                  child: new Text("Your Vehicle",style: TextStyle(fontSize: 18.0),),
                ) ,
              ),

              Card(
                child: Container(
                  height: size.height/2-80,
                  child:  new Center(
                    child: _data!=null?_data.isEmpty?new Text("No Vehicle Added"):new ListView.builder(
                        itemCount: _data.length,
                        padding: const EdgeInsets.all(0.0),
                        itemBuilder: (BuildContext context, int position) {
                          return Card(
                              color: Colors.green.shade50,
                              child:new Container(
                                height: size.height/8,
                                child: new Row(
                                  children: <Widget>[
                                    new GestureDetector(
                                      onTap: (){itemclick(position);},
                                      child: new Container(
                                        width:size.width/6,
                                        child:
                                        new Image.network(_data[position]['v_photo']),

                                      ),
                                    )
                                    ,
                                    new Flexible(

                                        child:GestureDetector(
                                          child: new Container(
                                              padding: EdgeInsets.all(14.0),
                                              width:size.width/2+120 ,
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[

                                                  new Text("Vehicle Name : "+
                                                      _data[position]['v_model']),
                                                  const SizedBox(height: 5.0),
                                                  new Text("Km Price          : "  +
                                                      _data[position]['v_rent']+" INR"),

                                                ],
                                              )

                                          ),
                                          onTap: (){
                                            itemclick(position);
                                          },
                                        )

                                    ),
                                    new IconButton(icon: new Icon(Icons.delete), onPressed:(){
                                      _showDialog(_data,position,_data[position]["id"]);

                                    } )

                                  ],
                                ),
                              )

//                    new ListTile(
//                      title: Text(
//                        "${_data[position]['title']}",
//                        style: new TextStyle(fontSize: 17.9),
//                      ),
//
//                      leading: new Image.network("https://www.artnews.com/wp-content/uploads/2018/02/20264896_1385418231547596_1768501032407058786_n.jpg",width: 50.0,height: 50.0,),
//                      onTap: () =>
//                          _showonTapMessage(context, _data[position]['body']),
//
//
//                    )

                          );
                        }
                      ):new CircularProgressIndicator(),


                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  Future init()
  async {
    preferences=await SharedPreferences.getInstance();



  }

  getid()
  async {
    id=preferences.getString("id");
    setState(() {
      data=preferences.getString("id");

      debugPrint(preferences.getString("id").toString());
    });


  }
  Future _deleteNoDo(data, int position,String id) async {



    String url="http://manishvvasaniya.000webhostapp.com/rovehicle/delete.php?id="+id;
    debugPrint(url);
    http.Response response=await http.get(url);
    var data=json.decode(response.body);
    debugPrint(data.toString());
    if(response.statusCode==200)
    {
      setState(() {
        _data.removeAt(position);

      });
    }



  }

  getJson() async {
    String apiUrl = 'http://manishvvasaniya.000webhostapp.com/rovehicle/personvhicleDetail.php?id='+constant.u_id;
    debugPrint(apiUrl);

    http.Response response = await http.get(apiUrl);

    setState(() {
      _data=json.decode(response.body);

    });

    // TODO: implement build
  }


  itemclick(int index)
  {
    model model1=new model(_data[index]["id"],_data[index]["u_id"],_data[index]["v_photo"],_data[index]["v_type"],_data[index]["v_sub_type"],_data[index]["v_model"],_data[index]["v_brand"],_data[index]["v_rent"],_data[index]["v_licence_plate"],_data[index]["v_tnc"],);
    List<model> datalist=new List<model>();
    datalist.add(model1);
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext)=>new Updatevehicle(datalist1:datalist)));
  }
  void _showDialog(data, int position,String id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are U Sure?"),

          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                _deleteNoDo(data,position,id);
                Navigator.of(context).pop();
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



}