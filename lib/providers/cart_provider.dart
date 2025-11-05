import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _items = {}; // name → quantity
  final Map<String, String> _prices = {}; // name → price

  Map<String, int> get items => _items;

  void addToCart(String name, String price) {
    if (_items.containsKey(name)) {
      _items[name] = _items[name]! + 1;
    } else {
      _items[name] = 1;
      _prices[name] = price;
    }
    notifyListeners();
  }

  void removeFromCart(String name) {
    if (_items.containsKey(name)) {
      if (_items[name]! > 1) {
        _items[name] = _items[name]! - 1;
      } else {
        _items.remove(name);
        _prices.remove(name);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _prices.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((name, qty) {
      final price =
          double.tryParse(_prices[name]!.replaceAll('₹', '').trim());
      if (price != null) total += price * qty;
    });
    return total;
  }

  // Optional helper methods for backward compatibility
  Map<String, int> get cartItems => _items;
  void addItem(String name) => addToCart(name, _prices[name] ?? '0');
  void removeItem(String name) => removeFromCart(name);
}