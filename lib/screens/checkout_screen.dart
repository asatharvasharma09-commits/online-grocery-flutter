import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'Cash on Delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BF2),
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏠 Address Section
            _buildSectionTitle("Delivery Address"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF3D8BF2)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Atharva Sharma",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Flat 12-B, Sky Residency\nPune, Maharashtra - 411001"),
                        SizedBox(height: 4),
                        Text("Phone: +91 9876543210",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Change", style: TextStyle(color: Color(0xFF3D8BF2))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🛍️ Order Summary
            _buildSectionTitle("Order Summary"),
            Container(
              decoration: _boxDecoration(),
              child: Column(
                children: [
                  _buildOrderItem("Apples", "2 kg", "₹180"),
                  _buildOrderItem("Bananas", "1 dozen", "₹60"),
                  _buildOrderItem("Milk", "2 packets", "₹100"),
                  const Divider(),
                  _buildSummaryRow("Subtotal", "₹340"),
                  _buildSummaryRow("Delivery Fee", "₹20"),
                  const Divider(),
                  _buildSummaryRow("Total", "₹360", isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 💳 Payment Method
            _buildSectionTitle("Payment Method"),
            Container(
              decoration: _boxDecoration(),
              child: Column(
                children: [
                  _buildPaymentOption("Cash on Delivery"),
                  _buildPaymentOption("UPI / GPay"),
                  _buildPaymentOption("Credit / Debit Card"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Confirm Order Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D8BF2),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Order placed successfully ✅"),
                    backgroundColor: Color(0xFF3D8BF2),
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text(
                "Place Order",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📦 Helper Widgets
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.08),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name, String qty, String price) {
    return ListTile(
      leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF3D8BF2)),
      title: Text(name),
      subtitle: Text(qty),
      trailing: Text(price,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String option) {
    return RadioListTile<String>(
      value: option,
      groupValue: selectedPayment,
      activeColor: const Color(0xFF3D8BF2),
      onChanged: (value) {
        setState(() {
          selectedPayment = value!;
        });
      },
      title: Text(option),
    );
  }
}