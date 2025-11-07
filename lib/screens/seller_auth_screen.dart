import 'package:flutter/material.dart';
import 'seller_main_tabs.dart';
import 'seller_registration_wizard.dart'; // 👉 we'll create this next

class SellerAuthScreen extends StatefulWidget {
  const SellerAuthScreen({super.key});

  @override
  State<SellerAuthScreen> createState() => _SellerAuthScreenState();
}

class _SellerAuthScreenState extends State<SellerAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // fake network delay

    setState(() => _isLoading = false);

    // 🔐 Navigate to Seller Dashboard
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
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Seller Login"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.storefront_rounded, size: 90, color: primaryBlue),
              const SizedBox(height: 12),
              const Text(
                "Welcome Seller 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to manage your store and orders",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // 🔹 Login Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailC,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Enter your email";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordC,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Enter password" : null,
                      ),
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: primaryBlue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 🔘 Login Button
                      _isLoading
                          ? const CircularProgressIndicator(color: primaryBlue)
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _login,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🧾 Register as new seller
              OutlinedButton.icon(
                icon: const Icon(Icons.person_add_alt, color: primaryBlue),
                label: const Text(
                  "Register as New Seller",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerRegistrationWizard(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}