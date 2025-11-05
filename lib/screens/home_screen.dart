import 'package:flutter/material.dart';
import 'package:grocery_app/screens/category_layout_screen.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/refer_screen.dart';
import 'package:grocery_app/screens/wallet_screen.dart';
import 'package:grocery_app/screens/search_screen.dart'; // ✅ Added
import '../data/product_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _topPicks = [
    {"name": "Amul Milk", "price": "₹30", "icon": Icons.local_drink},
    {"name": "Bananas", "price": "₹50", "icon": Icons.eco},
    {"name": "Brown Bread", "price": "₹40", "icon": Icons.cake},
    {"name": "Eggs Pack", "price": "₹60", "icon": Icons.egg},
  ];

  final List<Map<String, dynamic>> _dailyEssentials = [
    {"name": "Milk", "price": "₹30", "icon": Icons.local_drink},
    {"name": "Bread", "price": "₹40", "icon": Icons.cake},
    {"name": "Eggs", "price": "₹60", "icon": Icons.egg},
    {"name": "Fruits", "price": "₹80", "icon": Icons.apple},
    {"name": "Butter", "price": "₹70", "icon": Icons.breakfast_dining},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BF2),
        elevation: 0,
        title: const Text(
          'grocery_app',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined,
                color: Colors.white, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white, size: 26),
                onPressed: () {
                 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const CartScreen(),
  ),
);
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),

      // 🧾 Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Greeting + Delivery info + Search
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF3D8BF2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Good Afternoon, Atharva 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Delivering Tomorrow Morning ⏰",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔍 Tap-to-Navigate Search Bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey, size: 22),
                          SizedBox(width: 8),
                          Text(
                            "Search for milk, fruits, groceries...",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🛍 Categories section
            const Text(
              "Shop by Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _categoryItem("Fruits", Icons.apple, Colors.redAccent, context),
                  _categoryItem("Vegetables", Icons.eco, Colors.green, context),
                  _categoryItem("Dairy", Icons.local_drink, Colors.orangeAccent, context),
                  _categoryItem("Bakery", Icons.cake, Colors.pinkAccent, context),
                  _categoryItem("Groceries", Icons.shopping_bag, Colors.blueAccent, context),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🏆 Top Picks
            const Text(
              "Top Picks for You",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.8,
              children: _topPicks
                  .map((p) => _productCard(p["name"], p["price"], p["icon"]))
                  .toList(),
            ),

            const SizedBox(height: 24),

            // 🎁 Refer & Earn Banner
            _referBanner(context),

            const SizedBox(height: 30),

            // 🧃 Daily Essentials
            const Text(
              "Daily Essentials",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _dailyEssentials
                    .map((p) =>
                        _dailyEssentialCard(p["name"], p["price"], p["icon"]))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Category Item
  static Widget _categoryItem(
      String name, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryLayoutScreen(initialCategory: name),
          ),
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 6),
            Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // 🧩 Product Card
  static Widget _productCard(String name, String price, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF3D8BF2), size: 48),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          Text(price,
              style: const TextStyle(
                  color: Color(0xFF3D8BF2), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D8BF2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            onPressed: () {},
            child:
                const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 🧃 Daily Essentials
  static Widget _dailyEssentialCard(
      String name, String price, IconData icon) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3D8BF2), size: 36),
            const SizedBox(height: 8),
            Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            Text(price,
                style: const TextStyle(
                    color: Color(0xFF3D8BF2),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // 🎁 Refer & Earn Banner
  Widget _referBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D8BF2), Color(0xFF61A4F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Refer & Earn ₹100",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(
                "Invite friends and earn rewards 🎁",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReferScreen()),
              );
            },
            child: const Text("Invite Now",
                style: TextStyle(
                    color: Color(0xFF3D8BF2),
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}