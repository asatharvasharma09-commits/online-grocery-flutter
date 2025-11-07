import 'package:flutter/material.dart';
import 'main_tabs.dart';
import 'registration_screen.dart';
import 'otp_screen.dart';

class CustomerAuthScreen extends StatefulWidget {
  const CustomerAuthScreen({super.key});

  @override
  State<CustomerAuthScreen> createState() => _CustomerAuthScreenState();
}

class _CustomerAuthScreenState extends State<CustomerAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // 🕒 simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    // ✅ Navigate to Customer Dashboard
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainTabs()),
      (route) => false,
    );
  }

  void _forgotPassword() {
    final resetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password?"),
        content: TextField(
          controller: resetController,
          decoration: const InputDecoration(
            labelText: "Enter your registered email",
            border: OutlineInputBorder(),
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
              if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(resetController.text)) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password reset link sent to your email."),
                    backgroundColor: Color(0xFF3D8BF2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter valid email")),
                );
              }
            },
            child: const Text("Send Link"),
          ),
        ],
      ),
    );
  }

  void _loginWithOtp() {
    final TextEditingController phoneC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login via OTP"),
        content: TextField(
          controller: phoneC,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: "Enter Mobile Number",
            prefixText: "+91 ",
            border: OutlineInputBorder(),
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
              if (phoneC.text.trim().length == 10) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpScreen(phoneNumber: phoneC.text),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter valid 10-digit number")),
                );
              }
            },
            child: const Text("Send OTP"),
          ),
        ],
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D8BF2);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Customer Login"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 👤 Header Icon + Title
              const Icon(Icons.person_outline, size: 90, color: primaryBlue),
              const SizedBox(height: 12),
              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Login to start shopping fresh groceries",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // 🧾 Login Form
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
                      // ✉️ Email
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
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 🔒 Password
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
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter password";
                          }
                          if (v.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      // ✅ Remember me + Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: primaryBlue,
                                value: _rememberMe,
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                              ),
                              const Text("Remember me"),
                            ],
                          ),
                          TextButton(
                            onPressed: _forgotPassword,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 🔘 Login Button
                      _isLoading
                          ? const CircularProgressIndicator(color: primaryBlue)
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.login, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _login,
                              label: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 🧍 Register as New Customer
              OutlinedButton.icon(
                icon: const Icon(Icons.person_add_alt, color: primaryBlue),
                label: const Text(
                  "Register as New Customer",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
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
                      builder: (_) => const RegistrationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // 📱 Continue with OTP
              OutlinedButton.icon(
                icon: const Icon(Icons.phone_iphone, color: primaryBlue),
                label: const Text(
                  "Continue with OTP",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _loginWithOtp,
              ),

              const SizedBox(height: 18),

              // 🌐 Google Login (placeholder)
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 30),
                label: const Text(
                  "Continue with Google",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Google login coming soon!"),
                      backgroundColor: Colors.redAccent,
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