import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'order_tracking_screen.dart'; // 👈 Added import

class OrderSuccessScreen extends StatefulWidget {
  final double totalAmount;

  const OrderSuccessScreen({super.key, required this.totalAmount});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Color primaryBlue = const Color(0xFF3D8BF2);
  late String orderId;

  @override
  void initState() {
    super.initState();

    // ✅ Create a random order ID
    final random = Random();
    orderId = "#A3${100000 + random.nextInt(899999)}";

    // 🎊 Simple pulse animation
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateFormat('EEE, d MMM yyyy • hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Animated success icon
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle_rounded,
                        color: primaryBlue, size: 110),
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  "Order Placed Successfully!",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "Thank you for shopping with us 🙌",
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),

                // 📦 Order details card
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _infoRow("Order ID", orderId),
                      const Divider(),
                      _infoRow("Date & Time", now),
                      const Divider(),
                      _infoRow(
                        "Amount Paid",
                        "₹${widget.totalAmount.toStringAsFixed(2)}",
                        valueColor: primaryBlue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 🧭 Action buttons
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  // ✅ Navigate to the new tracking page
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderTrackingScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.local_shipping_outlined,
                      color: Colors.white),
                  label: const Text(
                    "Track Order",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 🏠 Back to Home button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryBlue, width: 1.5),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  icon: Icon(Icons.home_outlined, color: primaryBlue),
                  label: Text(
                    "Back to Home",
                    style: TextStyle(
                        color: primaryBlue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}