import 'package:flutter/material.dart';

import './product_create.dart';
import './product_list.dart';

class ProductsAdmin extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;

  ProductsAdmin(this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
        drawer: Drawer(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('All Products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/products');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
            title: Text('Product Admin'),
            bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.create),
                    text: 'Create Product',
                  ),
                  Tab(
                    icon: Icon(Icons.list),
                    text: 'My products',
                  )
                ]
            ),
        ),
        body: TabBarView(
            children: <Widget>[
              ProductCreatePage(this.addProduct),
              ProductListPage()
            ]
        ),
    ));
  }
}
