import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../data/product_data.dart';
import 'package:grocery_app/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  double calculateTotal(Map<String, int> cartQuantities) {
    double total = 0;

    for (var entry in cartQuantities.entries) {
      final productName = entry.key;
      final quantity = entry.value;

      // Match product name in product_data.dart to find price
      for (var categoryProducts in products.values) {
        for (var product in categoryProducts) {
          if (product['name'] == productName) {
            final price =
                double.parse(product['price']!.replaceAll('₹', '').trim());
            total += price * quantity;
          }
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartQuantities = cart.cartItems;
    final total = calculateTotal(cartQuantities);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3D8BF2),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (cartQuantities.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared successfully 🧹'),
                    backgroundColor: Color(0xFF3D8BF2),
                  ),
                );
              },
            ),
        ],
      ),
      body: cartQuantities.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartQuantities.length,
                    itemBuilder: (context, index) {
                      final itemName = cartQuantities.keys.elementAt(index);
                      final quantity = cartQuantities[itemName]!;
                      String? priceText;

                      // Find item price
                      for (var categoryProducts in products.values) {
                        for (var product in categoryProducts) {
                          if (product['name'] == itemName) {
                            priceText = product['price'];
                          }
                        }
                      }

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.local_grocery_store,
                                color: Color(0xFF3D8BF2)),
                          ),
                          title: Text(
                            itemName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(priceText ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => cart.removeItem(itemName),
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.redAccent),
                              ),
                              Text(
                                'x$quantity',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                onPressed: () => cart.addItem(itemName),
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Color(0xFF3D8BF2)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D8BF2),
                            ),
                          ),
                        ],
                      ),
                    ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF3D8BF2),
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutScreen(),
      ),
    );
  },
  child: const Text(
    'Checkout',
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
)
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}