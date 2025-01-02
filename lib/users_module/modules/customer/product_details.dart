import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/users_module/modules/customer/buy_now_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import '../../../constants/image_constants/image_constant.dart';
import '../../../main.dart';
import '../../../services/favorites_method.dart';
import '../../../services/cart_service.dart';
import '../customer/cart_c.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  String? customizationText;
  String? customizationImageURL; // Store the URL of the uploaded image
  bool isLiked = false; // Track the like state
  final AddToFav _addToFav = AddToFav(); // Create an instance of LikeService
  final CartService _cartService =
      CartService(); // Create an instance of CartService
  double _productRating = 0.0;
  double _avgRating = 0.0;
  final TextEditingController _feedbackController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _getProductRating();
    _getUserRating();
  }

  Future<void> _checkIfLiked() async {
    isLiked = await _addToFav.checkIfLiked(widget.product['id']);
    setState(() {});
  }

  Future<void> _toggleLike() async {
    await _addToFav.toggleLike(widget.product['id'], widget.product);
    setState(() {
      isLiked = !isLiked; // Toggle the like state
    });
  }

  Future<void> _getProductRating() async {
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product['id'])
          .get();

      // Calculate average rating
      List<dynamic> ratings = productDoc.get('ratings') ?? [];
      if (ratings.isNotEmpty) {
        double totalRating = 0;
        for (var rating in ratings) {
          totalRating += rating['rating'];
        }
        setState(() {
          _avgRating = totalRating / ratings.length;
        });
      }
    } catch (e) {
      print('Error fetching product rating: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }

  Future<void> _getUserRating() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product['id'])
          .get();

      List<dynamic> ratings = productDoc.get('ratings') ?? [];
      for (var rating in ratings) {
        if (rating['userId'] == currentUser.uid) {
          setState(() {
            _productRating = rating['rating'];
          });
          break; // Exit the loop after finding the user's rating
        }
      }
    }
  }

  Future<void> _submitRating() async {
    // Ensure user is logged in and rating is valid
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _productRating <= 0) {
      return; // Handle invalid scenario (e.g., show a message)
    }

    try {
      final productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product['id']);

      // Perform a transaction to ensure data consistency
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final documentSnapshot = await transaction.get(productRef);
        final existingRatings =
            List<dynamic>.from(documentSnapshot.data()?['ratings'] ?? []);

        // Find the index of the current user's rating
        int index = existingRatings
            .indexWhere((rating) => rating['userId'] == currentUser.uid);

        if (index != -1) {
          // Update the existing rating
          existingRatings[index]['rating'] = _productRating;
          existingRatings[index]['feedback'] = _feedbackController.text;
        } else {
          // Add a new rating if it doesn't exist
          existingRatings.add({
            'userId': currentUser.uid,
            'rating': _productRating,
            'feedback': _feedbackController.text,
          });
        }

        // Update the product document with the updated ratings
        transaction.update(productRef, {'ratings': existingRatings});
      });

      // Recalculate average rating (optional, for immediate display)
      _getProductRating();

      setState(() {});
    } catch (e) {
      print('Error submitting rating: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: Stack(
        children: [
          Container(
            height: height * 0.5,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.product2),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: width * 0.05,
                backgroundColor: ColorConstant.secondaryColor,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 1.0,
            minChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width * 0.05),
                    topRight: Radius.circular(width * 0.05),
                  ),
                  color: ColorConstant.secondaryColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.07),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product['name'],
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: height * 0.003),
                                Text(widget.product['category']),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                RatingStars(
                                  starSize: 15,
                                  starColor: Color(0xFFF2C94C),
                                  valueLabelVisibility: false,
                                  value: _avgRating,
                                  starOffColor: ColorConstant.primaryColor,
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Text(
                                  "₹${widget.product['price']}",
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: _toggleLike,
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked
                                    ? Colors.red
                                    : ColorConstant.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "${widget.product['description']}",
                          style: TextStyle(
                              color:
                                  ColorConstant.primaryColor.withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: ColorConstant.primaryColor
                          ,
                        ),
                        Text("Note :"),
                        Text(
                          "You can customize your products during the 'Proceeding the Order' section or at the final stage of the ordering process. Make sure to review and confirm all customizations before completing your order to ensure it meets your preferences!",
                          style: TextStyle(
                              color:
                                  ColorConstant.primaryColor.withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height*0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Use CartService to add to cart
                                try {
                                  await _cartService.addToCart(
                                    widget.product['id'],
                                    {
                                      'name': widget.product['name'],
                                      'price': widget.product['price'],
                                      'category': widget.product['category'],
                                      'customizationText': customizationText,
                                      'customizationImage':
                                          customizationImageURL,
                                      'isLiked': isLiked,
                                    },
                                    quantity,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Added to cart successfully!'),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error adding to cart: $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.primaryColor,
                              ),
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BuyNowPage(
                                        product: {},
                                      ),
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.primaryColor,
                              ),
                              child: Text(
                                "buy Now",
                                style: TextStyle(
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height*0.02,),
                        Divider(
                          color: ColorConstant.primaryColor
                          ,
                        ),
                        Text("Ratings and Reviews",style: TextStyle(
                          fontSize: width*0.06,
                          fontWeight: FontWeight.w800,

                        ),),
                          Text("We value your feedback! Please take a moment to rate the product and share your experience. Your rating helps us improve and assists other customers in making informed decisions. Thank you for your support!",
                          style: TextStyle(
                              color:
                              ColorConstant.primaryColor.withOpacity(0.5),
                              fontWeight: FontWeight.bold
                          ),),
                          Row(
                            children: [
                              SizedBox(height: height * 0.1),
                              RatingBar.builder(
                                initialRating: _avgRating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 25,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Color(0xFFF2C94C),
                                  shadows: [
                                    Shadow(
                                      color: ColorConstant.primaryColor.withOpacity(0.5),
                                      blurRadius: 1,
                                      offset: Offset(0, 1)
                                    )
                                  ],
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _productRating = rating;
                                  });
                                },
                              ),
                              SizedBox(width: width*0.03,),
                              GestureDetector(
                                onTap: _submitRating, // Call _submitRating here
                                child: Container(
                                  height: height * 0.03,
                                  width: width * 0.1,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primaryColor,
                                    borderRadius: BorderRadius.circular(15)
                                      ),
                                  child: Center(child: Text("Set",
                                  style: TextStyle(
                                    color: ColorConstant.secondaryColor,
                                  ),)),
                                ),
                              ),
                              // SizedBox(height: height * 0.02),
                              // TextField(
                              //   cursorColor: ColorConstant.primaryColor,
                              //   decoration: InputDecoration(
                              //     filled: true,
                              //     fillColor: ColorConstant.primaryColor.withOpacity(0.1),
                              //     labelText: 'Add Customization Text',
                              //     labelStyle: TextStyle(color: ColorConstant.primaryColor),
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(width * 0.2),
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(width * 0.2),
                              //       borderSide: BorderSide(color: ColorConstant.primaryColor),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(width * 0.2),
                              //       borderSide: BorderSide(color: ColorConstant.primaryColor),
                              //     ),
                              //   ),
                              //   style: TextStyle(color: ColorConstant.primaryColor),
                              // ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
