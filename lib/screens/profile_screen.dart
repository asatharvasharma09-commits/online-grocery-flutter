import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_storage.dart';
import 'auth_main.dart';
import 'orders_screen.dart';
import 'address_screen.dart';
import 'subscription_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryBlue = const Color(0xFF3D8BF2);

  // 👤 User info
  String name = "Atharva Sharma";
  String email = "atharva.sharma@example.com";
  String phone = "+91 9876543210";

  // 🏠 Address
  String address = "Sunshine Apartments, Bandra West";
  String city = "Mumbai";
  String pincode = "400050";

  // 💳 Payment info
  String paymentMethod = "UPI (atharva@okaxis)";
  String walletBalance = "₹250";

  // ⚙️ Preferences
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  // 🔹 Load customer data from SharedPreferences
  Future<void> _loadCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('customer_name') ?? name;
      email = prefs.getString('customer_email') ?? email;
      phone = prefs.getString('customer_phone') ?? phone;
      address = prefs.getString('customer_address') ?? address;
      city = prefs.getString('customer_city') ?? city;
      pincode = prefs.getString('customer_pincode') ?? pincode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),

            // 🏠 Address Card
            _infoCard(
              title: "Address Details",
              onEdit: _editAddressInfo,
              children: [
                _infoTile(Icons.home_outlined, "Address", address),
                _infoTile(Icons.location_city_outlined, "City", city),
                _infoTile(Icons.pin_drop_outlined, "Pincode", pincode),
              ],
            ),

            const SizedBox(height: 20),

            // 💳 Payment Info
            _infoCard(
              title: "Payment Preferences",
              onEdit: _editPaymentInfo,
              children: [
                _infoTile(Icons.payment_outlined, "Preferred Method", paymentMethod),
                _infoTile(Icons.account_balance_wallet_outlined, "Wallet Balance", walletBalance),
              ],
            ),

            const SizedBox(height: 20),

            // ⚙️ App Settings
            _settingsCard(),

            const SizedBox(height: 25),

            // 💬 Help Section
            _infoCard(
              title: "Help & Support",
              onEdit: () {},
              children: [
                _optionTile(Icons.shopping_bag_outlined, "My Orders", const OrdersScreen()),
                _optionTile(Icons.repeat, "My Subscriptions", const SubscriptionScreen()),
                _optionTile(Icons.location_on_outlined, "My Addresses", const AddressScreen()),
                _optionTile(Icons.help_outline, "Help & Support", const HelpSupportScreen()),
              ],
            ),

            const SizedBox(height: 30),

            // 🚪 Logout
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _logout,
              icon: Icon(Icons.logout, color: primaryBlue),
              label: Text(
                "Logout",
                style: TextStyle(color: primaryBlue, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 👤 Header
  Widget _buildHeader() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8)],
        ),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
            ),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(email, style: const TextStyle(color: Colors.black54)),
            Text(phone, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      );

  Widget _infoTile(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ]),
            ),
          ],
        ),
      );

  Widget _infoCard({required String title, required List<Widget> children, required Function() onEdit}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: onEdit, child: const Text("Edit", style: TextStyle(color: Color(0xFF3D8BF2)))),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ]),
      );

  Widget _settingsCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("App Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SwitchListTile(
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
              title: const Text("Enable Notifications"),
              activeColor: primaryBlue,
            ),
            SwitchListTile(
              value: _darkModeEnabled,
              onChanged: (v) => setState(() => _darkModeEnabled = v),
              title: const Text("Dark Mode"),
              activeColor: primaryBlue,
            ),
          ],
        ),
      );

  Widget _optionTile(IconData icon, String title, Widget screen) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: primaryBlue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      );

  void _editAddressInfo() => _editModal("Edit Address Details", [
        _field("Address", address, (v) => address = v),
        _field("City", city, (v) => city = v),
        _field("Pincode", pincode, (v) => pincode = v),
      ]);

  void _editPaymentInfo() => _editModal("Edit Payment Info", [
        _field("Payment Method", paymentMethod, (v) => paymentMethod = v),
        _field("Wallet Balance", walletBalance, (v) => walletBalance = v),
      ]);

  void _editModal(String title, List<Widget> fields) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...fields,
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, minimumSize: const Size(double.infinity, 48)),
              onPressed: () => setState(() => Navigator.pop(ctx)),
              child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _field(String label, String initial, Function(String) onSave) {
    final ctrl = TextEditingController(text: initial);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        onChanged: onSave,
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clears saved customer data
    await UserStorage.clearUser();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthMain()),
      (route) => false,
    );
  }
}