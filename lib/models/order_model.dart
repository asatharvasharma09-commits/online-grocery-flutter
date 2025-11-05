// Order model + sample/mock orders
// Location: lib/models/order_model.dart

import 'package:flutter/foundation.dart';

/// A single product/item inside an order
class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price; // price per unit
  final String unitLabel; // e.g. "500ml", "1kg"

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.unitLabel = '',
  });

  double get lineTotal => price * quantity;
}

/// Main Order model
class Order {
  final String id; // unique order id (string for flexibility)
  final DateTime createdAt;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String deliveryPartner; // e.g. "Dunzo", "Local Rider"
  final String deliveryMode; // e.g. "Home Delivery", "Pickup"
  final String paymentMethod; // e.g. "COD", "UPI", "Card"
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double tax;
  final String status; // e.g. "Pending", "Confirmed", "Out for Delivery", "Delivered", "Cancelled"
  final List<OrderItem> items;
  final Map<String, dynamic>? extra; // place for future fields (notes, tracking id, etc.)

  Order({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.deliveryPartner,
    required this.deliveryMode,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.tax,
    required this.status,
    required this.items,
    this.extra,
  });

  double get total => subtotal + deliveryFee + tax - discount;

  int get totalItems => items.fold(0, (s, it) => s + it.quantity);
}

/// ---- Mock/sample orders for frontend development ----
final List<Order> sampleOrders = [
  Order(
    id: 'ORD-1001',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    customerName: 'Rahul Sharma',
    customerPhone: '+91 98765 43210',
    deliveryAddress: 'Flat 12A, Lotus Apartments, Andheri West, Mumbai',
    deliveryPartner: 'Local Rider',
    deliveryMode: 'Home Delivery',
    paymentMethod: 'UPI',
    subtotal: 230.0,
    deliveryFee: 20.0,
    discount: 10.0,
    tax: 4.14,
    status: 'Out for Delivery',
    items: [
      OrderItem(productId: 'P001', name: 'Amul Milk 500ml', quantity: 2, price: 30.0, unitLabel: '500ml'),
      OrderItem(productId: 'P010', name: 'Brown Bread 400g', quantity: 1, price: 40.0, unitLabel: '400g'),
      OrderItem(productId: 'P035', name: 'Bananas (6 pcs)', quantity: 1, price: 50.0, unitLabel: '6 pcs'),
    ],
    extra: {'trackingId': 'TRK1001'},
  ),
  Order(
    id: 'ORD-1002',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    customerName: 'Simran Kaur',
    customerPhone: '+91 91234 56789',
    deliveryAddress: 'Shop 5B, Vashi Market, Navi Mumbai',
    deliveryPartner: 'Dunzo',
    deliveryMode: 'Pickup',
    paymentMethod: 'Card',
    subtotal: 120.0,
    deliveryFee: 0.0,
    discount: 0.0,
    tax: 2.16,
    status: 'Delivered',
    items: [
      OrderItem(productId: 'P012', name: 'Lettuce (1 pc)', quantity: 1, price: 30.0, unitLabel: 'pc'),
      OrderItem(productId: 'P020', name: 'Tomato (1 kg)', quantity: 1, price: 40.0, unitLabel: '1kg'),
      OrderItem(productId: 'P025', name: 'Onions (1 kg)', quantity: 1, price: 50.0, unitLabel: '1kg'),
    ],
    extra: {'deliveredBy': 'Rider #22'},
  ),
  Order(
    id: 'ORD-1003',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    customerName: 'Anita Desai',
    customerPhone: '+91 99887 77665',
    deliveryAddress: 'Plot 9, Green Meadows, Pune',
    deliveryPartner: 'Local Rider',
    deliveryMode: 'Home Delivery',
    paymentMethod: 'COD',
    subtotal: 75.0,
    deliveryFee: 15.0,
    discount: 5.0,
    tax: 1.35,
    status: 'Confirmed',
    items: [
      OrderItem(productId: 'P007', name: 'Milk packet 1L', quantity: 1, price: 35.0, unitLabel: '1L'),
      OrderItem(productId: 'P039', name: 'Eggs (6 pcs)', quantity: 1, price: 40.0, unitLabel: '6 pcs'),
    ],
    extra: null,
  ),
];