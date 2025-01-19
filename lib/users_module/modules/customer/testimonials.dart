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
  Future<List<String>> fetchReviews(String productId) async {
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
      if (data == null || !data.containsKey('feedbacks')) {
        print("No feedbacks found for product with ID $productId.");
        return [];
      }

      // Extract feedbacks from the 'feedbacks' field and sanitize
      final feedbacks = data['feedbacks'] as List<dynamic>;
      return feedbacks
          .where((feedback) => feedback != null && feedback is String) // Filter out invalid entries
          .map((feedback) => feedback as String) // Safely cast to String
          .toList();
    } catch (error) {
      print("Error fetching feedbacks for product $productId: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        title: Text("Testimonials",
          style: TextStyle(
            color: ColorConstant.secondaryColor,
            fontWeight: FontWeight.w900,
            fontSize: width*0.04
          ),
        ),
        backgroundColor: ColorConstant.primaryColor,
      ),
      body: Padding(
        padding:  EdgeInsets.all(width*0.025),
        child: FutureBuilder<List<String>>(
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
                return Card(
                  color: ColorConstant.secondaryColor.withOpacity(0.75),
                  child: ListTile(
                    title: Text('''${reviews[index]}''',
                      style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: width*0.03
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
