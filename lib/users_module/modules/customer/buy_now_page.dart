import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/color_constants/color_constant.dart';
import 'package:intl/intl.dart';

class BuyNowPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const BuyNowPage({super.key, required this.product});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  String formattedDate = DateFormat('yyyy-MM-dd').format(Timestamp.now().toDate());
  final _formKey = GlobalKey<FormState>();
  String? address;
  String? phoneNumber;
  String? customizationText;

  Future<void> _confirmPurchase() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser ;
      if (user != null) {
        final orderCollection = FirebaseFirestore.instance.collection('orders');

        try {
          // Check if product data is valid
          if (widget.product['price'] == null) {
            throw Exception("Product data is incomplete.");
          }

          String orderId = DateTime.now().millisecondsSinceEpoch.toString();

          // Create the order document
          await orderCollection.add({
            'orderId': orderId,
            'userId': user.uid,
            'category': widget.product['category'],
            'productId': widget.product['productId'],
            'productName': widget.product['name'] ?? 'unKnown product',
            'price': widget.product['price'] ?? 0.0,
            'address': address ?? 'No address provided',
            'phoneNumber': phoneNumber ?? 'No phone number provided',
            'orderDate': formattedDate,
            'status': 'Pending',
            'customizationText': customizationText ?? 'No customizations', // Add customization text
            // If you have customization images, add them here
            'customizationImages': [], // Replace with actual images if available
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
  void initState() {
    super.initState();
    print("Product data: ${widget.product}"); // Debugging line
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width; // Get screen width
    var height = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstant.secondaryColor
        ),
        title: Text("Buy Now",
          style: TextStyle(
            color: ColorConstant.secondaryColor,
            fontWeight: FontWeight.w700
          ),
        ),
        backgroundColor: ColorConstant.primaryColor,
      ),
      backgroundColor: ColorConstant.secondaryColor,
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Center(
            child: Column(
              children: [
                Text(
                "Customize your needs",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: width * 0.07,
                    color: ColorConstant.primaryColor.withOpacity(0.25),
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
                SizedBox(height: height*0.025,),
                Container(
                  height: height * 0.08,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    color: ColorConstant.primaryColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(width * 0.075),
                  ),
                  child: Center(child: Text("lottiee (if interested)")),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.03),
          Column(
            crossAxisAlignment
            : CrossAxisAlignment.start,
            children: [
              Text(
                widget.product['name'] ?? widget.product['productName'] ?? "unknown",
                style: TextStyle(fontSize: width * 0.03, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.01),
              Text(
                widget.product['category'] ?? 'Unknown',
                style: TextStyle(fontSize: width * 0.03, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Price: ₹${widget.product['price']?.toString() ?? '0.0'}",
                style: TextStyle(fontSize: width * 0.0275),
              ),
            ],
          ),
          SizedBox(height: height * 0.025),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.005),
              Text(
                widget.product['description'] ?? "No description available.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: height * 0.005),
              TextField(
                cursorColor: ColorConstant.primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstant.primaryColor.withOpacity(0.1),
                  labelText: 'Add Customization Text',
                  labelStyle: TextStyle(color: ColorConstant.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.2),
                    borderSide: BorderSide(color: ColorConstant.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.2),
                    borderSide: BorderSide(color: ColorConstant.primaryColor),
                  ),
                ),
                style: TextStyle(color: ColorConstant.primaryColor),
                onChanged: (value) {
                  setState(() {
                    customizationText = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: height * 0.05),
          Column(
            children: [
              TextFormField(
                cursorColor: ColorConstant.primaryColor,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: ColorConstant.primaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorConstant.primaryColor,
                      width: width * 0.003,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorConstant.primaryColor,
                      width: width * 0.003,
                    ),
                  ),
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
              SizedBox(height: height * 0.02),
              TextFormField(
                cursorColor: ColorConstant.primaryColor,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: ColorConstant.primaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorConstant.primaryColor,
                      width: width * 0.003,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorConstant.primaryColor,
                      width: width * 0.003,
                    ),
                  ),
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
            ],
          ),
          SizedBox(height: height * 0.1),
          Center(
            child: GestureDetector(
              onTap: _confirmPurchase,
              child: Container(
                height: height * 0.05,
                width: width * 0.3,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.circular(width * 0.05),
                ),
                child: Center(
                  child: Text(
                    "Confirm order",
                    style: TextStyle(
                      color: ColorConstant.secondaryColor,
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          )],
          ),
        ),
      ),
    ),
    );
  }
}