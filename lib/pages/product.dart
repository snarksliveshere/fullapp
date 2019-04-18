import 'dart:async';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;

  ProductPage(this.title, this.imageUrl, this.description, this.price);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print('back button pressed');
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(this.title),
            ),
            body: _showProductAttributes(context)
        ));
  }

  Widget _showProductAttributes(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(this.imageUrl),
            Container(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: <Widget>[
                Text(
                    'Union Square, San Francisco',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      color: Colors.grey,
                      fontWeight: FontWeight.w700
                    ),

                ),
                Text(' | ', style: TextStyle(color: Colors.grey),),
                Text(
                  '\$${this.price}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  this.description,
                  textAlign: TextAlign.center,
              ),
//              alignment: Alignment.center,
            )
          ],
        ));
  }

  _showWarningDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are u sure'),
            content: Text('this action cannot be undone'),
            actions: <Widget>[
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        }
    );
  }
}
