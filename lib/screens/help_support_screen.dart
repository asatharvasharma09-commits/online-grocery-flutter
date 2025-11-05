import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I track my order?',
        'answer':
            'You can track your order from the “My Orders” section in your profile.',
      },
      {
        'question': 'How can I cancel my order?',
        'answer':
            'Orders can only be cancelled before they are dispatched. Go to My Orders > Cancel.',
      },
      {
        'question': 'How do I contact customer care?',
        'answer':
            'You can email us or use the Contact Support button below.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
      backgroundColor: const Color(0xFF3D8BF2),
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // FAQ List
            Expanded(
              child: ListView.separated(
                itemCount: faqs.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 8, bottom: 8),
                        child: Text(
                          faq['answer']!,
                          style: const TextStyle(
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const Divider(thickness: 1, height: 30),
            const SizedBox(height: 10),

            // Contact Support Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFF3D8BF2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contacting Support...'),
                    ),
                  );
                },
                icon: const Icon(Icons.support_agent, color: Colors.white),
                label: const Text(
                  'Contact Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Support Email
            const Center(
              child: Text(
                'Email: support@groceryapp.in',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}