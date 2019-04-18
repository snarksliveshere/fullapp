import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String titleValue;
  String descriptionValue;
  double priceValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Product title',
              ),
              onChanged: (String value) {
                setState(() {
                  this.titleValue = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Product description',
              ),
              maxLines: 4,
              onChanged: (String value) {
                setState(() {
                  this.descriptionValue = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Product price',
              ),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  this.priceValue = double.parse(value);
                });
              },
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                final Map<String, dynamic> product = {
                  'title': this.titleValue,
                  'description': this.descriptionValue,
                  'price': this.priceValue,
                  'image': 'assets/food.jpg'
                };
                widget.addProduct(product);
              },
            )
          ],
    ));
  }
}
