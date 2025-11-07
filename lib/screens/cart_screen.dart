import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';
import 'category_layout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const Color primaryBlue = Color(0xFF3D8BF2);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.cartItems.values.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        title: const Text(
          "My Cart 🛒",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (cart.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Clear Cart?"),
                    content: const Text(
                        "Are you sure you want to remove all items from your cart?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Clear"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  cart.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Cart cleared successfully 🧹"),
                    backgroundColor: primaryBlue,
                  ));
                }
              },
            ),
        ],
      ),

      // 🛍️ Body
      body: cartItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          final removedItem = item;
                          cart.deleteItem(item.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${removedItem.name} removed"),
                              action: SnackBarAction(
                                label: "Undo",
                                textColor: Colors.white,
                                onPressed: () => cart.addItem(
                                  id: removedItem.id,
                                  name: removedItem.name,
                                  price: removedItem.price,
                                  image: removedItem.image,
                                ),
                              ),
                              backgroundColor: primaryBlue,
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                // 🖼 Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // 📋 Name + Price
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹${item.price.toStringAsFixed(2)} each",
                                        style: const TextStyle(
                                            color: Colors.black54, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),

                                // ➕ Quantity Controls
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline,
                                          color: Colors.redAccent),
                                      onPressed: () => cart.removeItem(item.id),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline,
                                          color: primaryBlue),
                                      onPressed: () => cart.addItem(
                                        id: item.id,
                                        name: item.name,
                                        price: item.price,
                                        image: item.image,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🧾 Sticky bottom summary section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 💵 Subtotal and delivery info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal",
                              style: TextStyle(color: Colors.black54, fontSize: 15)),
                          Text(
                            "₹${cart.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery Charge",
                              style: TextStyle(color: Colors.black54, fontSize: 15)),
                          Text("₹30.00",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const Divider(height: 20, color: Colors.grey),

                      // 🎯 Grand total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Grand Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                          Text(
                            "₹${(cart.totalPrice + 30).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "🎉 You saved ₹50 on this order!",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 🧭 Checkout Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
                          "Proceed to Checkout",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // 🕳️ Empty state UI
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.remove_shopping_cart_outlined,
                size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              "Your cart is empty 🛍️",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Looks like you haven’t added anything yet. Let’s fix that!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 25),

            // ✅ Browse Products button
            ElevatedButton.icon(
              icon: const Icon(Icons.storefront_outlined),
              label: const Text("Browse Products"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryLayoutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}