import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart'; <--- Delete This Line

import '../services/api_service.dart';
import '../models/product_model.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Laza Products"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // 1. FAVORITES BUTTON
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),

          // 2. CART BUTTON
          IconButton(
            key: const Key('cart_icon'),
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),

          // 3. PROFILE BUTTON
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      // This body fetches the data
      body: FutureBuilder<List<ProductModel>>(
        future: ApiService.getProducts(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } 
          else if (snapshot.hasData) {
            final products = snapshot.data!;
            
            return GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                
                return GestureDetector(
                  key: index == 0 ? const Key('first_product') : null, 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              // --- UPDATED IMAGE SECTION FOR DEBUGGING ---
                              child: Image.network(
                                product.image ?? '',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // This prints the specific error to your console
                                  print("---------------------------------------");
                                  print("FAILED URL: ${product.image}");
                                  print("ERROR REASON: $error");
                                  print("---------------------------------------");
                                  
                                  return const Icon(Icons.error, color: Colors.red);
                                },
                              ),
                              // -------------------------------------------
                            ),
                          ),
                        ),
                        // Details
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title ?? 'No Title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "\$${product.price}",
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No products found."));
        },
      ),
    );
  }
}