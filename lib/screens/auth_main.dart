import 'package:flutter/material.dart';
import 'main_tabs.dart';
import 'otp_screen.dart';
import 'registration_screen.dart';
import 'seller_main_tabs.dart'; // ✅ Correct import for seller navigation

class AuthMain extends StatefulWidget {
  const AuthMain({super.key});

  @override
  State<AuthMain> createState() => _AuthMainState();
}

class _AuthMainState extends State<AuthMain> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _selectedRole = 'Customer'; // default role

  // 🔹 Ask for mobile number before OTP login
  void _askForPhoneNumber(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Enter your mobile number",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: const InputDecoration(
            prefixText: '+91 ',
            hintText: 'Enter 10-digit number',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D8BF2),
            ),
            onPressed: () {
              final phone = phoneController.text.trim();
              if (phone.length != 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a valid 10-digit number"),
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
            child: const Text("Send OTP"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_grocery_store_rounded,
                color: Color(0xFF3D8BF2),
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                isLogin ? 'Welcome Back 👋' : 'Create Account 🛒',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D8BF2),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isLogin
                    ? 'Login to continue your daily groceries'
                    : 'Register to start fresh shopping',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // 🧩 Login / Register Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your email' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                      ),

                      const SizedBox(height: 18),

                      // 🧩 Role Selection
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Login as",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _selectedRole = 'Customer'),
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'Customer',
                                    groupValue: _selectedRole,
                                    activeColor: const Color(0xFF3D8BF2),
                                    onChanged: (v) =>
                                        setState(() => _selectedRole = v!),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Customer',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _selectedRole = 'Seller'),
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'Seller',
                                    groupValue: _selectedRole,
                                    activeColor: const Color(0xFF3D8BF2),
                                    onChanged: (v) =>
                                        setState(() => _selectedRole = v!),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Seller',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8BF2),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // ✅ Navigate based on role
                            if (_selectedRole == 'Seller') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SellerMainTabs(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainTabs(),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          isLogin ? 'Login' : 'Register',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 🔄 Switch between Login & Register
                      TextButton(
                        onPressed: () {
                          if (isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegistrationScreen(),
                              ),
                            );
                          } else {
                            setState(() {
                              isLogin = true;
                            });
                          }
                        },
                        child: Text(
                          isLogin
                              ? "Don't have an account? Register"
                              : "Already have an account? Login",
                          style: const TextStyle(
                            color: Color(0xFF3D8BF2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),

              // 🟢 Continue with Google
              OutlinedButton.icon(
                icon: Image.asset(
                  'assets/images/google_icon.png',
                  height: 22,
                ),
                label: const Text(
                  "Continue with Google",
                  style: TextStyle(
                    color: Color(0xFF3D8BF2),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFF3D8BF2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: add Google login logic
                },
              ),

              const SizedBox(height: 12),

              // 📱 Continue with OTP
              OutlinedButton.icon(
                icon: const Icon(Icons.phone_iphone, color: Color(0xFF3D8BF2)),
                label: const Text(
                  "Continue with OTP",
                  style: TextStyle(
                    color: Color(0xFF3D8BF2),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFF3D8BF2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _askForPhoneNumber(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}