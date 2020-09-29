import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  double bottomMargin;
  TextStyle textStyle, hintStyle;
  var validateFunction;
  var onSaved;
  Key key;
  int limit;
  int maxline;
  bool enable;

  //passing props in the Constructor.
  //Java like style
  InputField(
      {this.key,
      this.hintText,
      this.obscureText,
      this.textInputType,
      this.textFieldColor,
      this.icon,
      this.iconColor,
      this.bottomMargin,
      this.textStyle,
      this.validateFunction,
      this.onSaved,
        this.limit,
        this.maxline,
      this.hintStyle,this.enable});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin),

          child: new TextFormField(

            style:TextStyle(color: Colors.green.shade800),
            key: key,
            maxLength: limit,
            obscureText: obscureText,
            keyboardType: textInputType,
            validator: validateFunction,
            maxLines: maxline,
            maxLengthEnforced: true,
            onSaved: onSaved,
            enabled: enable,
            decoration: new InputDecoration(


          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              
              hintText: hintText,
              hintStyle: hintStyle,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(30.0),borderSide: BorderSide(color: Colors.green)),
              prefixIcon: new Icon(icon,color: iconColor,),

            ),
          ),
        ));
  }
}
