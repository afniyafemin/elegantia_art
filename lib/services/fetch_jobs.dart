import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Fetch order details based on jobId
Future<Map<String, dynamic>> fetchOrderDetails(String jobId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic> orderDetails = {};

  try {
    // Fetch the order document based on the jobId
    final orderDoc = await firestore.collection('orders').where('orderId', isEqualTo: jobId).get();

    if (orderDoc.docs.isNotEmpty) {
      orderDetails = orderDoc.docs.first.data() as Map<String, dynamic>;
    }
  } catch (e) {
    print('Error fetching order details: $e');
  }

  return orderDetails;
}

// Fetch requested jobs for the current user
Future<List<Map<String, dynamic>>> fetchRequestedJobs() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser !.uid;
  List<Map<String, dynamic>> jobDetails = [];

  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('jobs')
        .where('status', isEqualTo: 'requested')
        .get();

    for (var doc in querySnapshot.docs) {
      String jobId = doc.id;
      // Fetch collaboration data for each jobId
      List<Map<String, dynamic>> collaborations = await fetchCollaborationData(jobId);
      jobDetails.addAll(collaborations);
    }
  } catch (e) {
    print('Error fetching requested jobs: $e');
  }
  return jobDetails;
}

// Fetch collaboration data based on jobId
Future<List<Map<String, dynamic>>> fetchCollaborationData(String jobId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final collaborationDocs = await firestore.collection('collaborations').where('jobId', isEqualTo: jobId).get();

  List<Map<String, dynamic>> collaborations = [];

  for (var doc in collaborationDocs.docs) {
    final orderDoc = await firestore.collection('orders').where('orderId', isEqualTo: jobId).get();

    if (orderDoc.docs.isNotEmpty) {
      collaborations.add({
        'collaboration': doc.data(),
        'order': orderDoc.docs.first.data(), // Get the first matching order
      });
    } else {
      collaborations.add({
        'collaboration': doc.data(),
        'order': {}, // Empty order data when no matching order is found
      });
    }
  }

  return collaborations;
}

Future<List<Map<String, dynamic>>> fetchTopJobs() async {
  // Fetch all jobs and sort by amount in descending order, then take the top 5
  final querySnapshot = await FirebaseFirestore.instance
      .collection('collaborations')
      .orderBy('amount', descending: true)
      .limit(5)
      .get();

  List<Map<String, dynamic>> topJobs = [];

  for (var doc in querySnapshot.docs) {
    final jobId = doc.get('jobId'); // Get jobId from the collaboration document

    // Fetch the corresponding order document based on the jobId
    final orderDoc = await FirebaseFirestore.instance.collection('orders').where('orderId', isEqualTo: jobId).get();

    if (orderDoc.docs.isNotEmpty) {
      // If an order exists for the jobId, add the collaboration and order data
      topJobs.add({
        'collaboration': doc.data(),
        'order': orderDoc.docs.first.data(), // Get the first matching order
      });
    } else {
      // Handle case when no order data is found, add empty order data
      topJobs.add({
        'collaboration': doc.data(),
        'order': {}, // Empty order data when no matching order is found
      });
    }
  }

  return topJobs;
}