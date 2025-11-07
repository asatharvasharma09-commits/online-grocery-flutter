import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image': image,
        'quantity': quantity,
      };

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        image: json['image'],
        quantity: json['quantity'],
      );
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems => _cartItems;

  CartProvider() {
    _loadCartFromPrefs();
  }

  // ➕ Add an item to the cart
  void addItem({
    required String id,
    required String name,
    required double price,
    required String image,
  }) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity += 1;
    } else {
      _cartItems[id] = CartItem(
        id: id,
        name: name,
        price: price,
        image: image,
      );
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  // ➖ Remove one quantity of an item
  void removeItem(String id) {
    if (_cartItems.containsKey(id)) {
      if (_cartItems[id]!.quantity > 1) {
        _cartItems[id]!.quantity -= 1;
      } else {
        _cartItems.remove(id);
      }
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  // ❌ Completely delete an item
  void deleteItem(String id) {
    _cartItems.remove(id);
    _saveCartToPrefs();
    notifyListeners();
  }

  // 🧹 Clear the entire cart
  void clearCart() {
    _cartItems.clear();
    _saveCartToPrefs();
    notifyListeners();
  }

  // 🧮 Get total number of items
  int get itemCount => _cartItems.values.fold(0, (sum, item) => sum + item.quantity);

  // 💰 Calculate total price
  double get totalPrice => _cartItems.values
      .fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // 🔁 Update quantity manually
  void updateQuantity(String id, int quantity) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity = quantity;
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  // 💾 Save cart data locally
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _cartItems.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString('cart_data', encoded);
  }

  // 📦 Load cart data from local storage
  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cart_data');
    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      _cartItems
        ..clear()
        ..addAll(decoded.map((key, value) => MapEntry(key, CartItem.fromJson(value))));
      notifyListeners();
    }
  }
}