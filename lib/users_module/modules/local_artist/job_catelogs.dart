import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_detail.dart';
import 'package:flutter/material.dart';

import 'package:elegantia_art/constants/color_constants/color_constant.dart';

import '../../../services/fetch_jobs.dart';

class JobCatalogs extends StatelessWidget {
  final String? category;

  const JobCatalogs({Key? key, required this.category}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        centerTitle: true,
        title: Text(
          "$category Jobs",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstant.primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: ColorConstant.primaryColor,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('collaborations')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading jobs. Please try again.",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No jobs found in this category.",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
            );
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: ColorConstant.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['jobId'] ?? 'No Id',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Pay: ${job['amount'] ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              // Fetch the order details using the jobId
                              String jobId = job['jobId'];
                              Map<String, dynamic> orderDetails = await fetchOrderDetails(jobId);
                      
                              // Navigate to JobInfo page with the fetched details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobInfo(
                                    productName: orderDetails['productName'] ?? 'N/A',
                                    category: category,
                                    amount: job['amount'] ?? 0.0,
                                    customizationText: orderDetails['customizationText'] ?? 'N/A',
                                    customizationImages: orderDetails['customizationImages'] ?? '',
                                    date: orderDetails['orderDate'] ?? 'N/A',
                                    jobId: jobId,
                                    address: orderDetails['address'] ?? {}, // Pass the address
                                    imageUrl: orderDetails['imageUrl']?? 'N/A',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.secondaryColor,
                              foregroundColor: ColorConstant.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Apply Now"),
                          ),
                        ],
                      ),
                      Container(
                        height: height*0.15,
                        width: width*0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width*0.02),
                          image: DecorationImage(image: NetworkImage(job['imageUrl' ?? ImageConstant.aesthetic_userprofile]),fit: BoxFit.cover)
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
