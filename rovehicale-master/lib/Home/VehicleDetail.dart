  import 'dart:convert';

  import 'package:flutter/material.dart';
  import 'package:carousel_slider/carousel_slider.dart';
  import 'package:http/http.dart' as http;
  import 'package:rovehiclefinal/model/modelvehicledetail.php.dart';
  import 'package:rovehiclefinal/ui/login_background.dart';
  class VehicalDetail extends StatefulWidget {
      List<modeldetail> datalist;

    VehicalDetail({Key key, this.datalist }) : super(key: key);
    @override
    _VehicalDetailState createState() => _VehicalDetailState();
  }

  class _VehicalDetailState extends State<VehicalDetail> {
    Size size;
    String number="";
    CarouselSlider instance;
    List<String> imgList;
    @override
    void initState() {
      super.initState();
      loaddata();
      String img = widget.datalist[0].getv_photo();
      imgList=img.split("^");

      setState(() {


        debugPrint(imgList.toString());
        if(imgList.isEmpty)
          {
            imgList.add(widget.datalist[0].getv_photo());
          }
      });



    }

    @override
    Widget build(BuildContext context) {



      instance = new CarouselSlider(
        items: imgList.map((url) {
          return new Container(
              margin: new EdgeInsets.all(0.0),
              child: new ClipRRect(
                  borderRadius: new BorderRadius.all(new Radius.circular(0.0)),
                  child: new Image.network(url,
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,

                  )
              )
          );
        }).toList(),
        viewportFraction: 1.0,
  reverse: false,
  aspectRatio: 1.8,
        autoPlay: true,
      );
      debugPrint(widget.datalist[0].getv_photo());
      size=MediaQuery.of(context).size;
      return Scaffold(
        appBar:AppBar(
          title: new Text("Vehicle Info"),

        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              color: Colors.green.shade50,
            ),
            new SingleChildScrollView(
                child: new Column(

                  children: <Widget>[
                    new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 0.0),
                        child: imgList.length>1?instance:Container(
                          width: size.width,
                          height: size.height/2.8,
                          child: Image(image:NetworkImage(widget.datalist[0].getv_photo()),  fit: BoxFit.fitWidth,),
                        ),
                    ),

                    Card(

                      elevation: 2.0,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
                          width: size.width,
                          height: 70.0,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Text("Vehicle Name : "+widget.datalist[0].getv_model()+" (${widget.datalist[0].getv_sub_type()})",style: TextStyle(fontSize: 20.0),),
                              const SizedBox(height: 10.0),
                              Text("Vehicle Brand : "+widget.datalist[0].getv_brand(),style: TextStyle(fontSize: 12.0),),
                            ],
                          )
                      ),
                    ),
                    Card(

                      elevation: 2.0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                        width: size.width,
                        height: 50.0,
                        child: Text("Price per km : "+widget.datalist[0].getv_rent()+" INR",style: TextStyle(fontSize: 20.0),),
                      ),
                    ),
                    Card(

                      elevation: 2.0,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
                          width: size.width,
                          height: size.height/5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Term And Conditions ",style: TextStyle(fontSize: 20.0),),
                              const SizedBox(height: 10.0),
                              Text(widget.datalist[0].v_tnc(),style: TextStyle(fontSize: 12.0),),
                            ],
                          )
                      ),
                    ),
                    Card(

                      elevation: 2.0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
                        width: size.width,
                        height: 50.0,
                        child: Text("Owner Number : "+number,style: TextStyle(fontSize: 20.0),),
                      ),
                    ),

                  ],

                )

            ),
          ],
        )
      );
    }
  loaddata() async
  {
    String url = "http://manishvvasaniya.000webhostapp.com/rovehicle/user.php?id="+
        widget.datalist[0].getuid();
    debugPrint(url);
    http.Response response = await http.get(url);
    String data1 = response.body;
    var body = json.decode(data1);
    setState(() {
      number=body[0]['contact_no'];

    });
    debugPrint(number);
  }
  }

