import 'package:flutter/material.dart';
import 'seller_main_tabs.dart';

class SellerRegistrationSuccessScreen extends StatefulWidget {
  const SellerRegistrationSuccessScreen({super.key});

  @override
  State<SellerRegistrationSuccessScreen> createState() =>
      _SellerRegistrationSuccessScreenState();
}

class _SellerRegistrationSuccessScreenState
    extends State<SellerRegistrationSuccessScreen> {
  @override
  void initState() {
    super.initState();
    _redirectAfterDelay();
  }

  Future<void> _redirectAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SellerMainTabs()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D8BF2);
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle_outline,
              color: primaryBlue,
              size: 100,
            ),
            SizedBox(height: 24),
            Text(
              'Seller Account Created!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Welcome aboard, partner 🏪',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: primaryBlue),
          ],
        ),
      ),
    );
  }
}