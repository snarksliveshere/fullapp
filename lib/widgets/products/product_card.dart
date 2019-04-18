import 'package:flutter/material.dart';

import './price_tag.dart';
import 'package:fullapp/widgets/ui_elements/address_tag.dart';
import 'package:fullapp/widgets/ui_elements/title_default.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> _products;
  final int _productIndex;

  ProductCard(this._products, this._productIndex);

  Widget _buildTitlePriceRow() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
//              textBaseline: TextBaseline.ideographic,
//              crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(title: this._products['title']),
            SizedBox(
              width: 8.0,
            ),
            PriceTag(this._products['price'].toString()),
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + this._productIndex.toString()),
        ),
        IconButton(
          icon: Icon(Icons.favorite_border),
          color: Colors.red,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + this._productIndex.toString()),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        Image.asset(this._products['image']),
        _buildTitlePriceRow(),
        DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, style: BorderStyle.solid, width: 1.0),
                borderRadius: BorderRadius.circular(6.0)),
            child: AddressTag('Union Square, San Francisco')),
        _buildActionButtons(context)
      ],
    ));
  }
}
