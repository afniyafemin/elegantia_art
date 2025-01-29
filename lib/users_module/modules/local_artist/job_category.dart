import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_catelogs.dart';
import 'package:flutter/material.dart';

class JobCategoryPage extends StatefulWidget {
  const JobCategoryPage({super.key});

  @override
  State<JobCategoryPage> createState() => _JobCategoryPageState();
}

class _JobCategoryPageState extends State<JobCategoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> categories = []; // Initialize an empty list for categories

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories when the widget is initialized
  }

  Future<void> _fetchCategories() async {
    try {
      final categoriesRef = _firestore.collection('categories');
      final querySnapshot = await categoriesRef.get();
      setState(() {
        categories = querySnapshot.docs.map((doc) {
          return {
            'name': doc['name'] as String, // Assuming each document has a 'name' field
            'imageUrl': doc['imageUrl'] as String // Assuming each document has an 'imageUrl' field
          };
        }).toList();
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
        backgroundColor: ColorConstant.secondaryColor,
        centerTitle: true,
        title: Text(
          "Job Categories",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConstant.primaryColor),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemBuilder: (BuildContext context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobCatalogs(category: categories[index]['name']),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.03),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          image: DecorationImage(
                            image: NetworkImage(categories[index]['imageUrl'] ?? ImageConstant.aesthetic_userprofile), // Use a default image if null
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            categories[index]['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: width * 0.03,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: width * 0.005,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}