import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
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
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No results found',
              style: TextStyle(
                color: ColorConstant.primaryColor,
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        var products = snapshot.data!.docs;

        return Container(
          color: ColorConstant.secondaryColor, // Background color
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              String productName =
                  product['name']; // Assuming 'name' is the field

              return Card(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                elevation: 4, // Slight shadow for the tile
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.grey.withOpacity(0.5),
                child: ListTile(
                  tileColor:
                      ColorConstant.secondaryColor, // Tile background color
                  leading:
                      Icon(Icons.search, color: ColorConstant.primaryColor),
                  title: Text(
                    productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.primaryColor, // Text color
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: ColorConstant.primaryColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetails(
                                product: products[index].data()
                                    as Map<String, dynamic>)));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Type to search...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.height * 0.018,
              ),
            ),
          );
        }

        var products = snapshot.data!.docs;

        return Container(
          color: ColorConstant.secondaryColor, // Background color
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              String productName =
                  product['name']; // Assuming 'name' is the field

              return Card(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                elevation: 3, // Slight shadow for the tile
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: ColorConstant.primaryColor.withOpacity(0.7),
                child: ListTile(
                  tileColor:
                      ColorConstant.secondaryColor, // Tile background color
                  leading:
                      Icon(Icons.search, color: ColorConstant.primaryColor),
                  title: Text(
                    productName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.primaryColor, // Text color
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  onTap: () {
                    query = productName;
                    showResults(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
