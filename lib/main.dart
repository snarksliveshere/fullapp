import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import 'package:scoped_model/scoped_model.dart';
import './scoped_models/main.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';

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
   final MainModel _model = MainModel();

   @override
   void initState() {
    _model.autoAuthenticate();
     super.initState();
   }

  ThemeData _appConfig() {
    return ThemeData(
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
    );
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        theme: _appConfig(),
//      home: AuthPage(),
        routes: {
          '/': (BuildContext context) => _model.user == null ?  AuthPage() : ProductsPage(_model),
          '/products': (BuildContext context) => ProductsPage(_model),
          '/admin': (BuildContext context) => ProductsAdmin(_model),

        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/'); // '/product' '/' '1'
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product = _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return  MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product)
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder:  (BuildContext context) => ProductsPage(_model)
          );
        },
      ),
    );
  }
}
