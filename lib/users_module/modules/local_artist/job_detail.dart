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

  const JobInfo({
    Key? key,
    required this.productName,
    required this.category,
    required this.amount,
    required this.customizationText,
    required this.customizationImage,
    required this.date,
    required this.jobId, // Include jobId
  }) : super(key: key);

  @override
  _JobInfoState createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  bool isRequested = false; // Track if the job has been requested

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void requestJob() async {
    String userId = FirebaseAuth.instance.currentUser !.uid; // Get the current user ID

    // Add the request to Firestore
    try {
      await _firestore.collection('users').doc(userId).collection('jobs').doc(widget.jobId).set({
        'status': 'requested',
        'productName': widget.productName,
        'category': widget.category,
        'amount': widget.amount,
        'customizationText': widget.customizationText,
        'customizationImage': widget.customizationImage,
        'date': widget.date,
        'orderId': widget.jobId

      });
      setState(() {
        isRequested = true; // Change the state to requested
      });
      print("Job requested");
    } catch (e) {
      print("Error requesting job: $e");
    }
  }

  void cancelRequest() async {
    String userId = FirebaseAuth.instance.currentUser !.uid; // Get the current user ID

    // Remove the request from Firestore
    try {
      await _firestore.collection('users').doc(userId).collection('jobs').doc(widget.jobId).delete();
      setState(() {
        isRequested = false; // Change the state back to not requested
      });
      print("Job request canceled");
    } catch (e) {
      print("Error canceling job request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: Container(
        width: 200, // Set the desired width
        child: FloatingActionButton(
          backgroundColor: ColorConstant.primaryColor,
          onPressed: () {
            if (!isRequested) {
              requestJob(); // Request the job
            } else {
              cancelRequest(); // Cancel the job request
            }
          },
          child: Text(
            isRequested ? "Cancel Request" : "Request",
            style: TextStyle(fontSize: 16, color: ColorConstant.secondaryColor), // Optional: Increase font size
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}