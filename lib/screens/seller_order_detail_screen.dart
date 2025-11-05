import 'package:flutter/material.dart';

class SellerOrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const SellerOrderDetailScreen({super.key, required this.order});

  @override
  State<SellerOrderDetailScreen> createState() => _SellerOrderDetailScreenState();
}

class _SellerOrderDetailScreenState extends State<SellerOrderDetailScreen> {
  final List<String> orderStatusList = [
    'Pending',
    'Packed',
    'Dispatched',
    'Delivered',
    'Cancelled',
    'Returned',
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Packed':
        return Colors.teal;
      case 'Dispatched':
        return Colors.blue;
      case 'Cancelled':
        return Colors.redAccent;
      case 'Returned':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final products = order['items'] ?? [
      {
        'name': 'Amul Milk 500ml',
        'qty': 2,
        'price': 30,
      },
      {
        'name': 'Brown Bread 400g',
        'qty': 1,
        'price': 40,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color(0xFF3D8BF2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 ORDER SUMMARY
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID: ${order['orderId']}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dropdown for status update
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: order['status'],
                            icon: const Icon(Icons.arrow_drop_down),
                            dropdownColor: Colors.white,
                            items: orderStatusList.map((status) {
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
                                      "Order ${order['orderId']} updated to $newStatus ✅"),
                                  backgroundColor: _getStatusColor(newStatus!),
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                          "Expected: ${order['expectedDate']}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 👤 CUSTOMER INFO
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Customer Information",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 6),
                    Text("Name: Rahul Mehta"),
                    Text("Phone: +91 98765 43210"),
                    Text("Address: 221B, Baker Street, Mumbai"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 💳 PAYMENT INFO
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Payment Details",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text("Mode: ${order['paymentMode']}"),
                    Text("Total Amount: ₹${order['totalAmount']}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 🚚 DELIVERY INFO
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Delivery Details",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text("Partner: ${order['deliveryPartner']}"),
                    Text("Mode: ${order['deliveryMode']}"),
                    Text("Expected Delivery: ${order['expectedDate']}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 📦 PRODUCTS LIST
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Products Ordered",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    ...products.map((p) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(p['name']),
                          subtitle: Text("Quantity: ${p['qty']}"),
                          trailing: Text("₹${p['price']}"),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🧭 ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    setState(() => order['status'] = 'Dispatched');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Order marked as Dispatched ✅"),
                      backgroundColor: Colors.blue,
                    ));
                  },
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: const Text("Mark Dispatched"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12)),
                  onPressed: () {
                    setState(() => order['status'] = 'Cancelled');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Order Cancelled ❌"),
                      backgroundColor: Colors.redAccent,
                    ));
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text("Cancel Order"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}