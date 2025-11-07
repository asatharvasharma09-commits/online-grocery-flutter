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
  final Color primaryBlue = const Color(0xFF3D8BF2);
  String selectedCategory = 'Fruits';
  String? selectedSubcategory;
  String selectedSort = "Default";

  final Map<String, List<String>> categories = {
    'Fruits': ['Citrus', 'Berries'],
    'Vegetables': ['Leafy Greens', 'Root Vegetables'],
  };

  final Map<String, List<Map<String, dynamic>>> products = {
    'Citrus': [
      {'id': 'f1', 'name': 'Orange', 'price': 40.0, 'quantity': '1 kg', 'image': 'assets/images/orange.png'},
      {'id': 'f2', 'name': 'Lemon', 'price': 30.0, 'quantity': '500 g', 'image': 'assets/images/lemon.png'},
    ],
    'Berries': [
      {'id': 'b1', 'name': 'Strawberry', 'price': 120.0, 'quantity': '500 g', 'image': 'assets/images/strawberry.png'},
      {'id': 'b2', 'name': 'Blueberry', 'price': 200.0, 'quantity': '250 g', 'image': 'assets/images/blueberry.png'},
    ],
    'Leafy Greens': [
      {'id': 'v1', 'name': 'Spinach', 'price': 25.0, 'quantity': '500 g', 'image': 'assets/images/spinach.png'},
      {'id': 'v2', 'name': 'Lettuce', 'price': 30.0, 'quantity': '250 g', 'image': 'assets/images/lettuce.png'},
    ],
    'Root Vegetables': [
      {'id': 'r1', 'name': 'Carrot', 'price': 20.0, 'quantity': '1 kg', 'image': 'assets/images/carrot.png'},
      {'id': 'r2', 'name': 'Beetroot', 'price': 25.0, 'quantity': '500 g', 'image': 'assets/images/beetroot.png'},
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null && categories.keys.contains(widget.initialCategory)) {
      selectedCategory = widget.initialCategory!;
    }
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    if (selectedSubcategory == null) return [];
    List<Map<String, dynamic>> list = List.from(products[selectedSubcategory]!);
    if (selectedSort == "Low to High") {
      list.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (selectedSort == "High to Low") {
      list.sort((a, b) => b['price'].compareTo(a['price']));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalItems = cart.itemCount;
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Shop by Category'),
        backgroundColor: primaryBlue,
        centerTitle: true,
        elevation: 2,
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 90,
            color: Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: categories.keys.map((category) {
                bool isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      selectedSubcategory = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryBlue.withOpacity(0.15) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? primaryBlue : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Text(
                        category,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primaryBlue : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Right Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Sort
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedCategory, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: selectedSort,
                        borderRadius: BorderRadius.circular(12),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.sort, color: Colors.black54),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        items: const [
                          DropdownMenuItem(value: "Default", child: Text("Default")),
                          DropdownMenuItem(value: "Low to High", child: Text("Price: Low → High")),
                          DropdownMenuItem(value: "High to Low", child: Text("Price: High → Low")),
                        ],
                        onChanged: (v) => setState(() => selectedSort = v ?? "Default"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Subcategories
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: categories[selectedCategory]!.map((subcategory) {
                      bool isSelected = subcategory == selectedSubcategory;
                      return ChoiceChip(
                        label: Text(subcategory,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            )),
                        selected: isSelected,
                        selectedColor: primaryBlue,
                        backgroundColor: Colors.grey[200],
                        onSelected: (selected) => setState(() {
                          selectedSubcategory = selected ? subcategory : null;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Products
                  if (selectedSubcategory == null)
                    const Expanded(
                        child: Center(
                            child: Text("Select a subcategory to view products 👇",
                                style: TextStyle(color: Colors.black54))))
                  else if (filteredProducts.isEmpty)
                    const Expanded(
                        child: Center(
                            child: Text("No products found 😕",
                                style: TextStyle(color: Colors.black54))))
                  else
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final p = filteredProducts[index];
                          final bool inCart = cart.cartItems.containsKey(p['id']);

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.asset(
                                    p['image'],
                                    height: 110,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("₹${p['price']}", style: const TextStyle(color: Color(0xFF3D8BF2))),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: inCart ? Colors.grey : primaryBlue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () {
                                    if (!inCart) {
                                      cart.addItem(
                                        id: p['id'],
                                        name: p['name'],
                                        price: p['price'],
                                        image: p['image'],
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("${p['name']} added to cart"),
                                          backgroundColor: primaryBlue));
                                    }
                                  },
                                  child: Text(inCart ? "Added" : "Add"),
                                ),
                                const SizedBox(height: 8),
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
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: primaryBlue,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
            },
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
          if (totalItems > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                child: Text('$totalItems',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }
}