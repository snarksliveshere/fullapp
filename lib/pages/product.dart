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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex:8,
                  child: Text(
                    this.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: Text(
                      '${this.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900
                      ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0,),
            Text(this.description),
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
