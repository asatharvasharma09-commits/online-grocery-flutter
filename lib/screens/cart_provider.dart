import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _cartItems = {};

  Map<String, int> get cartItems => _cartItems;

  void addItem(String itemName) {
    if (_cartItems.containsKey(itemName)) {
      _cartItems[itemName] = _cartItems[itemName]! + 1;
    } else {
      _cartItems[itemName] = 1;
    }
    notifyListeners();
  }

  void removeItem(String itemName) {
    if (_cartItems.containsKey(itemName)) {
      if (_cartItems[itemName]! > 1) {
        _cartItems[itemName] = _cartItems[itemName]! - 1;
      } else {
        _cartItems.remove(itemName);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount {
    int count = 0;
    for (var qty in _cartItems.values) {
      count += qty;
    }
    return count;
  }
}