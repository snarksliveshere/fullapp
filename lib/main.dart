import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled = true;
//  debugPaintPointersEnabled = true; // where tap event is registered
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _updateProduct(int index, Map<String, dynamic> product) {
    setState(() {
      _products[index] = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      debugShowMaterialGrid: true,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        buttonColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent
//          textTheme: TextTheme(button: TextStyle(color: Colors.white))
        )
//        fontFamily: 'Oswald'
      ),
//      home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/products': (BuildContext context) => ProductsPage(_products),
        '/admin': (BuildContext context) => ProductsAdmin( _addProduct, _updateProduct, _deleteProduct, _products),

      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/'); // '/product' '/' '1'
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);
          return  MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(
                  this._products[index]['title'],
                  this._products[index]['image'],
                  this._products[index]['description'],
                  this._products[index]['price'],
              )
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
                builder:  (BuildContext context) => ProductsPage(_products)
        );
      },
    );
  }
}
