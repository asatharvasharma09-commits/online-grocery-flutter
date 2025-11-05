import 'package:flutter/material.dart';
import 'main_tabs.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // ⏱️ Automatically navigate to home after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainTabs()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Success icon
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF3D8BF2),
              size: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'Registration Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D8BF2),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Redirecting to your dashboard...',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: Color(0xFF3D8BF2),
            ),
          ],
        ),
      ),
    );
  }
}