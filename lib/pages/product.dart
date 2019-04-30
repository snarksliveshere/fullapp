import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/ui_elements/title_default.dart';
import '../widgets/ui_elements/address_tag.dart';
import '../widgets/products/price_tag.dart';
import '../widgets/products/product_fab.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false
          );
          return Future.value(false
          );
        },
        child: Scaffold(
            appBar: AppBar(title: Text(product.title)),
            body: _showProductAttributes(context, product),
            floatingActionButton: ProductFab(product)
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 256.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(product.title),
            background: Hero(
              tag: product.id,
              child: FadeInImage(
                image: NetworkImage(product.image),
                placeholder: AssetImage('assets/background.jpg'),
                height: 300.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
              TitleDefault(title: product.title),
              _buildAddressPriceRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              )
          ]),
        )
      ],
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
