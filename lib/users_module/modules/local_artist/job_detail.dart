import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../main.dart';

class JobInfo extends StatefulWidget {
  final String productName;
  final String category;
  final double amount;
  final String customizationText;
  final String customizationImage;
  final String date; // Changed from Date to date to avoid conflict with Dart's Date class
  final String jobId; // Add jobId to the constructor
  final dynamic address; // Fix: Use dynamic to accept both Map and List

  const JobInfo({
    Key? key,
    required this.productName,
    required this.category,
    required this.amount,
    required this.customizationText,
    required this.customizationImage,
    required this.date,
    required this.jobId,
    required this.address, // Use dynamic for address
  }) : super(key: key);

  @override
  _JobInfoState createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  bool isRequested = false; // Track if the job has been requested
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkIfRequested(); // Check request status on page load
  }

  Future<void> _checkIfRequested() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot jobDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('jobs')
          .doc(widget.jobId)
          .get();

      if (jobDoc.exists && jobDoc['isRequested'] == true) {
        setState(() {
          isRequested = true;
        });
      }
    } catch (e) {
      print("Error checking request status: $e");
    }
  }

  void requestJob() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('jobs')
          .doc(widget.jobId)
          .set({
        'status': 'requested',
        'isRequested': true,
        'productName': widget.productName,
        'category': widget.category,
        'amount': widget.amount,
        'customizationText': widget.customizationText,
        'customizationImage': widget.customizationImage,
        'date': widget.date,
        'orderId': widget.jobId,
      });
      setState(() {
        isRequested = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Job requested successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error requesting job: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void cancelRequest() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('jobs')
          .doc(widget.jobId)
          .update({'isRequested': false, 'status': 'canceled'});
      setState(() {
        isRequested = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Job request canceled successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error canceling job request: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(ImageConstant.product2, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: ColorConstant.secondaryColor,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 1.0,
            minChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: ColorConstant.secondaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Job Name: ${widget.productName}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("Category : ${widget.category}"),
                          SizedBox(height: 8),
                          Text("Amount: \$${widget.amount.toStringAsFixed(2)}"),
                          SizedBox(height: 8),
                          Text("Customization Text: ${widget.customizationText}"),
                          SizedBox(height: 8),
                          Text("Ordered Date: ${widget.date}"),
                          SizedBox(height: 16),
                          // Displaying address details
                          Text("Address:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          widget.address != null
                              ? Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${widget.address['name'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                                Text("Landmark: ${widget.address['landmark'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                                Text("Phone: ${widget.address['phone'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                                Text("Pin: ${widget.address['pin'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                                Text("Post: ${widget.address['post'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                                Divider(),
                              ],
                            ),
                          )
                              : Text("No address available", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: InkWell(
          onTap: () {
            if (!isRequested) {
              requestJob();
            } else {
              cancelRequest();
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: isRequested ? Colors.red : ColorConstant.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                isRequested ? "Cancel Request" : "Request",
                style: TextStyle(
                  color: ColorConstant.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
