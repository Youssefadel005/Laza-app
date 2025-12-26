import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = "https://api.escuelajs.co/api/v1/products";

  static Future<List<ProductModel>> getProducts() async {
    print("--------------------------------------------------");
    print("Attempting to connect to: $baseUrl");
    
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      print("Response Status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        print("SUCCESS! Data received from Platzi.");
        List<dynamic> body = jsonDecode(response.body);
        print("Found ${body.length} products.");
        
        // Take 20 items and convert them
        final List<ProductModel> products = body
            .take(20)
            .map((e) => ProductModel.fromJson(e))
            .toList();
            
        return products;
      } else {
        print("FAILED: Server returned ${response.statusCode}");
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("ERROR connecting: $e");
      throw Exception("Error connecting to API: $e");
    }
  }
}