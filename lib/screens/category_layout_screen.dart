import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class CategoryLayoutScreen extends StatefulWidget {
  final String? initialCategory;

  const CategoryLayoutScreen({super.key, this.initialCategory});

  @override
  State<CategoryLayoutScreen> createState() => _CategoryLayoutScreenState();
}

class _CategoryLayoutScreenState extends State<CategoryLayoutScreen> {
  String selectedCategory = 'Fruits';
  String? selectedSubcategory;

  final Map<String, List<String>> categories = {
    'Fruits': ['Citrus', 'Berries'],
    'Vegetables': ['Leafy Greens', 'Root Vegetables'],
  };

  final Map<String, List<Map<String, String>>> products = {
    'Citrus': [
      {'name': 'Orange', 'price': '₹40/kg', 'quantity': '1 kg', 'image': 'assets/images/orange.png'},
      {'name': 'Lemon', 'price': '₹30/kg', 'quantity': '500 g', 'image': 'assets/images/lemon.png'},
      {'name': 'Sweet Lime', 'price': '₹50/kg', 'quantity': '1 kg', 'image': 'assets/images/sweet_lime.png'},
      {'name': 'Grapefruit', 'price': '₹60/kg', 'quantity': '500 g', 'image': 'assets/images/grapefruit.png'},
      {'name': 'Tangerine', 'price': '₹55/kg', 'quantity': '1 kg', 'image': 'assets/images/tangerine.png'},
    ],
    'Berries': [
      {'name': 'Strawberry', 'price': '₹120/kg', 'quantity': '500 g', 'image': 'assets/images/strawberry.png'},
      {'name': 'Blueberry', 'price': '₹200/kg', 'quantity': '250 g', 'image': 'assets/images/blueberry.png'},
      {'name': 'Raspberry', 'price': '₹150/kg', 'quantity': '250 g', 'image': 'assets/images/raspberry.png'},
      {'name': 'Blackberry', 'price': '₹180/kg', 'quantity': '250 g', 'image': 'assets/images/blackberry.png'},
      {'name': 'Cranberry', 'price': '₹140/kg', 'quantity': '250 g', 'image': 'assets/images/cranberry.png'},
    ],
    'Leafy Greens': [
      {'name': 'Spinach', 'price': '₹25/kg', 'quantity': '500 g', 'image': 'assets/images/spinach.png'},
      {'name': 'Lettuce', 'price': '₹30/kg', 'quantity': '250 g', 'image': 'assets/images/lettuce.png'},
      {'name': 'Kale', 'price': '₹40/kg', 'quantity': '250 g', 'image': 'assets/images/kale.png'},
      {'name': 'Fenugreek', 'price': '₹35/kg', 'quantity': '250 g', 'image': 'assets/images/fenugreek.png'},
      {'name': 'Cabbage', 'price': '₹28/kg', 'quantity': '1 kg', 'image': 'assets/images/cabbage.png'},
    ],
    'Root Vegetables': [
      {'name': 'Carrot', 'price': '₹20/kg', 'quantity': '1 kg', 'image': 'assets/images/carrot.png'},
      {'name': 'Beetroot', 'price': '₹25/kg', 'quantity': '500 g', 'image': 'assets/images/beetroot.png'},
      {'name': 'Potato', 'price': '₹18/kg', 'quantity': '1 kg', 'image': 'assets/images/potato.png'},
      {'name': 'Sweet Potato', 'price': '₹22/kg', 'quantity': '1 kg', 'image': 'assets/images/sweet_potato.png'},
      {'name': 'Radish', 'price': '₹15/kg', 'quantity': '1 kg', 'image': 'assets/images/radish.png'},
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null && categories.keys.contains(widget.initialCategory)) {
      selectedCategory = widget.initialCategory!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalItems = cart.items.values.fold<int>(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: const Color(0xFF3D8BF2),
      ),
      body: Row(
        children: [
          // 📋 Sidebar Categories
          Container(
            width: 100,
            color: Colors.grey[100],
            child: ListView(
              children: categories.keys.map((category) {
                bool isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      selectedSubcategory = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF3D8BF2) : Colors.grey.shade300,
                      ),
                    ),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Text(
                        category,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF3D8BF2) : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 🧺 Products Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCategory,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // 🏷 Subcategories
                  Wrap(
                    spacing: 10,
                    children: categories[selectedCategory]!.map((subcategory) {
                      bool isSelected = subcategory == selectedSubcategory;
                      return ChoiceChip(
                        label: Text(subcategory),
                        selected: isSelected,
                        selectedColor: const Color(0xFF3D8BF2).withOpacity(0.3),
                        onSelected: (selected) {
                          setState(() {
                            selectedSubcategory = selected ? subcategory : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 🛒 Product Grid
                  if (selectedSubcategory == null)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Select a subcategory to view products',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(4),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.60,
                        ),
                        itemCount: products[selectedSubcategory]?.length ?? 0,
                        itemBuilder: (context, index) {
                          final product = products[selectedSubcategory]![index];
                          final name = product['name']!;
                          final price = product['price']!;
                          final quantity = product['quantity'] ?? '';
                          final qty = cart.items[name] ?? 0;

                          return Container(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 🖼 Product Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.asset(
                                    product['image'] ?? 'assets/images/placeholder.png',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // 📦 Product Info
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        quantity,
                                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        price,
                                        style: const TextStyle(
                                          color: Color(0xFF3D8BF2),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),

                                // ➕ Add / Counter Buttons
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: SizedBox(
                                    height: 36,
                                    width: double.infinity,
                                    child: qty == 0
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF3D8BF2),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            onPressed: () {
                                              cart.addToCart(name, price);
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text("$name added to cart 🛒"),
                                                duration: const Duration(seconds: 1),
                                              ));
                                            },
                                            child: const Text(
                                              '+ Add',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3D8BF2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    cart.removeFromCart(name);
                                                  },
                                                  icon: const Icon(Icons.remove, color: Colors.white),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                Text(
                                                  '$qty',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    cart.addToCart(name, price);
                                                  },
                                                  icon: const Icon(Icons.add, color: Colors.white),
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ],
                                            ),
                                          ),
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
            ),
          ),
        ],
      ),

      // 🛍 Floating Cart Button
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFF3D8BF2),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            child: const Icon(Icons.shopping_cart, color: Colors.white),
          ),
          if (totalItems > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$totalItems',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}