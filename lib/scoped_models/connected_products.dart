import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';


import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../app_config/config.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selfProductId;
  static const String serverUrl =
      'https://flutter-products-54c8e.firebaseio.com/';
  static const String API_KEY = firebaseApiKey;
  bool _isLoading = false;
}

mixin UserModel on ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  final String _signUpServerUrl = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${ConnectedProductsModel.API_KEY}';
  final String _signInServerUrl = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${ConnectedProductsModel.API_KEY}';

  User get user => _authenticatedUser;

  PublishSubject<bool> get userSubject => _userSubject;

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

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authenticated succeeded';
      _authenticatedUser = User(id: responseData['localId'], email: email, token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
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

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;

      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout () async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    _selfProductId = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.clear();
    prefs.remove('token');
    prefs.remove('userId');
    prefs.remove('userEmail');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(
      Duration(
        seconds: time
      ),
      logout
    );
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

  Future<Map<String, dynamic>> uploadImage(File image, {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse('https://us-central1-flutter-products-54c8e.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
    );
    
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }

    imageUploadRequest.headers['Authorization'] = 'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('response wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;

    } catch (error) {
      print(error);
      return null;
    }

  }

  Future<bool> addProduct(
      String title, String description, File image, double price) async {
    _isLoading = true;
    notifyListeners();

    final uploadData = await this.uploadImage(image);
    if (uploadData == null) {
      print('upload failed');
      return false;
    }
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response = await http.post('${ConnectedProductsModel.serverUrl}/products.json?auth=${_authenticatedUser.token}',
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
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
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
            '${ConnectedProductsModel.serverUrl}/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
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

  Future<Null> fetchProducts({onlyForUser: false, clearExisting = false}) {
    _isLoading = true;
    if (clearExisting) {
      _products = [];
    }
    notifyListeners();
    return http
        .get('${ConnectedProductsModel.serverUrl}/products.json?auth=${_authenticatedUser.token}')
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
          image: productData['imageUrl'],
          imagePath: productData['imagePath'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
          isFavorite: productData['wishlistUser'] == null
              ? false
              : (productData['wishlistUser'] as Map<String, dynamic>).containsKey(_authenticatedUser.id)
        );
        fetchedProductList.add(product);
      });
      _products = onlyForUser
          ? fetchedProductList.where((Product product) {
        return product.userId == _authenticatedUser.id;
      }).toList()
          : fetchedProductList;
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
      String title, String description, File image, double price) async {
    _isLoading = true;
    notifyListeners();
    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if (image != null) {
      final uploadData = await this.uploadImage(image);
      if (uploadData == null) {
        print('upload failed');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };

    try {
      await http
          .put(
          '${ConnectedProductsModel.serverUrl}/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updatedData));
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: imageUrl,
          imagePath: imagePath,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void selectProduct(String productId) {
    _selfProductId = productId;
    if (null != productId) {
      notifyListeners();
    }
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final String urlGetCertainProduct = 'https://flutter-products-54c8e.firebaseio.com/products';
    final Product updateProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        imagePath: selectedProduct.imagePath,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updateProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
       response = await http.put('$urlGetCertainProduct/${selectedProduct.id}/wishlistUser/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
        body: jsonEncode(true)
      );
    } else {
      response = await http.delete('$urlGetCertainProduct/${selectedProduct.id}/wishlistUser/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updateProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          imagePath: selectedProduct.imagePath,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus);
      _products[selectedProductIndex] = updateProduct;
      notifyListeners();
    }
//    _selfProductId = null;
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
