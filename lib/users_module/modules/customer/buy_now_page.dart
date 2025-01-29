import 'dart:io';

import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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

  // TextEditingControllers for address fields
  final nameController = TextEditingController();
  final postController = TextEditingController();
  final pinController = TextEditingController();
  final landmarkController = TextEditingController();
  final phoneController = TextEditingController();

  String? customizationText;
  List<String> customizationImages = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user address data
  }

  /// Load user data from Firestore and auto-fill the text fields
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('address')
            .doc('currentAddress') // Assuming you have a document named 'currentAddress'
            .get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            nameController.text = data['name'] ?? '';
            postController.text = data['post'] ?? '';
            pinController.text = data['pin'] ?? '';
            landmarkController.text = data['landmark'] ?? '';
            phoneController.text = data['phone'] ?? '';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  Future<void> _removeFromCart(String productId) async {
    final user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(productId) // Use the product ID to remove the specific item
            .delete();
      } catch (e) {
        print('Error removing item from cart: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove item from cart: $e')),
        );
      }
    }
  }

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
            'imageUrl': widget.product['imageUrl'],
            'productId': widget.product['id'] ?? widget.product["productId"],
            'productName': widget.product['name'] ?? widget.product["productName"],
            'price': widget.product['price'] ?? 0.0,
            'address': {
              'name': nameController.text.trim().isNotEmpty ? nameController.text.trim() : null,
              'post': postController.text.trim().isNotEmpty ? postController.text.trim() : null,
              'pin': pinController.text.trim().isNotEmpty ? pinController.text.trim() : null,
              'landmark': landmarkController.text.trim().isNotEmpty ? landmarkController.text.trim() : null,
              'phone': phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
            },
            'orderDate': formattedDate,
            'status': 'Pending',
            'customizationText': customizationText ?? 'No customizations',
            'customizationImages': customizationImages, // Replace with actual images if available
          });

          // Remove the item from the cart
          await _removeFromCart(widget.product['productId']??widget.product['id']);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order placed successfully!'),
            ),
          );

          // Navigate back to the previous page
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


  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      for (XFile image in selectedImages) {
        String imageUrl = await _uploadImageToStorage(image);
        if (imageUrl.isNotEmpty) {
          setState(() {
            customizationImages.add(imageUrl);
          });
        }
      }
    }
  }

  Future<String> _uploadImageToStorage(XFile image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + image.name;
      Reference storageRef = FirebaseStorage.instance.ref().child('customizations/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.secondaryColor),
        title: Text(
          "Buy Now",
          style: TextStyle(color: ColorConstant.secondaryColor, fontWeight: FontWeight.w700),
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
                      SizedBox(height: height * 0.03),
                      Container(
                        height: height * 0.2,
                        width: width * 0.4,
                        decoration: BoxDecoration(
                          image:  DecorationImage(image:  NetworkImage(widget.product['imageUrl'] ?? ImageConstant.product2)),
                          borderRadius: BorderRadius.circular(width * 0.065),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product['name'] ?? widget.product['productName'] ?? "unknown",
                          style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Price: ₹${widget.product['price']?.toString() ?? '0.0'}",
                          style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Text(
                      widget.product['category'] ?? 'Unknown',
                      style: TextStyle(fontSize: width * 0.03, fontWeight: FontWeight.bold, color: ColorConstant.primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.025),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['description'] ?? "No description available.",
                      style: TextStyle(fontSize: 14, color: ColorConstant.primaryColor),
                    ),
                    SizedBox(height: height * 0.04),
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
                // Image upload button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ColorConstant.secondaryColor,
                      backgroundColor: ColorConstant.primaryColor
                    ),
                    onPressed: _pickImages,
                    child: Text("Upload Customization Images"),
                  ),
                ),
                SizedBox(height: height * 0.02),
                // Display uploaded images
                if (customizationImages.isNotEmpty) ...[
                  Text("Uploaded Images:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.02),
                  Wrap(
                    spacing: 8.0,
                    children: customizationImages.map((url) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                // Address fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: postController,
                      decoration: InputDecoration(labelText: 'Post'),
                      validator: (value) => value!.isEmpty ? 'Please enter your post' : null,
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: pinController,
                      decoration: InputDecoration(labelText: 'Pin'),
                      validator: (value) => value!.isEmpty ? 'Please enter your pin' : null,
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: landmarkController,
                      decoration: InputDecoration(labelText: 'Landmark'),
                      validator: (value) => value!.isEmpty ? 'Please enter a landmark' : null,
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}