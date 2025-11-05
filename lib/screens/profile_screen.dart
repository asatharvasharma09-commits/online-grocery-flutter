import 'package:flutter/material.dart';
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
  String gender = "Male";
  String dob = "12 July 2001";

  // 🏠 Detailed Address Fields
  String houseNo = "12A";
  String floor = "3rd Floor";
  String building = "Sunshine Apartments";
  String landmark = "Near Bandra Station";
  String locality = "Bandra West";
  String city = "Mumbai";
  String pincode = "400050";

  // 💳 Payment info
  String paymentMethod = "UPI (atharva@okaxis)";
  String lastPayment = "2 Nov 2025";
  String walletBalance = "₹250";

  // ⚙️ Preferences
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  // 🔐 Security
  String lastLogin = "3 Nov 2025, 9:20 PM";
  String loginDevice = "iPhone 14 Pro";
  String passwordLastChanged = "10 Aug 2025";

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
            // 👤 Header
            _buildHeader(),
            const SizedBox(height: 20),

            // 📦 Order stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard("Orders", "16", Icons.shopping_bag_outlined),
                _statCard("Subscriptions", "2", Icons.repeat),
                _statCard("Wallet", walletBalance,
                    Icons.account_balance_wallet_outlined),
              ],
            ),

            const SizedBox(height: 20),

            // 🏠 Address
            _infoCard(
              title: "Address Details",
              onEdit: _editAddressInfo,
              children: [
                _infoTile(Icons.home_outlined, "House / Flat No.", houseNo),
                _infoTile(Icons.stairs_outlined, "Floor", floor),
                _infoTile(Icons.apartment_outlined, "Building / Apartment", building),
                _infoTile(Icons.place_outlined, "Landmark / Locality", landmark),
                _infoTile(Icons.location_city_outlined, "Locality", locality),
                _infoTile(Icons.location_on_outlined, "City", city),
                _infoTile(Icons.pin_drop_outlined, "Pincode", pincode),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _openMapPin,
                  icon: const Icon(Icons.map_outlined),
                  label: const Text("Set Location on Map"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3D8BF2),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 💳 Payment Info
            _infoCard(
              title: "Payment Preferences",
              onEdit: _editPaymentInfo,
              children: [
                _infoTile(
                    Icons.payment_outlined, "Preferred Method", paymentMethod),
                _infoTile(Icons.history, "Last Payment", lastPayment),
                _infoTile(Icons.account_balance_wallet_outlined, "Wallet Balance",
                    walletBalance),
              ],
            ),

            const SizedBox(height: 20),

            // 🔐 Security Info
            _infoCard(
              title: "Security & Login",
              onEdit: _editSecurityInfo,
              children: [
                _infoTile(Icons.access_time_outlined, "Last Login", lastLogin),
                _infoTile(
                    Icons.devices_other_outlined, "Device", loginDevice),
                _infoTile(Icons.lock_outline, "Password Changed",
                    passwordLastChanged),
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
                _optionTile(Icons.shopping_bag_outlined, "My Orders",
                    const OrdersScreen()),
                _optionTile(Icons.repeat, "My Subscriptions",
                    const SubscriptionScreen()),
                _optionTile(Icons.location_on_outlined, "My Addresses",
                    const AddressScreen()),
                _optionTile(Icons.help_outline, "Help & Support",
                    const HelpSupportScreen()),
              ],
            ),

            const SizedBox(height: 30),

            // 🚪 Logout
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _logout,
              icon: Icon(Icons.logout, color: primaryBlue),
              label: Text(
                "Logout",
                style: TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 🧩 Components

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage('assets/images/user_avatar.png'),
          ),
          const SizedBox(height: 10),
          Text(name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(email, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 6)
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: primaryBlue, size: 28),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(label,
                  style:
                      const TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
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
                    Text(label,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54)),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ]),
            ),
          ],
        ),
      );

  Widget _infoCard({
    required String title,
    required List<Widget> children,
    required Function() onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8)
        ],
      ),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
                onPressed: onEdit,
                child: const Text("Edit",
                    style: TextStyle(color: Color(0xFF3D8BF2)))),
          ],
        ),
        const SizedBox(height: 10),
        ...children,
      ]),
    );
  }

  Widget _settingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8)
        ],
      ),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("App Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      ]),
    );
  }

  Widget _optionTile(IconData icon, String title, Widget screen) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: primaryBlue),
        title: Text(title),
        trailing:
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      );

  // ✏️ Edit Modals
  void _editPersonalInfo() => _editModal("Edit Personal Info", [
        _field("Full Name", name, (v) => name = v),
        _field("Email", email, (v) => email = v),
        _field("Phone", phone, (v) => phone = v),
        _field("Gender", gender, (v) => gender = v),
        _field("Date of Birth", dob, (v) => dob = v),
      ]);

  void _editAddressInfo() => _editModal("Edit Address Details", [
        _field("House / Flat No.", houseNo, (v) => houseNo = v),
        _field("Floor", floor, (v) => floor = v),
        _field("Building / Apartment", building, (v) => building = v),
        _field("Landmark / Locality", landmark, (v) => landmark = v),
        _field("Locality", locality, (v) => locality = v),
        _field("City", city, (v) => city = v),
        _field("Pincode", pincode, (v) => pincode = v),
      ]);

  void _editPaymentInfo() => _editModal("Edit Payment Info", [
        _field("Payment Method", paymentMethod, (v) => paymentMethod = v),
        _field("Wallet Balance", walletBalance, (v) => walletBalance = v),
      ]);

  void _editSecurityInfo() => _editModal("Edit Security Info", [
        _field("Password Changed On", passwordLastChanged,
            (v) => passwordLastChanged = v),
      ]);

  void _editModal(String title, List<Widget> fields) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: SingleChildScrollView(
          child: Column(children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...fields,
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () => setState(() => Navigator.pop(ctx)),
              child: const Text("Save Changes",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
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
        decoration: InputDecoration(
          labelText: label,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: onSave,
      ),
    );
  }

  // 📍 Map Pin Placeholder
  void _openMapPin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Map pin feature coming soon!"),
        backgroundColor: Color(0xFF3D8BF2),
      ),
    );
  }

  // 🚪 Logout
  Future<void> _logout() async {
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