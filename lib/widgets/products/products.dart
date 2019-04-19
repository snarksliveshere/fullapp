import 'package:flutter/material.dart';
import './product_card.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  final List<Product> products;

  Products(this.products);
  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }

  Widget _buildProductList() {
    if (products.length > 0) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
        itemCount: products.length,
      );
    }
    return Container();
  }
}
