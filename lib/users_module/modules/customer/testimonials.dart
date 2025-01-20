import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class Testimonials extends StatefulWidget {
  final String productId;
  const Testimonials({super.key, required this.productId});

  @override
  State<Testimonials> createState() => _TestimonialsState();
}

class _TestimonialsState extends State<Testimonials> {
  Future<List<Map<String, dynamic>>> fetchReviews(String productId) async {
    try {
      // Reference to the specific product document
      final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
      // Fetch the product document
      final productSnapshot = await productRef.get();

      // Check if the document exists
      if (!productSnapshot.exists) {
        print("Product with ID $productId does not exist.");
        return [];
      }

      // Retrieve data from the document
      final data = productSnapshot.data();
      if (data == null || !data.containsKey('ratings')) {
        print("No ratings found for product with ID $productId.");
        return [];
      }

      // Extract ratings from the 'ratings' field
      final ratings = data['ratings'];

      // Check if ratings is a List
      if (ratings is! List) {
        print("Expected ratings to be a List, but got: ${ratings.runtimeType}");
        return [];
      }

      List<Map<String, dynamic>> reviewsWithUsernames = [];

      for (var rating in ratings) {
        if (rating != null && rating is Map<String, dynamic>) {
          // Fetch the username for each rating
          String userId = rating['userId'];
          String feedback;

          // Handle feedback as an array of dynamic
          if (rating['feedback'] is List) {
            // Join the feedback array into a single string
            feedback = (rating['feedback'] as List<dynamic>).join(', ');
          } else if (rating['feedback'] is String) {
            feedback = rating['feedback'];
          } else {
            feedback = 'No feedback provided';
          }

          double ratingValue = rating['rating'] ?? 0.0;

          String username = await fetchUsername(userId);
          reviewsWithUsernames.add({
            'username': username,
            'feedback': feedback,
            'rating': ratingValue,
          });
        }
      }

      return reviewsWithUsernames;
    } catch (error) {
      print("Error fetching ratings for product $productId: $error");
      return [];
    }
  }

  Future<String> fetchUsername(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        return userData?['username'] ?? 'Unknown User'; // Adjust the key based on your Firestore structure
      } else {
        return 'Unknown User';
      }
    } catch (error) {
      print("Error fetching username for user $userId: $error");
      return 'Unknown User';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        title: Text(
          "Testimonials",
          style: TextStyle(
            color: ColorConstant.secondaryColor,
            fontWeight: FontWeight.w900,
            fontSize: width * 0.04,
          ),
        ),
        backgroundColor: ColorConstant.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.025),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchReviews(widget.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No reviews yet..",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }

            final reviews = snapshot.data!;

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  color: ColorConstant.secondaryColor.withOpacity(0.75),
                  child: ListTile(
                    title: Text(
                      '''${review['feedback']}''',
                      style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: width * 0.03,
                      ),
                    ),
                    subtitle: Text(
                      'Rating: ${review['rating']} by ${review['username']}',
                      style: TextStyle(
                        color: ColorConstant.primaryColor.withOpacity(0.7),
                        fontSize: width * 0.025,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}