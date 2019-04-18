import 'package:flutter/material.dart';
import 'package:fullapp/widgets/products/products.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Products(products),
        )
      ],
    );
  }
}
