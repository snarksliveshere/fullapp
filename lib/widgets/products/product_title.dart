import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final String title;

  ProductTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
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
