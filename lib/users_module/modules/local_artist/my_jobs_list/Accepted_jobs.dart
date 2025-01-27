import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../constants/color_constants/color_constant.dart';
import '../../../../services/fetch_jobs.dart';

class AcceptedJobs extends StatefulWidget {
  const AcceptedJobs({Key? key}) : super(key: key);

  @override
  State<AcceptedJobs> createState() => _AcceptedJobsState();
}

class _AcceptedJobsState extends State<AcceptedJobs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser !.uid;
  late Future<List<Map<String, dynamic>>> _acceptedJobs;

  @override
  void initState() {
    super.initState();
    _acceptedJobs = _fetchAcceptedJobs();
  }

  Future<List<Map<String, dynamic>>> _fetchAcceptedJobs() async {
    List<Map<String, dynamic>> jobs = [];
    try {
      // Fetch the jobs subcollection for the current user
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('jobs')
          .where('status', isEqualTo: 'accepted')
          .get();

      // Extract job details from the fetched documents
      for (var doc in querySnapshot.docs) {
        jobs.add({
          'id': doc.id, // Document ID
          'name': doc['orderId'], // Assuming you have a field named jobName
          'deadline': doc['date'], // Assuming you have a field named deadline
        });
      }
    } catch (e) {
      print('Error fetching accepted jobs: $e');
    }
    return jobs;
  }

  void _showJobDetailsDialog(String jobId) async {
    // Fetch collaboration data for the selected jobId
    List<Map<String, dynamic>> collaborations = await fetchCollaborationData(jobId);

    // Create a dialog to display job details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Job Details"),
          content: SingleChildScrollView(
            child: ListBody(
              children: collaborations.map((collab) {
                final order = collab['order'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Collaboration ID: ${collab['collaboration']['jobId'] ?? 'N/A'}"),
                    Text("Product Name: ${order['productName'] ?? 'N/A'}"),
                    Text("Amount: ${collab['collaboration']['amount'] ?? 'N/A'}"),
                    Text("Customization Text: ${order['customizationText'] ?? 'N/A'}"),
                    Text("Customization Image: ${order['customizationImage'] ?? 'N/A'}"),
                    Text("Order Date: ${order['orderDate'] ?? 'N/A'}"),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _acceptedJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No accepted jobs found.'));
          }

          final jobs = snapshot.data!;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Show job details in a dialog when the job is tapped
                    _showJobDetailsDialog(jobs[index]['id']);
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
                        title: Text("Job Name: ${jobs[index]['name']}"),
                        subtitle: Text("Deadline: ${jobs[index]['deadline']}"),
                        trailing: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              "Finished",
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
}