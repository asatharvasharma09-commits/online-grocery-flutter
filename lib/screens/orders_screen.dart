import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Map<String, dynamic>> _orders = [
    {
      'title': 'Fruits - 3 items',
      'price': '₹220',
      'date': '8 Oct 2025',
      'status': 'Delivered',
    },
    {
      'title': 'Vegetables - 5 items',
      'price': '₹340',
      'date': '9 Oct 2025',
      'status': 'Out for Delivery',
    },
    {
      'title': 'Berries - 2 items',
      'price': '₹180',
      'date': '7 Oct 2025',
      'status': 'Delivered',
    },
  ];

  String _selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D8BF2);

    final filteredOrders = _selectedFilter == "All"
        ? _orders
        : _orders
            .where((o) => o['status'].toString().contains(_selectedFilter))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🧭 Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterChip("All"),
                _buildFilterChip("Delivered"),
                _buildFilterChip("Out for Delivery"),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 📦 Orders List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                final isDelivered = order['status'] == 'Delivered';

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: isDelivered
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      child: Icon(
                        isDelivered
                            ? Icons.check_circle_rounded
                            : Icons.delivery_dining_rounded,
                        color: isDelivered ? Colors.green : Colors.orange,
                        size: 26,
                      ),
                    ),
                    title: Text(
                      order['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Ordered on ${order['date']}',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDelivered
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order['status'],
                            style: TextStyle(
                              color: isDelivered
                                  ? Colors.green
                                  : Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          order['price'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Viewing ${order['title']} details...'),
                                backgroundColor: primaryBlue,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 20),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🧩 Filter Chip Builder
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    const Color primaryBlue = Color(0xFF3D8BF2);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: primaryBlue.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? primaryBlue : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.grey[200],
      onSelected: (_) {
        setState(() => _selectedFilter = label);
      },
    );
  }
}