import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 👇 Replace with your local IP address and correct Laravel port (8000)
  static const String baseUrl = 'http://192.168.1.5:8000/api';

  static Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}