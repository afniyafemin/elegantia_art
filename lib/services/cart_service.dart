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

      try {
        // Check if productData is null
        if (productData == null) {
          print("Error: productData is null.");
          throw Exception("Product data is null.");
        }

        // Check if required fields are present in productData
        if (productData['name'] == null) {
          print("Error: productData['name'] is null.");
          throw Exception("Product name is null.");
        }
        if (productData['price'] == null) {
          print("Error: productData['price'] is null.");
          throw Exception("Product price is null.");
        }
        if (productData['category'] == null) {
          print("Error: productData['category'] is null.");
          throw Exception("Product category is null.");
        }
        if (productData['description'] == null) {
          print("Error: productData['description'] is null.");
          throw Exception("Product description is null.");
        }
        if (productData['imageUrl'] == null) {
          print("Warning: productData['imageUrl'] is null, using default.");
        }

        // Add product to cart
        await cartCollection.doc(productId).set({
          'productId': productId,
          'productName': productData['name'],
          'price': productData['price'],
          'quantity': quantity,
          'isLiked': productData['isLiked'] ?? false, // Store the like status, default to false if null
          'category': productData['category'], // Add the category here
          'description': productData['description'],
          'image': productData['imageUrl'] ?? '', // Use empty string if imageUrl is null
        });

        print("Product added to cart successfully!");
      } catch (e) {
        print("Error adding to cart: $e"); // Print the error message
        throw Exception("Failed to add product to cart: $e"); // Rethrow the exception with a message
      }
    } else {
      // Handle user not logged in
      print("User  not logged in.");
      throw Exception("User  not logged in");
    }
  }
}