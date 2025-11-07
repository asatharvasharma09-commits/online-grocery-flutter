import 'package:flutter/material.dart';
import 'otp_verify_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_storage.dart';
import 'customer_registration_success_screen.dart';
import 'seller_registration_success_screen.dart';
import 'customer_registration_success_screen.dart';
import 'seller_registration_success_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _phoneC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _confirmC = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;
  String _selectedRole = 'Customer'; // 👈 Default role

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _passwordC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameC.text.trim();
    final email = _emailC.text.trim();
    final phone = _phoneC.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final password = _passwordC.text.trim();

    setState(() => _isSaving = true);

    // ✅ Save user info locally before OTP verification
    await UserStorage.saveUser(
      name: name,
      email: email,
      phone: phone,
    );

    // Also store selected role for later (Customer/Seller)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', _selectedRole);

    // 🕒 Simulate small delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isSaving = false);

    // 🚀 Go to OTP Verification screen
    if (_selectedRole == 'Seller') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SellerRegistrationSuccessScreen(),
    ),
  );
} else {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CustomerRegistrationSuccessScreen(),
    ),
  );
}  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter full name';
    if (v.trim().length < 3) return 'Name too short';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter mobile number';
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 10) return 'Enter a valid 10-digit mobile number';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm password';
    if (v != _passwordC.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BF2),
        title: const Text('Create Account'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Icon(
              Icons.local_grocery_store_rounded,
              size: 84,
              color: Color(0xFF3D8BF2),
            ),
            const SizedBox(height: 12),
            const Text(
              'Create your account',
              style: TextStyle(
                color: Color(0xFF3D8BF2),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your details to continue. We will send an OTP to verify your phone number.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name
                  TextFormField(
                    controller: _nameC,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 12),

                  // Email
                  TextFormField(
                    controller: _emailC,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email (optional)',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null; // optional
                      return _validateEmail(v);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Phone
                  TextFormField(
                    controller: _phoneC,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Mobile number',
                      hintText: '10-digit mobile number',
                      prefixIcon: const Icon(Icons.phone_android),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    controller: _passwordC,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validatePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmC,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateConfirm,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 18),

                  // 🧩 Role Selection
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Account Type",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Customer"),
                          value: "Customer",
                          groupValue: _selectedRole,
                          activeColor: const Color(0xFF3D8BF2),
                          onChanged: (value) {
                            setState(() => _selectedRole = value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Seller"),
                          value: "Seller",
                          groupValue: _selectedRole,
                          activeColor: const Color(0xFF3D8BF2),
                          onChanged: (value) {
                            setState(() => _selectedRole = value!);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Submit Button
                  _isSaving
                      ? const CircularProgressIndicator(
                          color: Color(0xFF3D8BF2),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D8BF2),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _submit,
                          child: const Text(
                            'Continue & Verify',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),

                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}