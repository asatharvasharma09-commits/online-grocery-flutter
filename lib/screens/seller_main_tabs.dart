// lib/screens/seller_main_tabs.dart
import 'package:flutter/material.dart';
import 'seller_dashboard_screen.dart';
import 'seller_inventory_screen.dart';
import 'seller_orders_screen.dart';
import 'seller_reviews_screen.dart'; // add this file (reviews screen)
import 'seller_profile_page.dart';

class SellerMainTabs extends StatefulWidget {
  /// Optional: startIndex allows redirecting into a specific tab
  /// e.g. Navigator.push(..., MaterialPageRoute(builder: (_) => SellerMainTabs(startIndex: 3)));
  final int startIndex;
  const SellerMainTabs({super.key, this.startIndex = 0});

  @override
  State<SellerMainTabs> createState() => _SellerMainTabsState();
}

class _SellerMainTabsState extends State<SellerMainTabs> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
  }

  final List<Widget> _screens = const [
    SellerDashboardScreen(),
    SellerInventoryScreen(),
    SellerOrdersScreen(),
    SellerReviewsScreen(),
    SellerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF3D8BF2),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: "Inventory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews_outlined),
            label: "Reviews",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}