import 'package:flutter/material.dart';

TextStyle normalText = TextStyle(
                          fontSize: 30, 
                          color: Colors.black, 
                          fontWeight: FontWeight.normal
                        );

final AppStyles appStyles = AppStyles();

class AppStyles {

  TextStyle normalTextStyle(double sizeFont) {
    return TextStyle(
              fontSize: sizeFont, 
              color: Colors.black, 
              fontWeight: FontWeight.normal);
  }


}
