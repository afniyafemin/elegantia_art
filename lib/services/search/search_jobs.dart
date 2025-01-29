import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_detail.dart'; // Import your JobInfo page

class JobSearchDelegate extends SearchDelegate {
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCollaborationData(query), // Fetch collaboration data based on the query
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

        var jobs = snapshot.data!;

        return Container(
          color: ColorConstant.secondaryColor, // Background color
          child: ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              var order = job['order'];
              String jobId = job['collaboration']['jobId'] ?? 'N/A'; // Safely access jobId
              String productName = order['productName'] ?? 'N/A'; // Safely access productName

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
                  tileColor: ColorConstant.secondaryColor, // Tile background color
                  leading: Icon(Icons.work, color: ColorConstant.primaryColor),
                  title: Text(
                    productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.primaryColor, // Text color
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  subtitle: Text("Job ID: $jobId"),
                  trailing: Icon(Icons.arrow_forward_ios, color: ColorConstant.primaryColor),
                  onTap: () {
                    // Navigate to JobInfo page with the job details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobInfo(
                          jobId: jobId,
                          productName: productName,
                          category: order['category'] ?? 'N/A', // Safely access category
                          amount: job['collaboration']['amount'] ?? 0.0, // Safely access amount
                          customizationText: order['customizationText'] ?? 'N/A', // Safely access customizationText
                          customizationImages: order['customizationImages'] ?? '', // Safely access customizationImage
                          date: order['orderDate'] ?? 'N/A', // Safely access orderDate
                          address: order['address'] ?? [], // Safely access address
                          imageUrl: order['imageUrl']?? 'N/A',
                        ),
                      ),
                    );
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCollaborationData(query), // Fetch collaboration data based on the query
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

        var jobs = snapshot.data!;

        return Container(
          color: ColorConstant.secondaryColor, // Background color
          child: ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              var order = job['order'];
              String jobId = job['collaboration']['jobId'] ?? 'N/A'; // Safely access jobId
              String productName = order['productName'] ?? 'N/A'; // Safely access productName

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
                  tileColor: ColorConstant.secondaryColor, // Tile background color
                  leading: Icon(Icons.work, color: ColorConstant.primaryColor),
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

  // Fetch collaboration data based on jobId
  Future<List<Map<String, dynamic>>> fetchCollaborationData(String query) async {
    final collaborationDocs = await FirebaseFirestore.instance.collection('collaborations').get();

    List<Map<String, dynamic>> collaborations = [];

    for (var doc in collaborationDocs.docs) {
      final jobId = doc.get('jobId'); // Get jobId from the collaboration document
      final orderDoc = await FirebaseFirestore.instance.collection('orders').where('orderId', isEqualTo: jobId).get();

      if (orderDoc.docs.isNotEmpty) {
        collaborations.add({
          'collaboration': doc.data(),
          'order': orderDoc.docs.first.data(), // Get the first matching order
        });
      } else {
        // Handle case when no order data is found
        collaborations.add({
          'collaboration': doc.data(),
          'order': {}, // Empty order data when no matching order is found
        });
      }
    }

    return collaborations;
  }
}