import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavorites = false;

  List<Product> get products {
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

  int get selectedProductIndex => _selectedProductIndex;

  Product get selectedProduct {
    if (_selectedProductIndex == null) {
      return null;
    }
    return _products[_selectedProductIndex];
  }

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = _products[_selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updateProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavorite: newFavoriteStatus
    );
    _products[_selectedProductIndex] = updateProduct;
    _selectedProductIndex = null;
    notifyListeners();
    _selectedProductIndex = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
