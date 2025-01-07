import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:flutter/material.dart';

class JobCatelogs extends StatefulWidget {
  final String category;

  const JobCatelogs({super.key, required this.category});

  @override
  State<JobCatelogs> createState() => _JobCatelogsState();
}

class _JobCatelogsState extends State<JobCatelogs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];
  bool isLoading = false;
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs(widget.category);
  }

  Future<List<Map<String, dynamic>>> _fetchJobs(String category) async {
    List<Map<String, dynamic>> jobs = [];

    try {
      // Fetch collaborations based on the category
      final collaborationsRef = _firestore.collection('collaborations');
      Query<Map<String, dynamic>> query = collaborationsRef;
      if (category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      final collaborationsSnapshot = await query.get();

      // Extract jobIds from collaborations
      List<String> jobIds = collaborationsSnapshot.docs
          .map((doc) => doc.data()['jobId'] as String)
          .toList();

      // Fetch jobs from orders collection using the jobIds
      if (jobIds.isNotEmpty) {
        final ordersRef = _firestore.collection('orders');
        final jobsSnapshot = await ordersRef.where(FieldPath.documentId, whereIn: jobIds).get();

        jobs = jobsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      }
    } catch (error) {
      print("Error fetching jobs: $error");
      // You can choose to throw an error or return an empty list
      // throw error; // Uncomment this line if you want to propagate the error
    }

    return jobs; // Return the list of jobs
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                            widget.category,
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
                                color: ColorConstant.primaryColor.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 200,
                                offset: Offset(-5, 5),
                              )
                            ],
                          ),
                          height: height * 0.725,
                          width: width * 0.9,
                          child: FutureBuilder(
                            future: _fetchJobs(widget.category),
                            builder: (context, snapshot) {

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Text("no jobs yet");
                              }

                              if (snapshot.hasError) {
                                return Text(snapshot.error as String);
                              }

                              final jobs_ = snapshot.data!;

                              return Column(
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
                                        final job_ = jobs_[index];
                                        return GestureDetector(
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
                                                  job_['name'],
                                                  style: TextStyle(
                                                    color: ColorConstant.primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: height * 0.015,
                                                  ),
                                                ),
                                                Text(
                                                  "₹${job_['price']}", // Assuming price is stored in INR
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
                                        final job_ = jobs_[index];
                                        return Container(
                                          margin: EdgeInsets.all(width*0.015),
                                          height: height*0.1,
                                          decoration: BoxDecoration(
                                            color: ColorConstant.secondaryColor,
                                            borderRadius: BorderRadius.circular(width*0.05),
                                          ),
                                          child: Center(
                                            child: ListTile(
                                              leading: Image(image: AssetImage(ImageConstant.product2),),
                                              title: Text(job_['name']),
                                              subtitle: Text("₹${job_['price']}"),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
    );
  }
}