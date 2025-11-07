import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_address_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final Color primaryBlue = const Color(0xFF3D8BF2);
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  // 📥 Load saved address from SharedPreferences
  Future<void> _loadSavedAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLabel = prefs.getString('address_label');
    final savedLine = prefs.getString('address_line');
    final details = prefs.getString('address_details');
    final receiver = prefs.getString('receiver_name');
    final phone = prefs.getString('receiver_phone');

    // Demo + saved
    List<Map<String, dynamic>> defaultList = [
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

    if (savedLabel != null && savedLine != null && receiver != null && phone != null) {
      defaultList.insert(0, {
        'type': savedLabel,
        'address': "$savedLine\n$details",
        'phone': '+91 $phone',
        'receiver': receiver,
      });
    }

    setState(() {
      _addresses = defaultList;
      _isLoading = false;
    });
  }

  // 🗑️ Delete Address Confirmation
  Future<void> _deleteAddress(int index) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to remove this address?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _addresses.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address deleted successfully")),
      );
    }
  }

  // 🧭 Navigate to Add Address screen & refresh after save
  Future<void> _goToAddAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressScreen()),
    );
    if (result == true) _loadSavedAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          'My Addresses',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? _emptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _addresses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _addresses.length) return _addNewButton();
                    final address = _addresses[index];
                    return _addressCard(address, index);
                  },
                ),
    );
  }
    // 🏠 Address Card Widget
  Widget _addressCard(Map<String, dynamic> address, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏡 Icon Based on Type
            Icon(
              address['type'] == 'Home'
                  ? Icons.home_rounded
                  : address['type'] == 'Office'
                      ? Icons.work_outline
                      : Icons.location_on_outlined,
              color: primaryBlue,
              size: 30,
            ),
            const SizedBox(width: 16),

            // 📜 Address Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address['type'] ?? 'Address',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address['address'] ?? 'No details available',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (address['receiver'] != null)
                    Text(
                      "Receiver: ${address['receiver']}",
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 13),
                    ),
                  if (address['phone'] != null)
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

            // ✏️ Edit & ❌ Delete Icons
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Edit ${address['type']} coming soon 🛠️'),
                        backgroundColor: Colors.blueGrey,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _deleteAddress(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ➕ Add New Address Button
  Widget _addNewButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: _goToAddAddress,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add New Address',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // 📭 Empty State Widget
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          children: [
            const Icon(Icons.location_off_outlined,
                size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              "No addresses saved yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add a delivery address to make ordering faster next time.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text("Add Address"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size(180, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _goToAddAddress,
            ),
          ],
        ),
      ),
    );
  }
}