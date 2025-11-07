import 'package:flutter/material.dart';
import 'main_tabs.dart';
import 'dart:math' as math;

class CustomerRegistrationSuccessScreen extends StatefulWidget {
  const CustomerRegistrationSuccessScreen({super.key});

  @override
  State<CustomerRegistrationSuccessScreen> createState() =>
      _CustomerRegistrationSuccessScreenState();
}

class _CustomerRegistrationSuccessScreenState
    extends State<CustomerRegistrationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    // Start confetti shimmer effect
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => _showConfetti = true);
    });

    _redirectAfterDelay();
  }

  Future<void> _redirectAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainTabs()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D8BF2);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🎊 Subtle confetti shimmer
          if (_showConfetti) _buildConfetti(),

          // 🎉 Main Success Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(25),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: primaryBlue,
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                "Welcome to A3Grocer!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your customer account has been created 🎉",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 🚀 Continue Button (in case user wants to skip wait)
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                label: const Text(
                  "Continue to App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainTabs()),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 24),
              const Text(
                "Redirecting automatically...",
                style: TextStyle(color: Colors.black45),
              ),
              const SizedBox(height: 10),
              const CircularProgressIndicator(color: primaryBlue),
            ],
          ),
        ],
      ),
    );
  }

  // 🎊 Lightweight confetti shimmer
  Widget _buildConfetti() {
    return IgnorePointer(
      ignoring: true,
      child: CustomPaint(
        painter: _ConfettiPainter(),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
      ),
    );
  }
}

// 🎨 Custom confetti painter
class _ConfettiPainter extends CustomPainter {
  final math.Random random = math.Random();
  final List<Color> colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.yellowAccent,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 60; i++) {
      final paint = Paint()
        ..color = colors[random.nextInt(colors.length)].withOpacity(0.6)
        ..style = PaintingStyle.fill;

      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final shapeType = random.nextInt(3);

      switch (shapeType) {
        case 0:
          canvas.drawCircle(Offset(dx, dy), 3, paint);
          break;
        case 1:
          canvas.drawRect(Rect.fromLTWH(dx, dy, 5, 5), paint);
          break;
        default:
          final path = Path()
            ..moveTo(dx, dy)
            ..lineTo(dx + 4, dy + 6)
            ..lineTo(dx - 4, dy + 6)
            ..close();
          canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}