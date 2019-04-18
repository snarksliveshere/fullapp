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
  String _titleValue;
  String _descriptionValue;
  double _priceValue;

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
                  this._titleValue = value;
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
                  this._descriptionValue = value;
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
                  this._priceValue = double.parse(value);
                });
              },
            ),
            // occupied some space ~ height & width
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Save'),
              textColor: Colors.white,
              color: Theme.of(context).accentColor,
              onPressed: () {
                final Map<String, dynamic> product = {
                  'title': this._titleValue,
                  'description': this._descriptionValue,
                  'price': this._priceValue,
                  'image': 'assets/food.jpg'
                };
                widget.addProduct(product);
                Navigator.pushReplacementNamed(context, '/products');
              },
            )
          ],
    ));
  }
}
