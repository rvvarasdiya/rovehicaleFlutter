import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:rovehiclefinal/Home/AddVehicle.dart';



class CustomCamera extends StatefulWidget {
  List<CameraDescription> cam;
  CustomCamera({Key key, this.cam }) : super(key: key);

  @override
  _Camera createState() {

    return new _Camera();
  }


}

/// Returns a suitable camera icon for [direction].
//IconData getCameraLensIcon(CameraLensDirection direction) {
//  switch (direction) {
//    case CameraLensDirection.back:
//      return Icons.camera_rear;
//    case CameraLensDirection.front:
//      return Icons.camera_front;
//    case CameraLensDirection.external:
//      return Icons.camera;
//  }
//  throw new ArgumentError('Unknown lens direction');
//}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _Camera extends State<CustomCamera> {
  CameraController controller;
  String imagePath;
  String videoPath;
  String _platformMessage = 'No Error';
  List images=new List<String>();
  int maxImageNo = 5;
  bool selectSingleImage = false;
  VoidCallback videoPlayerListener;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {

      _platformMessage = 'No Error';
    });
       controller = new CameraController(widget.cam[0], ResolutionPreset.high);
       controller.initialize().then((_) {
         if (!mounted) {
           return;
         }
         setState(() {});
       });

  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Size size;
  @override
  Widget build(BuildContext context) {

    size=MediaQuery.of(context).size;
    onNewCameraSelected;
    return new Scaffold(



      key: _scaffoldKey,
      appBar: AppBar(
        title: new Title(child: new Text("Add Vehicle"),color: Colors.white,),
        backgroundColor: Colors.green,
      ),

      body:new Container(
        height: size.height-80,
        child:  new Column(
          children: <Widget>[
      new Stack(

        children: <Widget>[

          Container(
            height: size.height-80,
            width: size.width,

            child:  _cameraPreviewWidget(),
          ),



          _captureControlRowWidget(),


//          new Padding(
//            padding: const EdgeInsets.all(5.0),
//            child: new Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                _cameraTogglesRowWidget(),
//                _thumbnailWidget(),
//              ],
//            ),
//          ),
        ],
      ),


          ],
        )

      )
    );
  }


  initMultiPickUp() async {
    setState(() {

      _platformMessage = 'No Error';
    });
    List resultList=new List<String>();
    String error;

    if(images.length<5) {
      try {
        resultList = await FlutterMultipleImagePicker.pickMultiImages(
            (5 - images.length), selectSingleImage);
      } on PlatformException catch (e) {
        error = e.message;
      }
    }else
      {
        Fluttertoast.showToast(
            msg: "You Can Select Only 5 Images",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIos: 1
        );
      }
    if (!mounted) return;

    setState(() {
      for(int i=0;i<resultList.length;i++)
      {
        setState(() {
          images.add(resultList[i]);

        });
      }
      //  images=resultList;
      if (error == null) _platformMessage = 'No Error Dectected';
    });
  }


  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new CameraPreview(controller),
      );
    }
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return new Expanded(
      child: new Align(
        alignment: Alignment.centerRight,

      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return new Container(

      height: size.height-80,
      child: new Column(
        children: <Widget>[
          new Container(

            height: size.height/1.6,
            child: new Center(
                child: new Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(border: Border.all(width: 2.0,color: Colors.grey),shape: BoxShape.circle),
                  child: new IconButton(
                    icon: const Icon(Icons.photo_camera),
                    iconSize: 70.0,
                    padding: EdgeInsets.all(0.0),

                    color: Colors.grey,
                    onPressed: controller != null &&
                        controller.value.isInitialized
                        ? onTakePictureButtonPressed
                        : null,
                  ),
                )

            ),
          ),
          new Expanded(


            child:new Stack(
              children: <Widget>[
                images==null
                    ? new Container(

                )


                    :new SizedBox(
                  height: 250.0,
                  width: 500.0,
                  child: new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                    new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:new Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[




                            new Image.file(
                              new File(images[index].toString()),width: 90.0,height: 250.0,fit: BoxFit.cover,
                            ),
                            new Align(
                              alignment: Alignment.center,
                              child: new RaisedButton(onPressed: (){
                                setState(() {
                                  images.removeAt(index);
                                });

                              },child:Icon(Icons.close),color: Colors.white,shape: CircleBorder(side:BorderSide()),),
                            )
                          ],
                        )
                    ),
                    itemCount: images.length,
                  ),
                ),
                
               new Padding(padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 13.0),
               child:  new Align(
                   alignment: Alignment.bottomLeft,
                   child:new FlatButton(splashColor: Colors.yellow,onPressed:initMultiPickUp, child:new Icon(Icons.photo,color: Colors.white,),color: Colors.green.shade800,shape: CircleBorder(side: BorderSide(width: 0.0)),padding: EdgeInsets.all(16.0),))
                 ,
               ),
               new Padding(padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 13.0),
                 child:  new Align(
                     alignment: Alignment.bottomRight,
                     child:new FlatButton(onPressed:images.length == 0 ? null:(){

                       List<File> image=new List();
                       for(int i=0;i<images.length;i++)
                         {
                           File image1=new File(images[i]);
                           image.add(image1);
                         }
                       Navigator.push(context, new MaterialPageRoute(builder: (context)=>new AddVehicle(image: image,)));

                     }, child:new Icon(Icons.navigate_next,color: Colors.white,),color: Colors.green.shade800,shape: CircleBorder(side: BorderSide(width: 0.0)),padding: EdgeInsets.all(16.0),disabledColor: Colors.grey,))
                 ,
               )
              ],

            )
          )

        ],
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
//  Widget _cameraTogglesRowWidget() {
//    final List<Widget> toggles = <Widget>[];
//
//    if (cameras.isEmpty) {
//      return const Text('No camera found');
//    } else {
//      for (CameraDescription cameraDescription in cameras) {
//        toggles.add(
//          new SizedBox(
//            width: 90.0,
//            child: new RadioListTile<CameraDescription>(
//              title:
//              new Icon(getCameraLensIcon(cameraDescription.lensDirection)),
//              groupValue: controller?.description,
//              value: cameraDescription,
//              onChanged: controller != null && controller.value.isRecordingVideo
//                  ? null
//                  : onNewCameraSelected,
//            ),
//          ),
//        );
//      }
//    }
//
//    return new Row(children: toggles);
//  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    debugPrint("thai callllllllllllll");
    if (controller != null) {
      await controller.dispose();
    }
    controller = new CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() async {
    takePicture().then((String filePath) {
      if (mounted) {

        if (filePath != null) {

          if(images.length<5)
            {
          setState(() {
            imagePath = filePath;
            images.add(imagePath);
            debugPrint(filePath);

          });
            }
            else
              {
                Fluttertoast.showToast(
                    msg: "You Can Select Only 5 Images",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIos: 1
                );
              }


          //File image=File(imagePath);
        }
      }
    });
  }





  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }




  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }


}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new CustomCamera(),
    );
  }
}

