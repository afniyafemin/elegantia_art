import 'package:cloud_firestore/cloud_firestore.dart';

/// Fetches a list of addresses for a given user ID from Firestore.
///
/// Returns a list of addresses as a list of maps. Each map contains
/// the address details. If an error occurs, an empty list is returned.
Future<List<Map<String, dynamic>>> fetchAddresses(String userId) async {
  // Check if userId is valid
  if (userId.isEmpty) {
    print('User  ID is empty.');
    return [];
  }

  try {
    // Fetch the addresses from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('address')
        .get();

    // Convert each document to a Map<String, dynamic>
    List<Map<String, dynamic>> addresses = snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    // Optionally, you can log the number of addresses fetched
    print('Fetched ${addresses.length} addresses for user ID: $userId');

    return addresses;
  } catch (e) {
    // Log the error for debugging
    print('Error fetching addresses for user ID $userId: $e');
    return [];
  }
}