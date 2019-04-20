import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';
import './connected_products.dart';

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    authenticatedUser = User(id: 'sdf', email: email, password: password);
  }
}