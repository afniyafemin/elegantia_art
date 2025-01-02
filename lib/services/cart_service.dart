import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String productId, Map<String, dynamic> productData, int quantity) async {
    final user = _auth.currentUser ;
    if (user != null) {
      final cartCollection = _firestore.collection('users')
          .doc(user.uid).collection('cart');

      await cartCollection.doc(productId).set({
        'productId': productId,
        'productName': productData['name'],
        'price': productData['price'],
        'quantity': quantity,
        'customizationText': productData['customizationText'],
        'customizationImage': productData['customizationImage'],
        'isLiked': productData['isLiked'], // Store the like status
        'category': productData['category'], // Add the category here
      });
    } else {
      // Handle user not logged in
      throw Exception("User  not logged in");
    }
  }
}