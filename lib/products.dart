import 'package:flutter/material.dart';

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
                Flexible(
                  flex: 10,
                  child: Text(
                    this.products[index]['title'],
                    style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald'),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  flex: 6,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          '\$${this.products[index]['price']}',
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            )),
        DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, style: BorderStyle.solid, width: 1.0),
                borderRadius: BorderRadius.circular(6.0)),
            child: Padding(
                child: Text('Union Square, San Francisco'),
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5))),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('details'),
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
