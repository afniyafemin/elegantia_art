import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/users_module/modules/customer/buy_now_page.dart';
import 'package:flutter/material.dart';
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
  final CartService _cartService = CartService(); // Create an instance of CartService

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
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
                radius: width*0.05,
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
                    topLeft: Radius.circular(width*0.05),
                    topRight: Radius.circular(width*0.05),
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
                              children: [
                                Text(
                                  widget.product['name'],
                                  style: TextStyle(
                                    fontSize: width*0.05,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: height*0.015),
                                Text(
                                  "₹${widget .product['price']}",
                                  style: TextStyle(
                                    fontSize: width*0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: _toggleLike,
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height*0.03),




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
                                      'customizationText': customizationText,
                                      'customizationImage': customizationImageURL,
                                      'isLiked': isLiked,
                                    },
                                    quantity,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added to cart successfully!'),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error adding to cart: $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.primaryColor,
                              ),
                              child: Text("Add to Cart",
                                style: TextStyle(
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BuyNowPage(product: {},),));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.primaryColor,
                              ),
                              child: Text("buy Now",
                                style: TextStyle(
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
                            ),
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