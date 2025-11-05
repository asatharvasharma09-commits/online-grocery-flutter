// lib/screens/seller_reviews_screen.dart
import 'package:flutter/material.dart';
import '../models/review_model.dart';

class SellerReviewsScreen extends StatefulWidget {
  const SellerReviewsScreen({super.key});

  @override
  State<SellerReviewsScreen> createState() => _SellerReviewsScreenState();
}

class _SellerReviewsScreenState extends State<SellerReviewsScreen> {
  // sample in-memory reviews
  final List<Review> _reviews = [
    Review.fromMap({
      'reviewId': 'r001',
      'orderId': 'o1001',
      'productId': 'p01',
      'productName': 'Amul Milk 500ml',
      'sellerId': 's001',
      'customerName': 'Rahul Mehta',
      'rating': 4.5,
      'comment': 'Good quality and fast delivery.',
      'date': '2025-11-01',
      'sellerReply': null,
      'deliveryPartner': {
        'name': 'Ramesh Kumar',
        'phone': '+91 9876543211',
        'vehicle': 'MH12AB3456',
        'agency': 'SwiftX Logistics'
      }
    }),
    Review.fromMap({
      'reviewId': 'r002',
      'orderId': 'o1002',
      'productId': 'p02',
      'productName': 'Brown Bread 400g',
      'sellerId': 's001',
      'customerName': 'Neha Sharma',
      'rating': 5.0,
      'comment': 'Fresh and tasty. Will buy again!',
      'date': '2025-10-28',
      'sellerReply': 'Thanks Neha! Glad you liked it 🙂',
      'deliveryPartner': {
        'name': 'Suresh Patel',
        'phone': '+91 9123456789',
        'vehicle': 'MH14CD9876',
        'agency': 'QuickDeliver'
      }
    }),
  ];

  // helper: show reply modal
  void _showReplyModal(Review r, int index) {
    final ctrl = TextEditingController(text: r.sellerReply ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reply to ${r.customerName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write a reply (be polite & helpful)...',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3D8BF2)),
                      onPressed: () {
                        final replyText = ctrl.text.trim();
                        setState(() {
                          _reviews[index] = Review(
                            reviewId: r.reviewId,
                            orderId: r.orderId,
                            productId: r.productId,
                            productName: r.productName,
                            sellerId: r.sellerId,
                            customerName: r.customerName,
                            rating: r.rating,
                            comment: r.comment,
                            date: r.date,
                            sellerReply: replyText.isEmpty ? null : replyText,
                            deliveryPartner: r.deliveryPartner,
                          );
                        });
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply saved')));
                      },
                      child: const Text('Save Reply'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // helper: build star row from rating double
  Widget _buildStars(double rating) {
    final int full = rating.floor();
    final bool half = (rating - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < full) return const Icon(Icons.star, size: 16, color: Colors.amber);
        if (i == full && half) return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        return const Icon(Icons.star_border, size: 16, color: Colors.amber);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Reviews'),
        backgroundColor: const Color(0xFF3D8BF2),
        centerTitle: true,
      ),
      body: _reviews.isEmpty
          ? const Center(child: Text('No reviews yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final r = _reviews[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header row: customer + date
                        Row(
                          children: [
                            CircleAvatar(child: Text(r.customerName.isNotEmpty ? r.customerName[0] : 'U')),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text('Ordered: ${r.orderId} • ${r.productName}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ),
                            Text(r.date, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // rating & comment
                        Row(
                          children: [
                            _buildStars(r.rating),
                            const SizedBox(width: 8),
                            Text(r.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(r.comment),

                        const SizedBox(height: 10),

                        // delivery partner info (if any)
                        if (r.deliveryPartner != null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.local_shipping_outlined, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${r.deliveryPartner!.name} • ${r.deliveryPartner!.agency} • ${r.deliveryPartner!.vehicle}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // TODO: Launch call intent if desired
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Call ${r.deliveryPartner!.phone} (not wired)')),
                                    );
                                  },
                                  child: const Icon(Icons.call, color: Color(0xFF3D8BF2)),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 10),

                        // seller reply (if present)
                        if (r.sellerReply != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.reply, size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(child: Text('Your reply: ${r.sellerReply!}')),
                              ],
                            ),
                          ),

                        const SizedBox(height: 8),

                        // actions: Reply / Remove (optional)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _showReplyModal(r, index),
                              child: const Text('Reply', style: TextStyle(color: Color(0xFF3D8BF2))),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                // optional: delete review locally
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Remove review?'),
                                    content: const Text('This will remove the review locally.'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                                      TextButton(
                                        onPressed: () {
                                          setState(() => _reviews.removeAt(index));
                                          Navigator.of(ctx).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review removed')));
                                        },
                                        child: const Text('Remove', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}