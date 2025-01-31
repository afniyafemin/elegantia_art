import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/users_module/modules/customer/buy_now_all.dart';
import 'package:elegantia_art/users_module/modules/customer/buy_now_page.dart';
import 'package:elegantia_art/users_module/modules/customer/my_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/color_constants/color_constant.dart';
import '../../../constants/image_constants/image_constant.dart';
import '../../../main.dart';
import '../../../services/address_fetcher.dart';
import '../../../services/favorites_method.dart';
import 'change_address.dart';

class CartCustomer extends StatefulWidget {

  const CartCustomer({super.key,});

  @override
  State<CartCustomer> createState() => _CartCustomerState();
}
List<Map<String, dynamic>> allCartItems = [];
class _CartCustomerState extends State<CartCustomer> {

  double totalAmount = 0.0; // Variable to track total amount
  final AddToFav _addToFav = AddToFav(); // Create an instance of LikeService

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser ;
      if (user != null) {
        final cartCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart');
        final snapshot = await cartCollection.get();

        List<Map<String, dynamic>> cartItems = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();

        // Fetch product details for each cart item
        for (var item in cartItems) {
          final productDetails = await _fetchProductDetails(item['id']);
          if (productDetails != null) {
            item.addAll(productDetails); // Merge product details into the cart item
          }
        }

        setState(() {
          allCartItems = cartItems;
        });
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAddresses(String userId) async {
    // Check if userId is valid
    if (userId.isEmpty) {
      print('User  ID is empty.');
      return [];
    }

    try {
      // Fetch the addresses from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('address')
          .get();

      // Convert each document to a Map<String, dynamic>
      List<Map<String, dynamic>> addresses = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      // Optionally, you can log the number of addresses fetched
      print('Fetched ${addresses.length} addresses for user ID: $userId');

      return addresses;
    } catch (e) {
      // Log the error for debugging
      print('Error fetching addresses for user ID $userId: $e');
      return [];
    }
  }

  Future<void> _removeFromCart(String? productId) async {
    if (productId == null) {
      print('Product ID is null, cannot remove from cart.');
      return; // Early return if productId is null
    }

    try {
      final user = FirebaseAuth.instance.currentUser ;
      if (user != null) {
        final cartCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart');
        await cartCollection.doc(productId).delete();

        // Show success message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item removed from cart successfully!'),
            // backgroundColor: Colors.green,
          ),
        );

        _fetchCartItems(); // Refresh cart items after deletion
      }
    } catch (e) {
      print('Error removing item from cart: $e');
      // Show error message (optional)
    }
  }

  Future<Map<String, dynamic>?> _fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        return productDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return null;
  }


  Future<void> _toggleLike(Map<String, dynamic> item) async {
    await _addToFav.toggleLike(item['productId'], item);
    setState(() {
      item['isLiked'] = !item['isLiked']; // Toggle the like state in the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser ;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorConstant.secondaryColor,
          appBar: AppBar(
            backgroundColor: ColorConstant.primaryColor,
            title: Text(
              "My Cart",
              style: TextStyle(
                  color: ColorConstant.secondaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.05),
            ),
            actions: [
              Padding(
                padding:  EdgeInsets.all(width*0.03),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders(),));
                  },
                  child: Column(
                    children: [
                      Icon(Icons.card_travel,
                        color: ColorConstant.secondaryColor,
                        size: width*0.05,
                      ),
                      Text("My Orders",
                        style: TextStyle(
                          fontSize: width*0.015,
                          color: ColorConstant.secondaryColor,
                          fontWeight: FontWeight.w900
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.05),
                  height: height * 0.23,
                  decoration: BoxDecoration(
                      color: ColorConstant.primaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(width * 0.05)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Use AddressFetcher widget here
                      if (user != null)
                        AddressFetcher(userId: user.uid)
                      else
                        Text('User  not logged in.'),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeAddress(),
                            ),
                          );
                        },
                        child: Container(
                          height: height * 0.04,
                          width: width * 0.25,
                          decoration: BoxDecoration(
                              color: ColorConstant.primaryColor,
                              borderRadius: BorderRadius.circular(width * 0.05)),
                          child: Center(
                            child: Text(
                              "Change",
                              style: TextStyle(
                                  color: ColorConstant.secondaryColor,
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.015),
                Expanded(
                  child: ListView.builder(
                    itemCount: allCartItems.length,
                    itemBuilder: (context, index) {
                      final item = allCartItems[index];
                      final id = item['id'];
                      final productName = item['name'] ?? 'Unknown Product'; // Provide default value
                      final price = item['price'] ?? 0.0; // Provide default value
                      final image = item['imageUrl'] ?? ImageConstant.aesthetic_userprofile; // Provide default image
                      final description = item['description'] ?? 'No description available'; // Provide default description
                      final category = item['category'] ?? 'No category'; // Provide default category

                      return Container(
                        padding: EdgeInsets.all(width * 0.03),
                        margin: EdgeInsets.only(top: width * 0.03),
                        height: height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          color: ColorConstant.primaryColor.withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: height * 0.2,
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(width * 0.03),
                                    image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: height * 0.12, left: width * 0.25),
                                  child: IconButton(
                                    onPressed: () => _toggleLike(item),
                                    icon: Icon(
                                      item['isLiked'] == true ? Icons.favorite : Icons.favorite_border,
                                      color: item['isLiked'] == true ? Colors.red : ColorConstant.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${productName ?? 'Unknown Product'} \n${category ?? ''}\n₹${price ?? '0'}",
                                  style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => BuyNowPage(product: item)));
                                      },
                                      child: Container(
                                        height: height * 0.05,
                                        width: width * 0.275,
                                        decoration: BoxDecoration(
                                            color: ColorConstant.primaryColor,
                                            borderRadius: BorderRadius.circular(width * 0.03)),
                                        child: Center(
                                          child: Text(
                                            "Buy Now",
                                            style: TextStyle(
                                                color: ColorConstant.secondaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.03),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.05),
                                    GestureDetector(
                                      onTap: () => _removeFromCart(id),
                                      child: Container(
                                        height: height * 0.05,
                                        width: width * 0.15,
                                        decoration: BoxDecoration(
                                          color: ColorConstant.primaryColor,
                                          borderRadius: BorderRadius.circular(width * 0.03),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.delete,
                                            color: ColorConstant.secondaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   child: Container(
        //     width: width * 1,
        //     height: height * 0.08,
        //     decoration: BoxDecoration(
        //         color: ColorConstant.secondaryColor,
        //         borderRadius: BorderRadius.circular(width * 0.05)),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         Text(
        //           "TOTAL \nRs. ${totalAmount.toStringAsFixed(2)}",
        //           style: TextStyle(
        //               fontSize: width * 0.03,
        //               color: ColorConstant.primaryColor),
        //         ),
        //         GestureDetector(
        //           onTap: () {
        //             Navigator.push(context, MaterialPageRoute(builder: (context) => BuyNowAllPage(allCartItems: allCartItems, totalAmount: totalAmount,),));
        //           },
        //           child: Container(
        //             height: height * 0.05,
        //             width: width * 0.4,
        //             decoration: BoxDecoration(
        //                 color: ColorConstant.primaryColor,
        //                 borderRadius: BorderRadius.circular(width * 0.03)),
        //             child: Center(
        //               child: Text(
        //                 "Buy Now",
        //                 style: TextStyle(
        //                     color: ColorConstant.secondaryColor,
        //                     fontSize: width * 0.03),
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }

}