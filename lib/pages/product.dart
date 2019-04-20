import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../scoped_models/main.dart';
import 'package:fullapp/widgets/ui_elements/title_default.dart';
import '../widgets/products/price_tag.dart';
import 'package:fullapp/widgets/ui_elements/address_tag.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false
          );
          return Future.value(false
          );
        },
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            final Product product = model.allProducts[this.productIndex];

            return Scaffold(
              appBar: AppBar(title: Text(product.title)),
              body: _showProductAttributes(context, product),
            );
          },
        ),
    );
  }

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textBaseline: TextBaseline.ideographic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: <Widget>[
        AddressTag('Union Square, SF'
        ),
        Text(
          ' | ',
          style: TextStyle(color: Colors.grey
          ),
        ),
        PriceTag(price.toString()
        )
      ],
    );
  }

  Widget _showProductAttributes(BuildContext context, Product product) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(product.image
            ),
            TitleDefault(title: product.title
            ),
            _buildAddressPriceRow(product.price
            ),
            Container(
              padding: EdgeInsets.all(10.0
              ),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
//              alignment: Alignment.center,
            )
          ],
        )
    );
  }

  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are u sure'
            ),
            content: Text('this action cannot be undone'
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Discard'
                ),
                onPressed: () {
                  Navigator.pop(context
                  );
                },
              ),
              FlatButton(
                child: Text('Continue'
                ),
                onPressed: () {
                  Navigator.pop(context
                  );
                  Navigator.pop(context, true
                  );
                },
              ),
            ],
          );
        }
    );
  }
}
