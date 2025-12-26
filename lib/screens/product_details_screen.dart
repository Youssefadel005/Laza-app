import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart'; // Import the service

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  // Handle Add to Cart (Saves to Firestore)
  void _handleAddToCart() async {
    setState(() => _isLoading = true);
    try {
      await _firestoreService.addToCart(widget.product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added to Cart!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Handle Favorites (Saves to Firestore)
  void _handleToggleFavorite() async {
    try {
      bool isFav = await _firestoreService.toggleFavorite(widget.product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFav ? "Added to Favorites" : "Removed from Favorites"),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          // FAVORITES BUTTON
          Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.red),
              onPressed: _handleToggleFavorite,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Big Image Area
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            color: Colors.grey[100],
            child: Image.network(
              widget.product.image ?? '',
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => const Icon(Icons.error, size: 50),
            ),
          ),

          // 2. White Details Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "\$${widget.product.price}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9775FA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This is a premium product from the Laza collection. High quality, durable, and designed for your style.",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  
                  const Spacer(),
                  
                  // ADD TO CART BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      // --- THIS IS THE KEY YOU NEEDED FOR APPIUM ---
                      key: const Key('add_to_cart_btn'), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9775FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleAddToCart,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}