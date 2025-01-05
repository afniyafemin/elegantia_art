import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class JobCatelogs extends StatefulWidget {
  final String category; // Add a category parameter

  const JobCatelogs({super.key, required this.category});

  @override
  State<JobCatelogs> createState() => _JobCatelogsState();
}

class _JobCatelogsState extends State<JobCatelogs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> jobs = []; // List to hold job data

  @override
  void initState() {
    super.initState();
    _fetchJobs(); // Fetch jobs when the widget is initialized
  }

  Future<void> _fetchJobs() async {
    try {
      final collaborationsRef = _firestore.collection('collaborations');
      final querySnapshot = await collaborationsRef.where('jobId', isEqualTo: widget.category).get();

      // Fetch the corresponding orders based on jobId
      for (var doc in querySnapshot.docs) {
        final jobId = doc.get('jobId'); // Get jobId from collaborations
        final orderDoc = await _firestore.collection('orders').where('orderId', isEqualTo: jobId).get();

        if (orderDoc.docs.isNotEmpty) {
          jobs.add({
            'collaborations': doc.data(),
            'order': orderDoc.docs.first.data(), // Get the first matching order
          });
        }
      }

      setState(() {
        // Update the jobs list with collaboration and order data
      });
    } catch (error) {
      print("Error fetching jobs: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load jobs. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
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
                      widget.category, // Display the selected category
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: height * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
              // Center widget for job listings
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.25),
                  child: Container(
                    height: height * 0.725,
                    width: width * 0.9,
                    child: ListView.separated(
                      itemCount: jobs.length,
                      separatorBuilder: (context, index) => SizedBox(height: height * 0.03),
                      itemBuilder: (context, index) {
                        final collaborationData = jobs[index]['collaborations'];
                        final orderData = jobs[index]['order'];

                        return Container(
                          height: height * 0.15,
                          width: width * 0.75,
                          decoration: BoxDecoration(
                            color: ColorConstant.secondaryColor,
                            borderRadius: BorderRadius.circular(width * 0.05),
                            boxShadow: [
                              BoxShadow(
                                color: ColorConstant.primaryColor.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 200,
                                offset: Offset(5, 5),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.02, left: width * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderData["productName"] ?? "Job Name", // Assuming 'productName' is a field in the document
                                      style: TextStyle(
                                        color: ColorConstant.primaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: height * 0.025,
                                      ),
                                    ),
                                    Text('Price: \$${collaborationData["amount"]?.toStringAsFixed(2) ?? "N/A"}'), // Display amount from collaborations
                                  ],
                                ),
                              ),
                              Container(
                                height: height * 0.15,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(width * 0.05),
                                    topRight: Radius.circular(width * 0.05),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage("asset/images/Product_1.jpg"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}