import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../constants/color_constants/color_constant.dart';
import '../../../../services/fetch_jobs.dart';

class RequestedJobs extends StatefulWidget {
  const RequestedJobs({Key? key}) : super(key: key);

  @override
  State<RequestedJobs> createState() => _RequestedJobsState();
}

class _RequestedJobsState extends State<RequestedJobs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser !.uid;
  late Future<List<Map<String, dynamic>>> _requestedJobs;

  @override
  void initState() {
    super.initState();
    _requestedJobs = fetchRequestedJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _requestedJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requested jobs found.'));
          }

          final jobDetails = snapshot.data!;

          return ListView.builder(
            itemCount: jobDetails.length,
            itemBuilder: (context, index) {
              final collaboration = jobDetails[index]['collaboration'];
              final order = jobDetails[index]['order'];

              return Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to JobInfo page with the required details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobInfo(
                          productName: order['productName'] ?? 'N/A',
                          category: order['category'] ?? 'N/A',
                          amount: collaboration['amount'] ?? 0.0,
                          customizationText: order['customizationText'] ?? 'N/A',
                          customizationImage: order['customizationImage'] ?? '',
                          date: order['orderDate'] ?? 'N/A',
                          jobId: collaboration['jobId'] ?? '', // Pass the jobId
                          address: order['address'] ?? {}, // Pass the address
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: ColorConstant.secondaryColor,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstant.primaryColor.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text("Job ID: ${collaboration['jobId'] ?? 'N/A'}"),
                        trailing: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              _showCancelRequestAlert(context, collaboration['jobId']);
                            },
                            child: Center(
                              child: Text(
                                "Requested",
                                style: TextStyle(
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCancelRequestAlert(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorConstant.secondaryColor,
          title: const Text('Cancel Request?'),
          content: const Text('Are you sure you want to cancel this request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Delete the document with the jobId from the jobs subcollection
                  await _firestore
                      .collection('users')
                      .doc(currentUserId)
                      .collection('jobs')
                      .doc(jobId)
                      .delete();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request cancelled successfully!'),
                      backgroundColor: ColorConstant.primaryColor,
                    ),
                  );

                  // Refresh the list by re-fetching requested jobs
                  setState(() {
                    _requestedJobs = fetchRequestedJobs();
                  });
                } catch (e) {
                  // Handle error
                  print('Error canceling request: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to cancel the request.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

}