import 'package:flutter/material.dart';
import 'otp_verify_screen.dart';
import '../services/user_storage.dart';
import 'customer_registration_success_screen.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  const CustomerRegistrationScreen({super.key});

  @override
  State<CustomerRegistrationScreen> createState() =>
      _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState extends State<CustomerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryBlue = const Color(0xFF3D8BF2);

  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _phoneC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _confirmC = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;
  bool _agreedToTerms = false;

  double _passwordStrength = 0;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _passwordC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  // 🧠 Validate and submit registration
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must agree to Terms & Conditions"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final name = _nameC.text.trim();
    final email = _emailC.text.trim();
    final phone = _phoneC.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final password = _passwordC.text.trim();

    // Simulate saving locally
    await UserStorage.saveUser(name: name, email: email, phone: phone);

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isSaving = false);

    // 🚀 Redirect to OTP verification screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerifyScreen(phoneNumber: phone),
      ),
    );
  }

  // ⚙️ Password strength calculator
  void _checkPasswordStrength(String value) {
    double strength = 0;
    if (value.length >= 6) strength += 0.3;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[a-z]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'\d').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) strength += 0.1;
    setState(() => _passwordStrength = strength.clamp(0, 1));
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Customer Registration"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt, size: 90, color: Color(0xFF3D8BF2)),
            const SizedBox(height: 10),
            const Text(
              "Create Your Account",
              style: TextStyle(
                color: Color(0xFF3D8BF2),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Fill in your details below and verify your number via OTP.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // 🧾 Registration Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _validatedField(
                    controller: _nameC,
                    label: "Full Name",
                    icon: Icons.person_outline,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Enter your name";
                      if (v.trim().length < 3) return "Name too short";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  _validatedField(
                    controller: _emailC,
                    label: "Email (optional)",
                    icon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                        return "Enter valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  _validatedField(
                    controller: _phoneC,
                    label: "Mobile Number",
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Enter phone number";
                      final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                      if (digits.length != 10) return "Enter valid 10-digit number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Password field + strength bar
                  TextFormField(
                    controller: _passwordC,
                    obscureText: _obscure,
                    onChanged: _checkPasswordStrength,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter password";
                      if (v.length < 6) return "At least 6 characters required";
                      if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)')
                          .hasMatch(v)) {
                        return "Include upper, lower, and number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),

                  // Password Strength Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _passwordStrength,
                          color: _passwordStrength < 0.4
                              ? Colors.redAccent
                              : _passwordStrength < 0.7
                                  ? Colors.orangeAccent
                                  : Colors.green,
                          backgroundColor: Colors.grey[300],
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _passwordStrength < 0.4
                            ? "Weak"
                            : _passwordStrength < 0.7
                                ? "Medium"
                                : "Strong",
                        style: TextStyle(
                          color: _passwordStrength < 0.4
                              ? Colors.redAccent
                              : _passwordStrength < 0.7
                                  ? Colors.orangeAccent
                                  : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  _validatedField(
                    controller: _confirmC,
                    label: "Confirm Password",
                    icon: Icons.lock_outline,
                    obscure: _obscureConfirm,
                    suffix: IconButton(
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Confirm password";
                      if (v != _passwordC.text) return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // ✅ Terms Checkbox
                  Row(
                    children: [
                      Checkbox(
                        activeColor: primaryBlue,
                        value: _agreedToTerms,
                        onChanged: (v) =>
                            setState(() => _agreedToTerms = v ?? false),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black87),
                            children: [
                              const TextSpan(text: "I agree to the "),
                              TextSpan(
                                text: "Terms & Conditions",
                                style: const TextStyle(
                                  color: Color(0xFF3D8BF2),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: const TextStyle(
                                  color: Color(0xFF3D8BF2),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 🔘 Submit Button
                  _isSaving
                      ? const CircularProgressIndicator(color: Color(0xFF3D8BF2))
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _submit,
                          label: const Text(
                            "Continue & Verify OTP",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Color(0xFF3D8BF2)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Reusable Validated TextField
  Widget _validatedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}