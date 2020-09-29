import 'package:flutter/material.dart';

import 'package:rovehiclefinal/ui/login_background.dart';

class GradientButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;

  GradientButton({@required this.onPressed, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))),

      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.yellow,
          child: Ink(
            height: 46.0,
            decoration: BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                gradient: LinearGradient(
              colors: LoginBackground.kitGradients,

            )),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0),
              ),
            ),
          ),
      ),
    );
  }
}
