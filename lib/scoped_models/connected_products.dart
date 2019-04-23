import 'dart:async';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selfProductId;
  static const String serverUrl =
      'https://flutter-products-54c8e.firebaseio.com/';
  static const String API_KEY = 'AIzaSyBkPxjwhCUo7U6gSY54zJ5j66aW3SLwYRY';
  bool _isLoading = false;
}

mixin UserModel on ConnectedProductsModel {

  final String _signUpServerUrl = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${ConnectedProductsModel.API_KEY}';
  final String _signInServerUrl = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${ConnectedProductsModel.API_KEY}';

  Future<Map<String, dynamic>> authenticate(String email, String password, [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          _signInServerUrl,
          body: jsonEncode(authData),
          headers: {'Content-Type': 'application/json'}
      );
    } else {
      response = await http.post(
          _signUpServerUrl,
          body: jsonEncode(authData),
          headers: {'Content-Type': 'application/json'}
      );
    }


//    _authenticatedUser = User(id: 'sdf', email: email, password: password);
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authenticated succeeded';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This Email wasn`t found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid';
    }
    else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This Email already exists';
    }
    _isLoading = false;
    notifyListeners();
    return {
      'success': !hasError,
      'message': message
    };
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    // cause i don`t want return a Pointer! - we wouldn`t edit the original list
    return List.from(_products);
  }

  bool get displayFavoritesOnly => _showFavorites;

  List<Product> get displayedProducts {
    if (_showFavorites) {
      // toList - where method return Iterable, I need a List
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId => _selfProductId;

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selfProductId;
    });
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://bowwowinsurance.com.au/wp-content/uploads/2018/10/collie-rough-700x700.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response = await http.post('${ConnectedProductsModel.serverUrl}/products.json',
          body: jsonEncode(productData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selfProductId = null;
    notifyListeners();
    return http
        .delete(
            '${ConnectedProductsModel.serverUrl}/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('${ConnectedProductsModel.serverUrl}/products.json')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = jsonDecode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return null;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
        );
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selfProductId = null;
      return null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'image':
          'https://bowwowinsurance.com.au/wp-content/uploads/2018/10/collie-rough-700x700.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            '${ConnectedProductsModel.serverUrl}/products/${selectedProduct.id}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String productId) {
    _selfProductId = productId;
    if (null != productId) {
      notifyListeners();
    }
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updateProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updateProduct;
    notifyListeners();
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selfProductId;
    });
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading => _isLoading;
}
