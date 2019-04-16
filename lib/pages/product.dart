import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/food.jpg'),
            Container(margin: EdgeInsets.only(top: 10.0),),
            Text('Details'),
            Container(margin: EdgeInsets.only(top: 10.0),),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text('Back'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        )
      )
    );
  }
}