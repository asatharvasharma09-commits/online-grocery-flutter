import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final List<Map<String, String>> _orders = [
    {
      'id': '#1001',
      'customer': 'Riya Sharma',
      'items': '2 items • ₹180',
      'status': 'Pending',
      'date': '22 Oct 2025'
    },
    {
      'id': '#1002',
      'customer': 'Aditya Verma',
      'items': '1 item • ₹90',
      'status': 'Shipped',
      'date': '21 Oct 2025'
    },
    {
      'id': '#1003',
      'customer': 'Priya Singh',
      'items': '3 items • ₹260',
      'status': 'Delivered',
      'date': '20 Oct 2025'
    },
    {
      'id': '#1004',
      'customer': 'Rohit Mehta',
      'items': '2 items • ₹150',
      'status': 'Cancelled',
      'date': '19 Oct 2025'
    },
  ];

  List<Map<String, String>> get orders => _orders;

  // Get a specific order by ID
  Map<String, String>? getOrderById(String id) {
    return _orders.firstWhere((order) => order['id'] == id, orElse: () => {});
  }

  // Update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order['id'] == orderId);
    if (index != -1) {
      _orders[index]['status'] = newStatus;
      notifyListeners(); // 🔥 refresh UI everywhere
    }
  }
}