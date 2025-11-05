import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Fruits',
      'icon': Icons.apple,
      'products': [
        {'name': 'Apple', 'price': 120, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Banana', 'price': 50, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Orange', 'price': 80, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Mango', 'price': 150, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Strawberry', 'price': 200, 'image': 'https://via.placeholder.com/150'},
      ],
    },
    {
      'name': 'Vegetables',
      'icon': Icons.eco,
      'products': [
        {'name': 'Tomato', 'price': 40, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Potato', 'price': 30, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Onion', 'price': 25, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Carrot', 'price': 45, 'image': 'https://via.placeholder.com/150'},
        {'name': 'Broccoli', 'price': 60, 'image': 'https://via.placeholder.com/150'},
      ],
    },
  ];

  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedCategory = categories[selectedCategoryIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Hey Atharva 👋',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CATEGORY SCROLLER
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
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 12),
                    width: 90,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[600] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat['icon'],
                            size: 40,
                            color: isSelected ? Colors.white : Colors.green[700]),
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

          // SECTION TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Text(
              selectedCategory['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // PRODUCTS GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 3 / 4,
              ),
              itemCount: selectedCategory['products'].length,
              itemBuilder: (context, i) {
                final product = selectedCategory['products'][i];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(product['image'], fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("₹${product['price']}",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text("Add to Cart",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            )
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