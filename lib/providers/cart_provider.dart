import 'package:flutter/material.dart';
import 'package:flutter_virash/cartDataType.dart';

class CartProvider with ChangeNotifier {
  List<CartPojo> _cartList = [];

  int get cartCount => _cartList.length;

  List<CartPojo> get cartList => _cartList;

  void setCart(List<CartPojo> cart) {
    _cartList = cart;
    notifyListeners();
  }

  void addToCart(CartPojo cartItem) {
    _cartList.add(cartItem);
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cartList.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
