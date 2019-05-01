import 'package:flutter/material.dart';
final ThemeData _androidTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    accentColor: Colors.deepPurple,
    backgroundColor: Colors.white,
    buttonColor: Colors.blue,
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent
//          textTheme: TextTheme(button: TextStyle(color: Colors.white))
    )
//        fontFamily: 'Oswald'
);

final ThemeData _iOSTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    accentColor: Colors.deepPurple,
    backgroundColor: Colors.white,
    buttonColor: Colors.blue,
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent
//          textTheme: TextTheme(button: TextStyle(color: Colors.white))
    )
//        fontFamily: 'Oswald'
);

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.android
      ? _androidTheme
      : _iOSTheme
  ;
}