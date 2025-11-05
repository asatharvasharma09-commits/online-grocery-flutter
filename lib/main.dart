import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🛒 Providers
import 'package:grocery_app/providers/cart_provider.dart';

// 🧭 Screens
import 'screens/category_layout_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/main_navigation.dart';

import 'screens/splash_screen.dart';
import 'screens/main_tabs.dart'; // ✅ Customer dashboard
import 'screens/seller_main_tabs.dart'; // ✅ Seller dashboard
import 'providers/order_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF3D8BF2), // MilkBasket Blue
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3D8BF2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF3D8BF2),
          secondary: const Color(0xFF3D8BF2),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3D8BF2),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3D8BF2),
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),

      // 🏁 App starts from Splash
     home: const SplashScreen(),

      // 🗺️ App routes for navigation
      routes: {
               // Login/Registration
        '/customer': (_) => const MainTabs(),      // Customer dashboard
        '/seller': (_) => const SellerMainTabs(),  // Seller dashboard
      },
    );
  }
}