import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fullapp/widgets/ui_elements/title_default.dart';
import '../widgets/products/price_tag.dart';
import 'package:fullapp/widgets/ui_elements/address_tag.dart';

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
            TitleDefault(title: this.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: <Widget>[
                AddressTag('Union Square, SF'),
                Text(' | ', style: TextStyle(color: Colors.grey),),
                PriceTag(this.price.toString())
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
