import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../constants/color_constants/color_constant.dart';

class RequestedJobs extends StatefulWidget {
  const RequestedJobs({Key? key}) : super(key: key);

  @override
  State<RequestedJobs> createState() => _RequestedJobsState();
}

class _RequestedJobsState extends State<RequestedJobs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser !.uid;
  late Future<List<String>> _requestedJobIds;

  @override
  void initState() {
    super.initState();
    _requestedJobIds = _fetchRequestedJobs();
  }

  Future<List<String>> _fetchRequestedJobs() async {
    List<String> jobIds = [];
    try {
      // Fetch the jobs subcollection for the current user
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('jobs')
          .where('status', isEqualTo: 'requested')
          .get();

      // Extract the orderId (or document ID) from the fetched documents
      for (var doc in querySnapshot.docs) {
        jobIds.add(doc.id); // or doc['orderId'] if you have a field named orderId
      }
    } catch (e) {
      print('Error fetching requested jobs: $e');
    }
    return jobIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: FutureBuilder<List<String>>(
        future: _requestedJobIds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requested jobs found.'));
          }

          final jobIds = snapshot.data!;

          return ListView.builder(
            itemCount: jobIds.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 8.0, left: 16.0, right: 16.0),
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
                      title: Text("Job ID: ${jobIds[index]}"),
                      trailing: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: ColorConstant.primaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showCancelRequestAlert(context, jobIds[index]);
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
                    _requestedJobIds = _fetchRequestedJobs();
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