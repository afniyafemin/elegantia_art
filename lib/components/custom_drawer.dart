import 'package:elegantia_art/auth/stream.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/login_signup/login.dart';
import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
import 'package:elegantia_art/users_module/modules/local_artist/la_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/sign_out_method.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomDrawer({required this.scaffoldKey});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static bool _isSwitched = false;
  String currentUserName = "User";
  String email = "Unknown";
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
  }

  // Fetch user details from Firestore
  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            currentUserName = userDoc['username'] ?? "User";
            email = userDoc['email'] ?? "Unknown";
            address = userDoc['address'] ?? "Unknown";
            phoneNumber = userDoc['phoneNumber'] ?? "Unknown";
            points = userDoc['points'] ?? 0;
          });
        }
      } catch (error) {
        print("Error fetching user details: $error");
      }
    } else {
      print("No user is currently signed in.");
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
              backgroundImage: AssetImage(ImageConstant.user_profile),
              radius: width * 0.15,
            ),
          ),
          Text(currentUserName,style: TextStyle(
            color: ColorConstant.primaryColor,
            fontSize: width*0.05,
            fontWeight: FontWeight.w700
          ),),
          SizedBox(
            height: height*0.02,
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LocalArtistNavbar()));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CustomerNavbar()));
                    }
                  }),
              Text("Local Artist"),

            ],
          ),

          SizedBox(
            height: height*0.02,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "User Info",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: width*0.04,
                    fontWeight: FontWeight.w500
                ),
              ),
              Icon(Icons.edit, size: height*0.015,color: ColorConstant.primaryColor,), // Add edit icon here
            ],
          ),
          // Editable User Details

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: $email"),
                SizedBox(height: height * 0.015),
                Text("Address: $address"),
                SizedBox(height: height * 0.015),
                Text("Phone Number: $phoneNumber"),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
          SizedBox(),
          Text("CREDITS"),
          Container(
            height: height * 0.06,
            width: width * 0.4,
            color: ColorConstant.primaryColor,
          ),
          Text("Current points: $points/100 "),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "The more you buy products from us, your points increase, which will be useful for your next purchase and reduce the cost. Happy shopping!"),
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
