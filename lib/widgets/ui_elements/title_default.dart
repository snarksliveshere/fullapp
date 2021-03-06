import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;

  TitleDefault({this.title});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Flexible(
      child: Container(
        child: Text(
          this.title,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: deviceWidth > 700 ? 26.0 : 19.0,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
