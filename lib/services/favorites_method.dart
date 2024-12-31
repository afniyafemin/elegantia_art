import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddToFav {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkIfLiked(String productId) async {
    final user = _auth.currentUser ;
    if (user != null) {
      final likedItemsCollection = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final docRef = likedItemsCollection.doc(productId);
      final snapshot = await docRef.get();
      return snapshot.exists; // Return true if liked, false otherwise
    }
    return false; // User not logged in
  }

  Future<void> toggleLike(String productId, Map<String, dynamic> productData) async {
    final user = _auth.currentUser ;
    if (user != null) {
      final likedItemsCollection = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final productCollection = _firestore.collection('products');
      final docRef = likedItemsCollection.doc(productId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        // Unlike the product
        await docRef.delete();
        // Decrement the like count in the product collection
        await productCollection.doc(productId).update({
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        // Like the product
        await docRef.set(productData);
        // Increment the like count in the product collection
        await productCollection.doc(productId).update({
          'likeCount': FieldValue.increment(1),
        });
      }
    }
  }
}