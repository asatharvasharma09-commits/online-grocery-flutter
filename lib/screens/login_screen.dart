import 'package:flutter/material.dart';
import 'otp_screen.dart'; // ✅ Make sure this exists

class AuthMain extends StatelessWidget {
  const AuthMain({super.key});

  void _showPhoneInputDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Enter Mobile Number',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D8BF2)),
        ),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            prefixText: '+91 ',
            prefixStyle: const TextStyle(color: Colors.black87),
            hintText: 'Enter your 10-digit number',
            counterText: '',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D8BF2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final phone = phoneController.text.trim();
              if (phone.length != 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid 10-digit mobile number'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OtpScreen(phoneNumber: phone),
                ),
              );
            },
            child: const Text('Get OTP', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D8BF2);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🌈 Header Illustration
                const Icon(Icons.shopping_basket_rounded,
                    size: 90, color: primaryBlue),
                const SizedBox(height: 14),
                const Text(
                  "Welcome to A3Grocer 🛒",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Groceries delivered fresh to your doorstep!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 35),

                // 📱 Continue with phone
                ElevatedButton.icon(
                  icon: const Icon(Icons.phone_android, color: Colors.white),
                  onPressed: () => _showPhoneInputDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: const Text(
                    "Continue with Phone Number",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // ✉️ Continue with Email (optional)
                OutlinedButton.icon(
                  icon: const Icon(Icons.email_outlined, color: primaryBlue),
                  label: const Text(
                    "Continue with Email",
                    style: TextStyle(
                        color: primaryBlue, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryBlue, width: 1.4),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email login coming soon!'),
                        backgroundColor: Color(0xFF3D8BF2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 👤 Guest option
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Continuing as guest..."),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Or ",
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Continue as Guest",
                          style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 🧾 Footer
                const Text(
                  "By continuing, you agree to our\nTerms of Service & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}