import 'package:flutter/material.dart';
import './product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;
  ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.asset(this.products[index]['image']),
            title: Text(this.products[index]['title']),
            trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ProductEditPage(
                            product: this.products[index],
                            updateProduct: this.updateProduct,
                            productIndex: index,
                        );
                      }
                  ));
                }
            ),

          );
        },
        itemCount: products.length,
    );
  }
}