import 'package:flutter/material.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({super.key});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final Color primaryBlue = const Color(0xFF3D8BF2);

  // Seller data
  String sellerName = 'Rohit Mehta';
  String shopName = 'FreshMart Grocery';
  String email = 'rohit.mehta@example.com';
  String phone = '+91 9876543210';
  String address = 'Andheri West, Mumbai';
  String category = 'Grocery & Dairy';

  // Business
  String gst = '27ABCDE1234F1Z2';
  String businessType = 'Proprietorship';
  String registrationDate = '15 March 2022';
  String pan = 'ABCDE1234F';
  String industry = 'FMCG / Grocery';

  // Bank
  String accountHolder = 'Rohit Mehta';
  String bankName = 'HDFC Bank';
  String accountNumber = 'XXXX XXXX 5678';
  String ifsc = 'HDFC0000123';
  String upi = 'rohit@okhdfcbank';
  String payout = 'Weekly';

  // KYC
  String aadhaar = 'XXXX XXXX 1234';
  String panVerified = '✅ Verified';
  String businessVerification = 'Verified';
  String kycDate = '1 Nov 2025';

  // Address
  String pickup = 'Shop 14, Fort Road, Mumbai - 400001';
  String warehouse = 'Plot 42, MIDC, Navi Mumbai';
  String returnAddress = 'Same as Pickup';
  String city = 'Mumbai, Maharashtra, 400001';

  // Toggles
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text('Seller Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Products', '28', Icons.inventory_2_outlined),
                _buildStatCard('Orders', '124', Icons.shopping_cart_outlined),
                _buildStatCard('Revenue', '₹12.4K', Icons.attach_money_rounded),
              ],
            ),
            const SizedBox(height: 20),

            _buildInfoCard(
              title: 'Personal Information',
              onEdit: _editPersonalInfo,
              children: [
                _infoTile(Icons.person_outline, 'Seller Name', sellerName),
                _infoTile(Icons.email_outlined, 'Email', email),
                _infoTile(Icons.phone_android, 'Phone', phone),
                _infoTile(Icons.location_on_outlined, 'Address', address),
                _infoTile(Icons.category_outlined, 'Category', category),
              ],
            ),
            const SizedBox(height: 20),

            _buildInfoCard(
              title: 'Business Details',
              onEdit: _editBusinessInfo,
              children: [
                _infoTile(Icons.storefront_outlined, 'Business Name', shopName),
                _infoTile(Icons.badge_outlined, 'GSTIN', gst),
                _infoTile(Icons.account_balance_outlined, 'Type', businessType),
                _infoTile(Icons.receipt_long_outlined, 'PAN', pan),
                _infoTile(Icons.calendar_today_outlined, 'Registered', registrationDate),
                _infoTile(Icons.apartment_outlined, 'Industry', industry),
              ],
            ),
            const SizedBox(height: 20),

            _buildInfoCard(
              title: 'Bank & Payment Details',
              onEdit: _editBankDetails,
              children: [
                _infoTile(Icons.person, 'Account Holder', accountHolder),
                _infoTile(Icons.account_balance, 'Bank', bankName),
                _infoTile(Icons.numbers, 'Account Number', accountNumber),
                _infoTile(Icons.code, 'IFSC', ifsc),
                _infoTile(Icons.qr_code, 'UPI', upi),
                _infoTile(Icons.schedule, 'Payout', payout),
              ],
            ),
            const SizedBox(height: 20),

            _buildInfoCard(
              title: 'KYC & Verification',
              onEdit: _editKycDetails,
              children: [
                _infoTile(Icons.credit_card_outlined, 'Aadhaar', aadhaar),
                _infoTile(Icons.verified_outlined, 'PAN Verification', panVerified),
                _infoTile(Icons.fact_check_outlined, 'Business Verification', businessVerification),
                _infoTile(Icons.calendar_month_outlined, 'KYC Approved On', kycDate),
              ],
            ),
            const SizedBox(height: 20),

            _buildInfoCard(
              title: 'Address & Warehouse',
              onEdit: _editAddressDetails,
              children: [
                _infoTile(Icons.location_city_outlined, 'Pickup Address', pickup),
                _infoTile(Icons.factory_outlined, 'Warehouse Address', warehouse),
                _infoTile(Icons.assignment_return_outlined, 'Return Address', returnAddress),
                _infoTile(Icons.map_outlined, 'City / State / Pincode', city),
              ],
            ),
            const SizedBox(height: 20),

            _buildSettingsCard(),
            const SizedBox(height: 25),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out successfully.")),
              ),
              icon: Icon(Icons.logout, color: primaryBlue),
              label: Text(
                "Logout",
                style: TextStyle(fontSize: 16, color: primaryBlue, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🧩 UI Components

  Widget _buildProfileHeader() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8)],
        ),
        child: Column(
          children: const [
            CircleAvatar(radius: 45, backgroundImage: AssetImage('assets/images/seller_avatar.png')),
            SizedBox(height: 10),
            Text('Rohit Mehta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('FreshMart Grocery', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      );

  Widget _buildStatCard(String label, String value, IconData icon) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 6)],
          ),
          child: Column(
            children: [
              Icon(icon, color: primaryBlue, size: 28),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ]),
            ),
          ],
        ),
      );

  Widget _buildInfoCard({required String title, required List<Widget> children, required Function() onEdit}) =>
      Container(
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
              TextButton(onPressed: onEdit, child: const Text("Edit", style: TextStyle(color: Color(0xFF3D8BF2))))
            ],
          ),
          const SizedBox(height: 10),
          ...children
        ]),
      );

  Widget _buildSettingsCard() => Container(
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

  // 🧾 Edit Modals
  void _editPersonalInfo() => _showEditModal("Edit Personal Info", [
        _buildField("Seller Name", sellerName, (v) => sellerName = v),
        _buildField("Email", email, (v) => email = v),
        _buildField("Phone", phone, (v) => phone = v),
        _buildField("Address", address, (v) => address = v),
        _buildField("Category", category, (v) => category = v),
      ]);

  void _editBusinessInfo() => _showEditModal("Edit Business Info", [
        _buildField("Business Name", shopName, (v) => shopName = v),
        _buildField("GSTIN", gst, (v) => gst = v),
        _buildField("Business Type", businessType, (v) => businessType = v),
        _buildField("PAN", pan, (v) => pan = v),
        _buildField("Industry", industry, (v) => industry = v),
      ]);

  void _editBankDetails() => _showEditModal("Edit Bank Details", [
        _buildField("Account Holder", accountHolder, (v) => accountHolder = v),
        _buildField("Bank Name", bankName, (v) => bankName = v),
        _buildField("Account Number", accountNumber, (v) => accountNumber = v),
        _buildField("IFSC Code", ifsc, (v) => ifsc = v),
        _buildField("UPI ID", upi, (v) => upi = v),
      ]);

  void _editKycDetails() => _showEditModal("Edit KYC Details", [
        _buildField("Aadhaar", aadhaar, (v) => aadhaar = v),
        _buildField("PAN Verification", panVerified, (v) => panVerified = v),
        _buildField("Business Verification", businessVerification, (v) => businessVerification = v),
      ]);

  void _editAddressDetails() => _showEditModal("Edit Address Details", [
        _buildField("Pickup Address", pickup, (v) => pickup = v),
        _buildField("Warehouse Address", warehouse, (v) => warehouse = v),
        _buildField("Return Address", returnAddress, (v) => returnAddress = v),
        _buildField("City / State / Pincode", city, (v) => city = v),
      ]);

  // 📋 Reusable modal
  void _showEditModal(String title, List<Widget> fields) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String initial, Function(String) onSave) {
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
}