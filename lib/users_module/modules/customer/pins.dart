import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/color_constants/color_constant.dart';
import '../../../services/favorites_method.dart'; // Import your service

class Pins extends StatefulWidget {
  const Pins({super.key});

  @override
  State<Pins> createState() => _PinsState();
}

class _PinsState extends State<Pins> {
  List<Map<String, dynamic>> favoriteProducts = []; // List to hold favorite products
  final AddToFav _addToFav = AddToFav(); // Create an instance of your service

  @override
  void initState() {
    super.initState();
    _fetchFavoriteProducts();
  }

  Future<void> _fetchFavoriteProducts() async {
    final user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      final likedItemsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final snapshot = await likedItemsCollection.get();
      setState(() {
        favoriteProducts = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: height * 0.35,
                width: width * 1,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(width * 0.35),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Pins",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: height * 0.04,
                        ),
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
                          color: ColorConstant.primaryColor.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 200,
                          offset: Offset(-5, 5),
                        )
                      ],
                    ),
                    height: height * 0.725,
                    width: width * 0.9,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 60), // Add padding to avoid overlap with bottom navigation bar
                      child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: favoriteProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorConstant.secondaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorConstant.primaryColor.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 200,
                                    offset: Offset(5, 5),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Padding(
                                        padding: EdgeInsets.all(width * 0.04),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage("asset/images/Product_1.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        )),
                                  ),
                                  Text(
                                    favoriteProducts[index]["name"] ?? 'Unknown Product',
                                    style: TextStyle(
                                      color: ColorConstant.primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: height * 0.025,
                                    ),
                                  ),
                                  Text("₹${favoriteProducts[index]["price"].toString() ?? 'Price not available'}",)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}