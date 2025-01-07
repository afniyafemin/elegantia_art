import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_catelogs.dart';
import 'package:flutter/material.dart';

String j = "";

class JobCategoryPage extends StatefulWidget {
  const JobCategoryPage({super.key});

  @override
  State<JobCategoryPage> createState() => _JobCategoryPageState();
}

class _JobCategoryPageState extends State<JobCategoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> categories = []; // Initialize an empty list for categories

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
        categories = querySnapshot.docs.map((doc) => doc['name'] as String).toList(); // Assuming each document has a 'name' field
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
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        backgroundColor: ColorConstant.secondaryColor,
        title: Text(
          "Job Categories",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConstant.primaryColor),
        ),
        // centerTitle: true,
        actions: [
          Icon(
            Icons.search_sharp,
            size: width * 0.06,
            color: ColorConstant.primaryColor,
          ),
          SizedBox(
            width: width*0.05,
          )
        ],
        iconTheme: IconThemeData(
          color: ColorConstant.primaryColor
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
                      j = categories[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobCatelogs(category: categories[index],),
                        ),
                      );
                      setState(() {});
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(width*0.03),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: ColorConstant.primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(width * 0.03),
                          image: DecorationImage(
                            image: AssetImage(ImageConstant.product2),
                            fit: BoxFit.cover,
                            opacity: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: width*0.35,
                            height: height*0.04,
                            decoration: BoxDecoration(
                              color: ColorConstant.primaryColor,
                              borderRadius: BorderRadius.circular(width*0.05)
                            ),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.03,
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
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
                  crossAxisSpacing: width*0.005
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}