import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:flutter/material.dart';

class CatelogsNewUi extends StatefulWidget {
  final String selectedCategory;
  final String description;

  const CatelogsNewUi({super.key, required this.selectedCategory, required this.description});

  @override
  State<CatelogsNewUi> createState() => _CatelogsNewUiState();
}

class _CatelogsNewUiState extends State<CatelogsNewUi> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts(widget.selectedCategory);
  }

  Future<void> _fetchProducts(String category) async {
    try {
      setState(() {
        isLoading = true;
      });
      final productsRef = _firestore.collection('products');
      Query<Map<String, dynamic>> query = productsRef;
      if (category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      final querySnapshot = await query.get();
      setState(() {
        products = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (error) {
      print("Error fetching products: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
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
                      Text(
                        widget.selectedCategory,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: height * 0.04,
                          color: ColorConstant.secondaryColor.withOpacity(0.5)
                        ),
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: height * 0.015,
                          color: ColorConstant.secondaryColor.withOpacity(0.85)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.065, right: width * 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isGridView = !isGridView;
                                });
                              },
                              child: Icon(
                                isGridView ? Icons.list : Icons.grid_view_sharp,
                                color: ColorConstant.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top: height*0.25),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ColorConstant.primaryColor.withOpacity(0.25),
                              spreadRadius: 3,
                              blurRadius: 200,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        height: height * 0.725,
                        width: width * 0.9,
                        child: Column(
                          children: [
                            Expanded(
                              child: isGridView
                                  ? GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Adjust as needed
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: width*0.03
                                ),
                                itemCount: products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final product = products[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails(product: product),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(width * 0.005),
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
                                                    image: AssetImage(ImageConstant.product2),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            product['name'],
                                            style: TextStyle(
                                              color: ColorConstant.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: height * 0.015,
                                            ),
                                          ),
                                          Text(
                                            "₹${product['price']}", // Assuming price is stored in INR
                                            style: TextStyle(color: ColorConstant.primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                                  : ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return Container(
                                    margin: EdgeInsets.all(width*0.015),
                                    height: height*0.1,
                                    decoration: BoxDecoration(
                                      color: ColorConstant.secondaryColor,
                                      borderRadius: BorderRadius.circular(width*0.05),
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        leading: Container(
                                          height: height*0.075,
                                          width: width*0.125,
                                          decoration: BoxDecoration(
                                            color: ColorConstant.primaryColor,
                                            borderRadius: BorderRadius.circular(width*0.025),
                                            image: DecorationImage(image: AssetImage(ImageConstant.product2),fit: BoxFit.fill,)
                                          ),
                                        ),
                                        title: Text(product['name']),
                                        subtitle: Text("₹${product['price']}"),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductDetails(product: product),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}