import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selfProductIndex;
  static const String serverUrl = 'https://flutter-products-54c8e.firebaseio.com/';
  bool _isLoading = false;

  void addProduct(String title, String description, String image, double price) {
    _isLoading = true;
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': 'https://www.google.ru/url?sa=i&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwiCt6aF5t7hAhWuy6YKHYiaAtUQjRx6BAgBEAU&url=https%3A%2F%2Fbowwowinsurance.com.au%2Fdogs%2Fdog-breeds%2Fcollie%2F&psig=AOvVaw17f7J8Vu-5XwCa6MWFY3PY&ust=1555854015838917',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    http.post('$serverUrl/products.json', body: jsonEncode(productData))
        .then((http.Response response) {
            _isLoading = false;
            final Map<String, dynamic> responseData = json.decode(response.body);
            final Product newProduct = Product(
                id: responseData['name'],
                title: title,
                description: description,
                price: price,
                image: image,
                userEmail: _authenticatedUser.email,
                userId: _authenticatedUser.id
            );
            _products.add(newProduct);
            notifyListeners();
        });

  }

}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'sdf', email: email, password: password);
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

  int get selectedProductIndex => _selfProductIndex;

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void fetchProducts() {
    _isLoading = true;
    http.get('${ConnectedProductsModel.serverUrl}/products.json')
        .then((http.Response response) {
          final List<Product> fetchedProductList = [];
          final Map<String, dynamic> productListData = jsonDecode(response.body);
          if (productListData == null) {
            _isLoading = false;
            notifyListeners();
            return;
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
        });
  }

  void updateProduct(String title, String description, String image, double price) {
    final Product udpatedProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId
    );
    _products[selectedProductIndex] = udpatedProduct;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selfProductIndex = index;
    if (null != index) {
      notifyListeners();
    }
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = _products[selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updateProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus
    );
    _products[selectedProductIndex] = updateProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading => _isLoading;
}