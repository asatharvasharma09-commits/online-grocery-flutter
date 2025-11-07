import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final Color primaryBlue = const Color(0xFF3D8BF2);
  String _searchQuery = "";
  String _selectedFilter = "None";

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Fruits',
      'icon': Icons.apple,
      'color': Colors.redAccent,
      'products': [
        {'id': 'p1', 'name': 'Apple', 'price': 120.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'p2', 'name': 'Banana', 'price': 50.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'p3', 'name': 'Orange', 'price': 80.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'p4', 'name': 'Mango', 'price': 150.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'p5', 'name': 'Strawberry', 'price': 200.0, 'image': 'https://via.placeholder.com/150'},
      ],
    },
    {
      'name': 'Vegetables',
      'icon': Icons.eco,
      'color': Colors.green,
      'products': [
        {'id': 'v1', 'name': 'Tomato', 'price': 40.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'v2', 'name': 'Potato', 'price': 30.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'v3', 'name': 'Onion', 'price': 25.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'v4', 'name': 'Carrot', 'price': 45.0, 'image': 'https://via.placeholder.com/150'},
        {'id': 'v5', 'name': 'Broccoli', 'price': 60.0, 'image': 'https://via.placeholder.com/150'},
      ],
    },
  ];

  int selectedCategoryIndex = 0;

  // 🔍 Filter & search logic
  List<Map<String, dynamic>> _filteredProducts() {
    final selectedCategory = categories[selectedCategoryIndex];
    List<Map<String, dynamic>> prods = List.from(selectedCategory['products']);

    // Search
    if (_searchQuery.isNotEmpty) {
      prods = prods
          .where((p) =>
              p['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter
    if (_selectedFilter == "Low to High") {
      prods.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (_selectedFilter == "High to Low") {
      prods.sort((a, b) => b['price'].compareTo(a['price']));
    }

    return prods;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final selectedCategory = categories[selectedCategoryIndex];
    final products = _filteredProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "A3Grocer 🛍️",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          // 🧺 Cart icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  CartScreen()),
                ),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.itemCount.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // 🧭 Category selector
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategoryIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => selectedCategoryIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 12),
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected ? cat['color'] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat['icon'],
                            size: 40,
                            color: isSelected ? Colors.white : cat['color']),
                        const SizedBox(height: 8),
                        Text(
                          cat['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
                    // 🧩 Filter & Category Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCategory['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedFilter,
                  borderRadius: BorderRadius.circular(12),
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  icon: const Icon(Icons.filter_list),
                  items: const [
                    DropdownMenuItem(value: "None", child: Text("Default")),
                    DropdownMenuItem(value: "Low to High", child: Text("Price: Low → High")),
                    DropdownMenuItem(value: "High to Low", child: Text("Price: High → Low")),
                  ],
                  onChanged: (v) => setState(() => _selectedFilter = v ?? "None"),
                ),
              ],
            ),
          ),

          // 🛍️ Products Grid
          Expanded(
            child: products.isEmpty
                ? const Center(
                    child: Text(
                      "No items found 😕",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, i) {
                      final p = products[i];
                      final bool inCart = cart.cartItems.containsKey(p['id']);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🖼️ Product Image
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                child: Image.network(
                                  p['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 📋 Product Details
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹${p['price'].toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),

                                  // 🛒 Add / Added Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          inCart ? Colors.grey[400] : primaryBlue,
                                      minimumSize: const Size(double.infinity, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      if (!inCart) {
                                        cart.addItem(
                                          id: p['id'],
                                          name: p['name'],
                                          price: p['price'],
                                          image: p['image'],
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("${p['name']} added to cart"),
                                          action: SnackBarAction(
                                            label: "Undo",
                                            onPressed: () => cart.removeItem(p['id']),
                                            textColor: Colors.white,
                                          ),
                                          backgroundColor: primaryBlue,
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("${p['name']} already in cart 🛒"),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      inCart ? "Added" : "Add to Cart",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}