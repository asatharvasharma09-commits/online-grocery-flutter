import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  static const Color primaryBlue = Color(0xFF3D8BF2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          "Track Order 🚚",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 Order Summary Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long, color: primaryBlue, size: 30),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Order ID: #GROC12345",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("Placed on: Nov 6, 2025",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🧭 Delivery Progress Timeline
            const Text(
              "Delivery Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            _buildTrackingStep(
              context,
              icon: Icons.check_circle,
              title: "Order Confirmed",
              subtitle: "We’ve received your order",
              completed: true,
            ),
            _buildTrackingStep(
              context,
              icon: Icons.local_mall,
              title: "Order Packed",
              subtitle: "Your items are being prepared",
              completed: true,
            ),
            _buildTrackingStep(
              context,
              icon: Icons.local_shipping,
              title: "Out for Delivery",
              subtitle: "Our delivery partner is on the way",
              completed: true,
            ),
            _buildTrackingStep(
              context,
              icon: Icons.home_filled,
              title: "Delivered",
              subtitle: "Expected between 4:00 PM – 5:00 PM",
              completed: false,
            ),

            const SizedBox(height: 30),

            // 📦 Delivery Info
            const Text(
              "Delivery Partner",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/1995/1995574.png",
                  ),
                ),
                title: const Text("Rahul Sharma"),
                subtitle: const Text("Vehicle: RJ14 XY 9087"),
                trailing: IconButton(
                  icon: const Icon(Icons.phone, color: primaryBlue),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Calling delivery partner...")),
                    );
                  },
                ),
              ),
            ),

            const Spacer(),

            // 🔙 Back to Home Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.home_outlined, color: Colors.white),
                label: const Text(
                  "Back to Home",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool completed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              icon,
              color: completed ? primaryBlue : Colors.grey,
              size: 30,
            ),
            Container(
              width: 3,
              height: 40,
              color: completed ? primaryBlue : Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: completed ? primaryBlue : Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}