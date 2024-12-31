import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/color_constants/color_constant.dart';

class BuyNowPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const BuyNowPage({super.key, required this.product});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  final _formKey = GlobalKey<FormState>();
  String? address;
  String? phoneNumber;
  int quantity = 1;

  Future<void> _confirmPurchase() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser ;
      if (user != null) {
        final orderCollection = FirebaseFirestore.instance.collection('orders');

        try {
          // Check if product data is valid
          if (widget.product['productId'] == null || widget.product['price'] == null) {
            throw Exception("Product data is incomplete.");
          }

          await orderCollection.add({
            'userId': user.uid,
            'productId': widget.product['productId'],
            'productName': widget.product['productName'] ?? 'Unknown Product', // Handle null
            'price': widget.product['price'] ?? 0.0, // Handle null
            'quantity': quantity,
            'address': address ?? 'No address provided', // Handle null
            'phoneNumber': phoneNumber ?? 'No phone number provided', // Handle null
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order placed successfully!'),
            ),
          );

          // Optionally navigate back or to another page
          Navigator.pop(context);
        } catch (e) {
          print('Error adding order to Firestore: $e'); // Debugging
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to place order: ${e.toString()}'),
            ),
          );
        }
      } else {
        // Handle user not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please log in to place an order.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Now"),
        backgroundColor: ColorConstant.primaryColor,
      ),
      backgroundColor: ColorConstant.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product['productName'] ?? 'Unknown Product', // Handle null
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Price: ₹${widget.product['price']?.toString() ?? '0.0'}", // Handle null
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onChanged: (value) {
                  address = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                        }
                      });
                    },
                  ),
                  Text(quantity.toString(), style: TextStyle(fontSize: 20 )),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmPurchase,
                child: Text("Confirm Purchase"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}