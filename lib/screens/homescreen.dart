import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              hintText: 'Search for fruits, veggies, or groceries',
              hintStyle: const TextStyle(fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 10),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Featured Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryCard('Fruits', Icons.apple, Colors.orange),
                _categoryCard('Vegetables', Icons.eco, Colors.green),
                _categoryCard('Dairy', Icons.local_drink, Colors.blue),
                _categoryCard('Bakery', Icons.cookie, Colors.brown),
                _categoryCard('Beverages', Icons.local_cafe, Colors.purple),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Top Picks for You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
            children: [
              _productCard('Banana', '₹40', Icons.shopping_bag),
              _productCard('Tomato', '₹25', Icons.shopping_bag),
              _productCard('Milk', '₹60', Icons.local_drink),
              _productCard('Bread', '₹35', Icons.cookie),
            ],
          ),
        ],
      ),
    );
  }

  // Category card widget
  Widget _categoryCard(String title, IconData icon, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Product card widget
  Widget _productCard(String name, String price, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 40),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(price,
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: const Text('+ Add'),
          ),
        ],
      ),
    );
  }
}