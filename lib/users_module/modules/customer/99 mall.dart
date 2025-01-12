import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:flutter/material.dart';
import '../../../constants/color_constants/color_constant.dart';
import '../../../main.dart';

class MallMall extends StatefulWidget {
  const MallMall({super.key});

  @override
  State<MallMall> createState() => _MallMallState();
}

class _MallMallState extends State<MallMall> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    try {
      final productCollection = FirebaseFirestore.instance.collection('products');
      final snapshot = await productCollection.where('price', isLessThanOrEqualTo: 99).get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          products = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
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
                        "99 mall",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ColorConstant.secondaryColor.withOpacity(0.5),
                          fontSize: height * 0.04,
                        ),
                      ),
                      Text("Buy products with Rs.99 and below Rs.99",
                        style: TextStyle(
                          color: ColorConstant.secondaryColor.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                          fontSize: width*0.03,
                        ),
                      )
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
                          ),
                        ],
                      ),
                      height: height * 0.725,
                      width: width * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : products.isNotEmpty
                            ? GridView.builder(

                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails(product: products[index])));
                                },
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
                                      ),
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
                                                image : AssetImage("asset/images/Product_1.jpg"),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        products[index]["name"] ?? '',
                                        style: TextStyle(
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: height * 0.025,
                                        ),
                                      ),
                                      Text(
                                        'Rs. ${products[index]["price"] ?? '0.00'}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Text(
                            'No products found under 99 rupees.',
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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