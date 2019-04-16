import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;
  Products([this.products = const []]);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(
          children: <Widget>[
            Image.asset('assets/food.jpg'),
            Text(this.products[index])
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
