import 'package:flutter/material.dart';
import 'otp_screen.dart'; // 👈 Make sure you have this screen created

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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: const InputDecoration(
            prefixText: '+91 ',
            hintText: 'Enter your 10-digit number',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
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

              Navigator.pop(context); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OtpScreen(phoneNumber: phone),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D8BF2),
            ),
            child: const Text('Get OTP'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_android, size: 80, color: Color(0xFF3D8BF2)),
              const SizedBox(height: 20),
              const Text(
                "Welcome to MilkBasket 🛒",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Get groceries delivered to your doorstep",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _showPhoneInputDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D8BF2),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Continue with Phone",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}