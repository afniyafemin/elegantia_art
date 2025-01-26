import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:flutter/material.dart';

class JobCatelogs extends StatelessWidget {
  final String category;

  const JobCatelogs({Key? key, required this.category}) : super(key: key);

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
        stream: firestore.collection('collaborations').snapshots(),
        builder: (context, collaborationsSnapshot) {
          if (collaborationsSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primaryColor,
              ),
            );
          }

          if (collaborationsSnapshot.hasError) {
            return Center(
              child: Text(
                "Error loading jobs. Please try again.",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
            );
          }

          if (!collaborationsSnapshot.hasData || collaborationsSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No collaborations found.",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
            );
          }

          final collaborations = collaborationsSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('orders').snapshots(),
            builder: (context, ordersSnapshot) {
              if (ordersSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.primaryColor,
                  ),
                );
              }

              if (ordersSnapshot.hasError) {
                return Center(
                  child: Text(
                    "Error loading orders. Please try again.",
                    style: TextStyle(color: ColorConstant.primaryColor),
                  ),
                );
              }

              if (!ordersSnapshot.hasData || ordersSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "No orders found.",
                    style: TextStyle(color: ColorConstant.primaryColor),
                  ),
                );
              }

              final orders = ordersSnapshot.data!.docs;
              final filteredJobs = collaborations.where((collab) {
                final jobId = collab['jobId'];
                return orders.any((order) {
                  final orderId = order.id;
                  final orderCategory = order['category'];
                  return orderId == jobId && orderCategory == category;
                });
              }).toList();

              if (filteredJobs.isEmpty) {
                return Center(
                  child: Text(
                    "No jobs found in this category.",
                    style: TextStyle(color: ColorConstant.primaryColor),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index].data() as Map<String, dynamic>;
                  final orderId = job['jobId'];
                  final order = orders.firstWhere((order) => order.id == orderId);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: ColorConstant.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['title'] ?? 'No Title',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            order['description'] ?? 'No Description',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorConstant.secondaryColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Pay: ${order['pay'] ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Posted by: ${order['postedBy'] ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstant.secondaryColor.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Applied for ${order['title'] ?? 'this job'}!",
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
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
