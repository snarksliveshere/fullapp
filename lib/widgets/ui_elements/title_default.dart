import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;

  TitleDefault({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        this.title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 26.0,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
