import 'package:flutter/material.dart';

import 'package:rovehiclefinal/ui/arc_clipper.dart';

class LoginBackground extends StatelessWidget {
  final showIcon;
  final image;
  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.green.shade800,
    Colors.green.shade400,
  ];
  LoginBackground({this.showIcon = true, this.image});

  Widget topHalf(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return new Flexible(
      flex: 6,
      child: ClipPath(
        clipper: new ArcClipper(),
        child: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                colors: kitGradients,
              )),
            ),

          ],
        ),
      ),
    );
  }

  final bottomHalf = new Flexible(
    flex: 2,
    child: new Container(),
  );

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context), bottomHalf],
    );
  }
}
