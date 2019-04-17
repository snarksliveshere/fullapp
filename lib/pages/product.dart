import 'dart:async';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);

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
            body: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(this.imageUrl),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                ),
                Text(this.title),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Delete'),
                  // i want execute it when the pressed, so () => _show.., not just _showWarning...
                  onPressed: () => _showWarningDialog(context)
                )
              ],
            ))));
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
