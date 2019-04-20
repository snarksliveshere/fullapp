import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import 'package:fullapp/widgets/ui_elements/address_tag.dart';
import 'package:fullapp/widgets/ui_elements/title_default.dart';
import '../../models/product.dart';
import '../../scoped_models/main.dart';

class ProductCard extends StatelessWidget {
  final Product _products;
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
            TitleDefault(title: this._products.title),
            SizedBox(
              width: 8.0,
            ),
            PriceTag(this._products.price.toString()),
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + model.allProducts[_productIndex].id),
              ),
              IconButton(
                  icon: Icon(model.allProducts[_productIndex].isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {
                    model.selectProduct(model.allProducts[_productIndex].id);
                    model.toggleProductFavoriteStatus();
                  },
                )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(this._products.image),
            placeholder: AssetImage('assets/background.jpg'),
            height: 300.0,
            fit: BoxFit.cover,
          ),
          _buildTitlePriceRow(),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey, style: BorderStyle.solid, width: 1.0),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: AddressTag('Union Square, San Francisco'),
          ),
          Text(_products.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
