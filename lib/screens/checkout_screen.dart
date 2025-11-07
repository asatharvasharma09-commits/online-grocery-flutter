import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.cartItems.values.toList();
    double deliveryCharge = 30;
    double subtotal = cart.totalPrice;
    double total = subtotal + deliveryCharge;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BF2),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                        ),
                      ),
                      title: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                          "x${item.quantity} • ₹${item.price.toStringAsFixed(2)}"),
                      trailing: Text(
                        "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D8BF2)),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Summary Section
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2))
                ],
              ),
              child: Column(
                children: [
                  _priceRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
                  _priceRow("Delivery Charge", "₹${deliveryCharge.toStringAsFixed(2)}"),
                  const Divider(),
                  _priceRow("Grand Total",
                      "₹${total.toStringAsFixed(2)}",
                      isBold: true),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8BF2),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderSuccessScreen(totalAmount: total),
                        ),
                      );
                      cart.clearCart();
                    },
                    child: const Text(
                      "Place Order",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight:
                      isBold ? FontWeight.w600 : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isBold ? const Color(0xFF3D8BF2) : Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}