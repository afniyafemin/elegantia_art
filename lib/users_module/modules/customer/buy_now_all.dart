import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyNowAllPage extends StatefulWidget {
  final List<Map<String, dynamic>> allCartItems;
  final double totalAmount;

  const BuyNowAllPage({super.key, required this.allCartItems, required this.totalAmount});

  @override
  State<BuyNowAllPage> createState() => _BuyNowAllPageState();
}

class _BuyNowAllPageState extends State<BuyNowAllPage> {
  String formattedDate =
      DateFormat('yyyy-MM-dd').format(Timestamp.now().toDate());
  final _formKey = GlobalKey<FormState>();
  String? address;
  String? phoneNumber;
  String? customizationText;

  Future<void> _confirmPurchase() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final orderCollection = FirebaseFirestore.instance.collection('orders');
        String orderId = DateTime.now().millisecondsSinceEpoch.toString();

        try {
          for (var item in widget.allCartItems) {
            await orderCollection.add({
              'orderId': orderId,
              'userId': user.uid,
              'category': item['category'],
              'productId': item['productId'],
              'productName': item['productName'] ?? 'Unknown Product',
              'price': item['price'] ?? 0.0,
              'address': address ?? 'No address provided',
              'phoneNumber': phoneNumber ?? 'No phone number provided',
              'customizationText': customizationText ?? 'No customization',
              'orderDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'status': 'Pending',
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order placed successfully!')),
          );

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
        padding: EdgeInsets.all(width * 0.05),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Center(
                      child: Text(
                        "Customize your needs",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: width * 0.07,
                          color: ColorConstant.primaryColor.withOpacity(0.25),
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                    ),
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
                SizedBox(height: height*0.015,),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: widget.allCartItems.isEmpty
                      ? Center(child: Text("No products in cart"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.allCartItems.length,
                          itemBuilder: (context, index) {
                            final item = widget.allCartItems[index];
                            return Padding(
                              padding:  EdgeInsets.only(bottom: height*0.01),
                              child: ListTile(
                                tileColor: ColorConstant.primaryColor,
                                textColor: ColorConstant.secondaryColor,
                                titleTextStyle:TextStyle(
                                  fontSize: width*0.04,
                                  fontWeight: FontWeight.w900,
                                ),
                                title: Text(
                                    item['productName'] ?? 'Unknown Product'),
                                subtitle: Text(
                                    "Price: ₹${item['price']?.toString() ?? '0.0'} \n category : ${item['category']}"),
                                onTap: () {
                                  // Handle item tap if needed
                                },
                              ),
                            );
                          },
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Total Amount : ",
                      style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: width*0.05
                      ),
                    ),
                    Container(
                      height: height*0.04,
                      width: width*0.2,
                      decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.circular(width*0.05),
                      ),
                      child: Center(child: Text(widget.totalAmount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ColorConstant.secondaryColor
                        ),
                      ),),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Column(
                  children: [
                    TextFormField(
                      cursorColor: ColorConstant.primaryColor,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle:
                            TextStyle(color: ColorConstant.primaryColor),
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
                        labelStyle:
                            TextStyle(color: ColorConstant.primaryColor),
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
                SizedBox(height: height * 0.05),
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
