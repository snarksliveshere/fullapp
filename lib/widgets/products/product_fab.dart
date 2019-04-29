import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';
import '../../models/product.dart';

class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);

  @override
  State createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    mini: true,
                    heroTag: 'contact',
                    child: Icon(Icons.mail, color: Theme.of(context).primaryColor,),
                    onPressed: () {

                    }
                ),
              ),
              Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    mini: true,
                    heroTag: 'favorite',
                    child: Icon(Icons.favorite, color: Colors.red,),
                    onPressed: () {

                    }
                ),
              ),
              Container(
                height: 70.0,
                width: 56.0,
                child: FloatingActionButton(
                    mini: true,
                    heroTag: 'options',
                    child: Icon(Icons.more_vert),
                    onPressed: () {

                    }
                ),
              ),
            ]
        );
      }
    );
  }
}