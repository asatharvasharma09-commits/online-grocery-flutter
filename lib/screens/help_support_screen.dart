import 'package:flutter/material.dart';
import 'dart:math' as math;

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final Color primaryBlue = const Color(0xFF3D8BF2);

  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I track my order?',
      'answer':
          'You can track your order from the “My Orders” section in your profile. It shows live status updates.',
    },
    {
      'question': 'How can I cancel my order?',
      'answer':
          'Orders can be cancelled before dispatch. Go to My Orders → Select order → Tap “Cancel Order”.',
    },
    {
      'question': 'How do I contact customer care?',
      'answer':
          'You can email us, call support, or use the “Chat with Support” option below.',
    },
    {
      'question': 'What if I received the wrong items?',
      'answer':
          'Go to My Orders → Select the order → Tap “Report Issue”. Our team will resolve it quickly.',
    },
  ];

  void _showReportIssueSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final TextEditingController messageC = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Report an Issue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF3D8BF2),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Describe your issue briefly and our support team will contact you.",
                style: TextStyle(color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageC,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your issue here...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Issue reported successfully ✅"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                label: const Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D8BF2),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Help & Support"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧠 FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: faqs.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 24, thickness: 0.6),
                itemBuilder: (context, i) {
                  final faq = faqs[i];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 1,
                    child: ExpansionTile(
                      leading: Icon(Icons.help_outline,
                          color: primaryBlue, size: 26),
                      title: Text(
                        faq['question']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                          child: Text(
                            faq['answer']!,
                            style: const TextStyle(
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1, height: 30),

            // ⚙️ Support Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _supportButton(Icons.support_agent, "Contact Support", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Connecting to Support...'),
                      backgroundColor: Color(0xFF3D8BF2),
                    ),
                  );
                }),
                _supportButton(Icons.message_rounded, "Chat with Us", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening Live Chat...'),
                      backgroundColor: Color(0xFF3D8BF2),
                    ),
                  );
                }),
                _supportButton(Icons.report_problem_outlined, "Report Issue",
                    _showReportIssueSheet),
              ],
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text(
                'Email: support@groceryapp.in\nPhone: +91 98765 43210',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(14),
            child: Icon(icon, color: primaryBlue, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}