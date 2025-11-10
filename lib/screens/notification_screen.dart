import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF3D8BF2);

    // Sample notifications
    final List<Map<String, String>> notifications = [
      {
        'title': '🎁 New Offer Available!',
        'message': 'Get 15% off on your next order above ₹500.',
        'time': '2 hours ago'
      },
      {
        'title': '🛒 Order #A312345 Delivered',
        'message': 'Your order has been successfully delivered. Thank you!',
        'time': '5 hours ago'
      },
      {
        'title': '📦 Order Dispatched',
        'message': 'Your order #A312345 is out for delivery.',
        'time': 'Yesterday'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          "Notifications 🔔",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No new notifications",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryBlue.withOpacity(0.1),
                      child: Icon(Icons.notifications,
                          color: primaryBlue, size: 24),
                    ),
                    title: Text(
                      item['title']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(item['message']!,
                            style:
                                const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(item['time']!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
