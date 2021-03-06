import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';
import '../widgets/products/products.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../widgets/ui_elements/adaptive_progress_indicator.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State createState() {
    return _ProductsPageState();
  }
}
class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child:Text('no products found'));
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: AdaptiveProgressIndicator());
        }
        return RefreshIndicator(
            child: content,
            onRefresh: model.fetchProducts,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('AdList'),
        actions: <Widget>[
          ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            }
          )
        ],
      ),
      body: _buildProductsList(),
    );
  }
}
