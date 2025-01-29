import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/services/search/search_products.dart';
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
              showSearch(context: context, delegate: CustomCategorySearchDelegate(categories));
            },
            icon: Icon(
              Icons.search_sharp,
              size: width * 0.07,
              color: ColorConstant.secondaryColor,
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
                            builder: (context) => CatelogsNewUi(selectedCategory: categories[index]['name'] , description: categories[index]['description'],),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(width*0.03),
                        child: Container(
                          height: height * 0.175,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            color: ColorConstant.primaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(width * 0.03),
                                    bottomLeft: Radius.circular(width * 0.03),
                                  ),
                                  // Replace with actual image URL from Firestore
                                  image: DecorationImage(
                                    image: NetworkImage(categories[index]['imageUrl'] ?? ImageConstant.product2),
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

class CustomCategorySearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> categories;

  CustomCategorySearchDelegate(this.categories);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: ColorConstant.secondaryColor,
        iconTheme: IconThemeData(color: ColorConstant.primaryColor),
        titleTextStyle: TextStyle(
          color: ColorConstant.primaryColor,
          fontSize: MediaQuery.of(context).size.height * 0.025,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none, // Remove the underline
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: ColorConstant.primaryColor),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back, color: ColorConstant.primaryColor),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> matchQuery = categories
        .where((category) =>
        category['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildCategoryList(matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> matchQuery = categories
        .where((category) =>
        category['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildCategoryList(matchQuery);
  }

  // Helper method to build category list with custom UI
  Widget _buildCategoryList(List<Map<String, dynamic>> matchQuery) {
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CatelogsNewUi(
                  selectedCategory: result['name'],
                  description: "Description for ${result['name']}", // Modify as needed
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            child: Card(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.005,
              ),
              elevation: 4, // Slight shadow for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.grey.withOpacity(0.5),
              child: ListTile(
                tileColor: ColorConstant.secondaryColor, // Tile background color
                leading: Icon(Icons.search, color: ColorConstant.primaryColor),
                title: Text(
                  result['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.primaryColor, // Text color
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: ColorConstant.primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatelogsNewUi(
                        selectedCategory: result['name'],
                        description: "Description for ${result['name']}", // Modify as needed
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
