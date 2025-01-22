import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/color_constants/color_constant.dart';

class AddressFetcher extends StatelessWidget {
  final String userId;

  const AddressFetcher({Key? key, required this.userId}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchAddresses(String userId) async {
    if (userId.isEmpty) {
      print('User  ID is empty.');
      return [];
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('address')
          .get();

      List<Map<String, dynamic>> addresses = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      print('Fetched ${addresses.length} addresses for user ID: $userId');
      return addresses;
    } catch (e) {
      print('Error fetching addresses for user ID $userId: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchAddresses(userId),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<Map<String, dynamic>> addrs = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Deliver to: ",
                    style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text("${addrs[0]['name'] ?? 'Unknown'}",
                    style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Address:",
                  style: TextStyle(
                      color: ColorConstant.primaryColor,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationColor: ColorConstant.primaryColor
                  ),
                ),
              ),
              Text("${addrs[0]['post'] ?? ''}",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
              Text("${addrs[0]['pin'] ?? ''}",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
              Text("${addrs[0]['landmark'] ?? ''}",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
              Text("${addrs[0]['phone'] ?? ''}",
                style: TextStyle(color: ColorConstant.primaryColor),
              ),
            ],
          );
        } else {
          return Text('No addresses found.');
        }
      },
    );
  }
}