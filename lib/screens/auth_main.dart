import 'package:flutter/material.dart';
import 'customer_auth_screen.dart';
import 'seller_auth_screen.dart';

class AuthMain extends StatefulWidget {
  const AuthMain({super.key});

  @override
  State<AuthMain> createState() => _AuthMainState();
}

class _AuthMainState extends State<AuthMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  static const Color primaryBlue = Color(0xFF3D8BF2);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeInAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 🧩 Confirm before exiting
  Future<bool> _onWillPop() async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Exit App?"),
        content: const Text("Are you sure you want to close A3Grocer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Exit"),
          ),
        ],
      ),
    );
    return exitApp ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF5FF),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🛒 Logo / Icon
                    const Icon(
                      Icons.shopping_basket_rounded,
                      size: 100,
                      color: primaryBlue,
                    ),
                    const SizedBox(height: 20),

                    // 🏷 Title
                    const Text(
                      "Welcome to A3Grocer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Your smart grocery partner for everyday essentials",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // 👤 Continue as Customer
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_outline, size: 24),
                      label: const Text(
                        "Continue as Customer",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor: primaryBlue.withOpacity(0.3),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerAuthScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // 🏪 Continue as Seller
                    OutlinedButton.icon(
                      icon: const Icon(
                        Icons.storefront_outlined,
                        color: primaryBlue,
                        size: 24,
                      ),
                      label: const Text(
                        "Continue as Seller",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryBlue,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        side: const BorderSide(color: primaryBlue, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellerAuthScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // ⚡ Future expansion (optional)
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "or",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Continue with OTP or Google (coming soon)",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // 📄 Footer
                    const Text(
                      "Choose your role to continue",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "© 2025 A3Grocer — All rights reserved",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}