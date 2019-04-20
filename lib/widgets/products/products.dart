import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './product_card.dart';
import '../../scoped_models/main.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context,Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.length > 0) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
        itemCount: products.length,
      );
    }
    return Container();
  }
}
