import 'package:flutter/material.dart';
import 'main_tabs.dart';
import 'registration_success_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerifyScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  bool isVerifying = false;

  // Function to simulate OTP verification
  void _verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter all 4 digits of the OTP"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => isVerifying = true);

    // Simulate network delay for OTP verification
    await Future.delayed(const Duration(seconds: 2));

    setState(() => isVerifying = false);

    if (otp == "1234") {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("OTP Verified ✅")),
  );

  // 🕒 Small delay for smooth transition
  await Future.delayed(const Duration(seconds: 1));

  // ✅ Navigate to Registration Success Screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const RegistrationSuccessScreen(),
    ),
  );
}
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BF2),
        title: const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Text(
              "OTP sent to +91 ${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            // OTP Input Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 60,
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D8BF2),
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF3D8BF2), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Verify Button or Loader
            isVerifying
                ? const CircularProgressIndicator(color: Color(0xFF3D8BF2))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8BF2),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _verifyOtp,
                    child: const Text(
                      "Verify & Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 20),

            // Resend OTP
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("OTP Resent 🔁"),
                    backgroundColor: Color(0xFF3D8BF2),
                  ),
                );
              },
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  color: Color(0xFF3D8BF2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            // Info text
            const Text(
              "Didn’t receive the code? Check your messages or try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}