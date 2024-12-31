import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:flutter/material.dart';

class CatelogsNewUi extends StatefulWidget {
  final String selectedCategory;

  const CatelogsNewUi({super.key, required this.selectedCategory});

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
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          widget.selectedCategory,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: height * 0.04,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: width * 0.1, left: width * 0.03, right: width * 0.07),
                        child: Container(
                          height: height * 0.03,
                          color: ColorConstant.primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: height * 0.45,
                                        width: width * 1,
                                        decoration: BoxDecoration(
                                          color: ColorConstant.secondaryColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(width * 0.05),
                                            topRight: Radius.circular(width * 0.05),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(height: height * 0.015),
                                            Container(
                                              height: height * 0.01,
                                              width: width * 0.25,
                                              decoration: BoxDecoration(
                                                color: ColorConstant.primaryColor,
                                                borderRadius: BorderRadius.circular(width * 0.1),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.015),
                                            Text(
                                              "Sort By",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.05,
                                              ),
                                            ),
                                            SizedBox(height: height * 0.015),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: 5, // Assuming you have 5 sorting options
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Card(
                                                    color: ColorConstant.primaryColor,
                                                    child: ListTile(
                                                      leading: Text(
                                                        ["Popular ", "Newest", "Price: Low to High", "Price: High to Low"][index],
                                                        style: TextStyle(color: ColorConstant.secondaryColor),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: width * 0.02),
                                  child: Row(
                                    children: [
                                      Icon(Icons.sort_outlined, color: ColorConstant.secondaryColor),
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        "Sort By",
                                        style: TextStyle(fontWeight: FontWeight.w600, color: ColorConstant.secondaryColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.35),
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
                child: Column(
                  children: [
                    Expanded(
                      child: isGridView
                          ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Adjust as needed
                          childAspectRatio: 0.7,
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
                                      fontWeight: FontWeight.w800,
                                      fontSize: height * 0.025,
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
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: ColorConstant.primaryColor,
                                width: 2,
                              )
                            ),
                            leading: Image(image: AssetImage(ImageConstant.product2)),
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
      ),
    );
  }
}