import 'package:flutter/material.dart';
import './price_tag.dart';
import './product_address.dart';
import './product_title.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(
      children: <Widget>[
        Image.asset(this.products[index]['image']),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProductTitle(title: this.products[index]['title']),
                SizedBox(
                  width: 8.0,
                ),
              PriceTag(this.products[index]['price'].toString()),
              ],
            )),
        DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, style: BorderStyle.solid, width: 1.0),
                borderRadius: BorderRadius.circular(6.0)),
            child: ProductAddress()
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.pushNamed<bool>(
                  context, '/product/' + index.toString()),
            ),
            IconButton(
              icon: Icon(Icons.favorite_border),
              color: Colors.red,
              onPressed: () => Navigator.pushNamed<bool>(
                  context, '/product/' + index.toString()),
            )
          ],
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }

  Widget _buildProductList() {
    if (products.length > 0) {
      return ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    }
    return Container();
  }
}
