import 'package:elegantia_art/auth/stream.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/services/fetch_address.dart';
import 'package:elegantia_art/users_module/login_signup/login.dart';
import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
import 'package:elegantia_art/users_module/modules/local_artist/la_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/sign_out_method.dart';
import '../users_module/modules/customer/change_address.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomDrawer({required this.scaffoldKey});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static bool _isSwitched = false;
  String currentUserName = 'user';
  String? email;
  String address = "Unknown";
  String phoneNumber = "Unknown";
  int points = 0; // Assuming points are stored in Firestore as an integer

  bool get isSwitched => _isSwitched;

  void toggleSwitch(bool value) {
    setState(() {
      _isSwitched = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _calculatePoints();
  }

  String userId = FirebaseAuth.instance.currentUser !.uid;

  // Fetch user details from Firestore
  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      try {
        // Fetch user document
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            currentUserName = userDoc['username'] ?? "User ";
            email = userDoc['email'] ?? "Unknown";
          });
        }

        // Fetch address from the subcollection
        DocumentSnapshot addressDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('address')
            .doc('currentAddress') // Assuming you have a document named 'currentAddress'
            .get();

        if (addressDoc.exists) {
          setState(() {
            address = addressDoc['landmark'] ?? "Unknown";
            phoneNumber = addressDoc['phone'] ?? "Unknown";
          });
        }
      } catch (error) {
        print("Error fetching user details: $error");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  /// Calculate points based on totalSpent
  Future<void> _calculatePoints() async {
    try {
      // Fetch revenue data for the current user
      QuerySnapshot revenueSnapshot = await FirebaseFirestore.instance
          .collection('revenue')
          .where('userId', isEqualTo: userId)
          .get();

      // Calculate the total revenue
      double totalSpent = revenueSnapshot.docs.fold(0.0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        return sum + (data['price'] ?? 0.0);
      });

      // Calculate points (1 point for every ₹100 spent)
      int calculatedPoints = (totalSpent / 100).floor();

      // Update the points in the user's document in the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'points': calculatedPoints,
      });

      // Update the local state
      setState(() {
        points = calculatedPoints;
      });
    } catch (e) {
      print('Error calculating points: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConstant.secondaryColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.05),
            child: CircleAvatar(
              backgroundImage: AssetImage(ImageConstant.aesthetic_userprofile),
              radius: width * 0.15,
            ),
          ),
          Text(
            currentUserName,
            style: TextStyle(
                color: ColorConstant.primaryColor,
                fontSize: width * 0.05,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Customer"),
              Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    toggleSwitch(value);
                    if (isSwitched) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocalArtistNavbar()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerNavbar()));
                    }
                  }),
              Text("Local Artist"),
            ],
          ),

          SizedBox(
            height: height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "User Info",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(width: width*0.03,),
              GestureDetector(
                onTap: () {
                  // Navigate to ChangeAddress page when the edit icon is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeAddress()),
                  );
                },
                child: Icon(
                  Icons.edit,
                  size: height * 0.02,
                  color: ColorConstant.primaryColor,
                ),
              ),// Add edit icon here
            ],
          ),
          // Editable User Details

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: $email"),
                SizedBox(height: height * 0.01),
                Text("Address: $address"),
                SizedBox(height: height * 0.01),
                Text("Phone: $phoneNumber"),
                SizedBox(height: height * 0.01),
                Text("Points: $points"),

              ],
            ),
          ),
          SizedBox(height: height*0.015,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Earn more points by purchasing more products! 1 point = ₹100 spent. Happy shopping!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: height * 0.02),

          // LogOut button
          GestureDetector(
            onTap: () async {
              await signOut(); // Call the signOut function
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StreamPage()),
                (Route<dynamic> route) => false, // Remove all previous routes
              );
            },
            child: Container(
              height: height * 0.05,
              width: width * 0.09,
              decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(
                Icons.logout,
                color: ColorConstant.secondaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
