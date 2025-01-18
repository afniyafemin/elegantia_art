import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/color_constants/color_constant.dart';
import '../../../services/favorites_method.dart';

class Pins extends StatefulWidget {
  const Pins({super.key});

  @override
  State<Pins> createState() => _PinsState();
}

class _PinsState extends State<Pins> {
  List<Map<String, dynamic>> favoriteProducts = [];
  final AddToFav _addToFav = AddToFav();

  @override
  void initState() {
    super.initState();
    _fetchFavoriteProducts();
  }

  Future<void> _fetchFavoriteProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final likedItemsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final snapshot = await likedItemsCollection.get();
      setState(() {
        favoriteProducts = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add the document ID
          return data;
        }).toList();
      });
    }
  }

  Future<void> _toggleLike(int index) async {
    final product = favoriteProducts[index];
    final productId = product['id'];

    // Update Firestore
    await _addToFav.toggleLike(productId, product);

    // Update local state
    setState(() {
      favoriteProducts[index]['isLiked'] = !favoriteProducts[index]['isLiked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height * 0.35,
                  width: width,
                  decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(width * 0.35),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pins",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ColorConstant.secondaryColor.withOpacity(0.5),
                          fontSize: height * 0.04,
                        ),
                      ),
                      Text(
                        "Your Favorite Products",
                        style: TextStyle(
                          color: ColorConstant.secondaryColor.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                          fontSize: height * 0.015,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: height * 0.25),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.primaryColor.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 100,
                            offset: Offset(-5, 5),
                          ),
                        ],
                      ),
                      height: height * 0.725,
                      width: width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: favoriteProducts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = favoriteProducts[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetails(product: product),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: ColorConstant.secondaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorConstant.primaryColor
                                                .withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 200,
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Padding(
                                              padding:
                                              EdgeInsets.all(width * 0.04),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                        "asset/images/Product_1.jpg"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            product["name"] ?? 'Unknown Product',
                                            style: TextStyle(
                                              color: ColorConstant.primaryColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: height * 0.025,
                                            ),
                                          ),
                                          Text(
                                            "₹${product["price"] ?? 'N/A'}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: height * 0.01,
                                    right: width * 0.05,
                                    child: IconButton(
                                      onPressed: () => _toggleLike(index),
                                      icon: Icon(
                                        product['isLiked'] == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: product['isLiked'] == true
                                            ? Colors.red
                                            : ColorConstant.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
