import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import 'package:scoped_model/scoped_model.dart';
import './scoped_models/products.dart';

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
    return ScopedModel<ProductsModel>(
      model: ProductsModel(),
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        theme: _appConfig(),
//      home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(),
          '/admin': (BuildContext context) => ProductsAdmin(),

        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/'); // '/product' '/' '1'
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final int index = int.parse(pathElements[2]);
            return  MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(null, null, null, null)
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder:  (BuildContext context) => ProductsPage()
          );
        },
      ),
    );
  }
}
