import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(
          children: <Widget>[
            Image.asset(this.products[index]['image']),
            Text(this.products[index]['title']),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'details'
                  ),
                  onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + index.toString()
                  ),
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
