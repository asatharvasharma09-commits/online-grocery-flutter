import 'package:flutter/material.dart';
import 'add_address_screen.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> addresses = [
      {
        'type': 'Home',
        'address': '23, Green Park, New Delhi, 110016',
        'phone': '+91 9876543210',
      },
      {
        'type': 'Office',
        'address': '7th Floor, WeWork Galaxy, Bangalore',
        'phone': '+91 9123456789',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BF2),
        title: const Text(
          'My Addresses',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length + 1,
        itemBuilder: (context, index) {
          if (index == addresses.length) {
            // Add New Address Button
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF3D8BF2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                 onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AddAddressScreen()),
  );
},
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add New Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }

          final address = addresses[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    address['type'] == 'Home'
                        ? Icons.home
                        : Icons.work_outline,
                   color: const Color(0xFF3D8BF2),
                    size: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address['type']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address['address']!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          address['phone']!,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Edit ${address['type']} clicked'),
                        ),
                      );
                    },
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