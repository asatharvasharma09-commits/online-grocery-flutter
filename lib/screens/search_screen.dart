import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/product_data.dart';
import '../providers/cart_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  String selectedCategory = "All";
  final List<String> recentSearches = [];

  List<Map<String, String>> get filteredProducts {
    final allProducts = products.entries.expand((e) {
      if (selectedCategory == "All" || e.key == selectedCategory) {
        return e.value;
      }
      return [];
    }).cast<Map<String, String>>().toList();

    if (searchQuery.isEmpty) return allProducts;

    return allProducts
        .where((p) =>
            p['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void _addToRecent(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      recentSearches.remove(query);
      recentSearches.insert(0, query);
      if (recentSearches.length > 5) recentSearches.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3D8BF2),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) => setState(() => searchQuery = val),
          onSubmitted: (val) => _addToRecent(val),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: "Search for milk, fruits, groceries...",
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                setState(() => searchQuery = "");
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 🏷️ Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                _categoryChip("All"),
                ...products.keys.map((cat) => _categoryChip(cat)),
              ],
            ),
          ),

          // 🕓 Recent Searches
          if (searchQuery.isEmpty && recentSearches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Recent Searches",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: recentSearches
                        .map((item) => ActionChip(
                              label: Text(item),
                              onPressed: () {
                                _searchController.text = item;
                                setState(() {
                                  searchQuery = item;
                                });
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

          // 🛒 Search Results
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text("No products found 😕",
                        style: TextStyle(color: Colors.black54)))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final item = filteredProducts[index];
                      final name = item['name']!;
                      final price = item['price']!;
                      final image = item['image']!;
                      final qty = cart.cartItems[name] ?? 0;

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Image.asset(
                            image,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.shopping_basket,
                                color: Colors.blue),
                          ),
                          title: Text(name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(price,
                              style:
                                  const TextStyle(color: Colors.blueAccent)),
                          trailing: qty == 0
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3D8BF2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                  ),
                                  onPressed: () {
                                    cart.addItem(
  id: name, // or a unique id like 's_${name.toLowerCase()}'
  name: name,
  price: 50.0, // you can change this based on your product
  image: 'assets/images/default.png', // update path if needed
);
                                    _addToRecent(searchQuery);
                                  },
                                  child: const Text("Add",
                                      style: TextStyle(color: Colors.white)),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3D8BF2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            cart.removeItem(name),
                                        icon: const Icon(Icons.remove,
                                            color: Colors.white),
                                      ),
                                      Text("$qty",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                        onPressed: () => cart.addItem(
  id: name, // or generate a unique id if needed
  name: name,
  price: 50.0, // put the actual price for that product
  image: 'assets/images/default.png', // update image path accordingly
),
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper: Category Chip
  Widget _categoryChip(String category) {
    final bool isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        selectedColor: const Color(0xFF3D8BF2),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        onSelected: (_) {
          setState(() => selectedCategory = category);
        },
      ),
    );
  }
}