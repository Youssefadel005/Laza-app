import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getCartStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          final items = snapshot.data!.docs;
          
          double totalPrice = 0;
          for (var doc in items) {
            final data = doc.data() as Map<String, dynamic>;
            totalPrice += (data['price'] ?? 0) * (data['quantity'] ?? 1);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final data = items[index].data() as Map<String, dynamic>;
                    final docId = items[index].id;

                    return Card(
                      // KEY FOR APPIUM TEST
                      key: index == 0 ? const Key('cart_item_0') : null, 
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: ListTile(
                        leading: Image.network(
                          data['image'] ?? '',
                          width: 50, height: 50, fit: BoxFit.cover,
                          errorBuilder: (c,o,s) => const Icon(Icons.error),
                        ),
                        title: Text(data['title'] ?? 'Product'),
                        subtitle: Text("\$${data['price']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => firestoreService.removeFromCart(docId),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("\$${totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA)),
                        onPressed: () async {
                           await firestoreService.clearCart();
                           if(context.mounted) Navigator.pop(context);
                        },
                        child: const Text("Checkout", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}