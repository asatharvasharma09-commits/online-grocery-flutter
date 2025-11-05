import 'package:flutter/material.dart';
import 'dart:math';
import 'seller_order_detail_screen.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  final List<String> _statusList = [
    'Pending',
    'Packed',
    'Dispatched',
    'Delivered',
    'Cancelled',
    'Returned',
  ];

  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _orders = List.generate(6, (i) {
    final statuses = ['Pending', 'Dispatched', 'Delivered', 'Cancelled'];
    final random = Random();
    return {
      'orderId': '#ORD${1000 + random.nextInt(999)}',
      'customerName': ['Rahul Mehta', 'Neha Sharma', 'Rohit Verma', 'Priya Singh', 'Amit Das', 'Kavita Jain'][i],
      'totalItems': random.nextInt(5) + 1,
      'totalAmount': 100 + random.nextInt(800),
      'paymentMode': random.nextBool() ? 'Online' : 'COD',
      'deliveryPartner': ['BlueDart', 'Delhivery', 'Shadowfax', 'XpressBees'][random.nextInt(4)],
      'deliveryMode': random.nextBool() ? 'Home Delivery' : 'Pickup Point',
      'expectedDate': '${random.nextInt(30) + 1} Nov 2025',
      'status': statuses[random.nextInt(statuses.length)],
    };
  });

  // 🟢 Status color mapper
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Dispatched':
        return Colors.blue;
      case 'Packed':
        return Colors.teal;
      case 'Cancelled':
        return Colors.redAccent;
      case 'Returned':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // 🧾 Filter logic
  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: const Color(0xFF3D8BF2),
        centerTitle: true,
        actions: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: _selectedFilter,
                icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
                items: ['All', ..._statusList]
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedFilter = val!),
              ),
            ),
          )
        ],
      ),

      // 🧩 Order Cards List
      body: _filteredOrders.isEmpty
          ? const Center(
              child: Text(
                "No orders found for this filter!",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🧾 Order Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['orderId'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D8BF2),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: order['status'],
                                icon: const Icon(Icons.arrow_drop_down),
                                dropdownColor: Colors.white,
                                items: _statusList.map((status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Row(
                                      children: [
                                        Icon(Icons.circle,
                                            size: 10, color: _getStatusColor(status)),
                                        const SizedBox(width: 6),
                                        Text(status),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newStatus) {
                                  setState(() => order['status'] = newStatus!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Order ${order['orderId']} marked as $newStatus ✅"),
                                      backgroundColor: _getStatusColor(newStatus!),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // 👤 Customer Details
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 18, color: Colors.black54),
                            const SizedBox(width: 6),
                            Text(order['customerName'],
                                style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // 📦 Total Items + Amount
                        Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined,
                                size: 18, color: Colors.black54),
                            const SizedBox(width: 6),
                            Text("${order['totalItems']} items"),
                            const SizedBox(width: 12),
                            const Icon(Icons.currency_rupee,
                                size: 18, color: Colors.black54),
                            Text("${order['totalAmount']}"),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // 💳 Payment Mode
                        Row(
                          children: [
                            const Icon(Icons.payment_outlined,
                                size: 18, color: Colors.black54),
                            const SizedBox(width: 6),
                            Text(order['paymentMode']),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // 🚚 Delivery Details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.local_shipping_outlined,
                                size: 18, color: Colors.black54),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Partner: ${order['deliveryPartner']}"),
                                  Text("Mode: ${order['deliveryMode']}"),
                                  Text("Expected: ${order['expectedDate']}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        const Divider(),

                        // 🔍 View Details Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF3D8BF2),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SellerOrderDetailScreen(order: order),
                                ),
                              );
                            },
                            icon: const Icon(Icons.visibility_outlined, size: 18),
                            label: const Text("View Details"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}