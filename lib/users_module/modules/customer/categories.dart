import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/catelogs_new_ui.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categoriesRef = _firestore.collection('categories');
      final querySnapshot = await categoriesRef.get();
      setState(() {
        categories = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (error) {
      print("Error fetching categories: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load categories. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.primaryColor,
        title: Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.secondaryColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Implement search functionality (optional)
            },
            icon: Icon(
              Icons.search_sharp,
              size: width * 0.07,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CatelogsNewUi(selectedCategory: categories[index]['name']),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: height * 0.2,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            color: ColorConstant.primaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.45,
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(width * 0.03),
                                    bottomLeft: Radius.circular(width * 0.03),
                                  ),
                                  // Replace with actual image URL from Firestore
                                  image: DecorationImage(
                                    image: AssetImage(ImageConstant.product1),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                categories[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.03,
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: categories.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}