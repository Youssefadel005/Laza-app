import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper to get current User ID securely
  String? get _userId => _auth.currentUser?.uid;

  // --- USER LOGIC (This fixes your error) ---
  
  // Call this right after Registration to save user data
  Future<void> createUserProfile(User user) async {
    await _db.collection('users').doc(user.uid).set({
      'email': user.email,
      'uid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // --- CART LOGIC ---
  
  // 1. Add item to cart
  Future<void> addToCart(ProductModel product) async {
    if (_userId == null) return;

    final docRef = _db
        .collection('carts')
        .doc(_userId)
        .collection('items')
        .doc(product.id.toString());

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({'quantity': FieldValue.increment(1)});
    } else {
      await docRef.set({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.image,
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // 2. Get Cart Stream
  Stream<QuerySnapshot> getCartStream() {
    if (_userId == null) return const Stream.empty();
    return _db
        .collection('carts')
        .doc(_userId)
        .collection('items')
        .orderBy('addedAt', descending: true)
        .snapshots();
  }

  // 3. Remove Item
  Future<void> removeFromCart(String productId) async {
    if (_userId == null) return;
    await _db.collection('carts').doc(_userId).collection('items').doc(productId).delete();
  }

  // 4. Clear Cart
  Future<void> clearCart() async {
    if (_userId == null) return;
    final snapshot = await _db.collection('carts').doc(_userId).collection('items').get();
    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // --- FAVORITES LOGIC ---

  // 1. Get Favorites Stream
  Stream<QuerySnapshot> getFavoritesStream() {
    if (_userId == null) return const Stream.empty();
    return _db
        .collection('favorites')
        .doc(_userId)
        .collection('items')
        .orderBy('addedAt', descending: true)
        .snapshots();
  }

  // 2. Toggle Favorite
  Future<bool> toggleFavorite(ProductModel product) async {
    if (_userId == null) return false;

    final docRef = _db
        .collection('favorites')
        .doc(_userId)
        .collection('items')
        .doc(product.id.toString());

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
      return false; 
    } else {
      await docRef.set({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.image,
        'addedAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
  }
}