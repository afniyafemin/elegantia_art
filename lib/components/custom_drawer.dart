import 'dart:io';

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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  int tier = 0; // Renamed from 'points' to 'tier'
  String profileImageUrl = ImageConstant.aesthetic_userprofile;

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
    _calculateTier();
  }

  String? userId; // Make userId nullable

  // Fetch user details from Firestore
  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      userId = user.uid; // Assign userId only if user is not null
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
            profileImageUrl = userDoc['profileImage'] ?? ImageConstant.aesthetic_userprofile; // Fetch profile image URL
          });
        }

        // Fetch address from the subcollection
        DocumentSnapshot addressDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('address')
            .doc('currentAddress')
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

  // Calculate tier based on totalSpent
  Future<void> _calculateTier() async {
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

      // Calculate tier (1 tier for every ₹100 spent)
      int calculatedTier = (totalSpent / 1000).floor();

      // Update the tier in the user's document in the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'tier': calculatedTier,
      });

      // Update the local state
      setState(() {
        tier = calculatedTier;
      });
    } catch (e) {
      print('Error calculating tier: $e');
    }
  }

  // Method to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Upload the image to Firebase Storage
      await _uploadImageToFirebase(image);
    }
  }

  // Method to upload image to Firebase Storage
  Future<void> _uploadImageToFirebase(XFile image) async {
    try {
      // Create a reference to the Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      String filePath = 'profile_images/${userId}/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = storage.ref().child(filePath);

      // Upload the file
      await ref.putFile(File(image.path));

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();

      // Update the user's document in Firestore with the new profile image URL
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImage': downloadUrl,
      });

      // Update the local state to reflect the new image
      setState(() {
        profileImageUrl = downloadUrl; // Update the profile image URL
      });
    } catch (e) {
      print('Error uploading image: $e');

      // If the upload fails, set the default image from ImageConstant
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImage': ImageConstant.aesthetic_userprofile, // Default image URL
      });

      // Optionally, you can update the local state to reflect the default image
      setState(() {
        profileImageUrl = ImageConstant.aesthetic_userprofile; // Update to default image
      });
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
            child: GestureDetector(
              onTap: _pickImage, // Open image picker on tap
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: width * 0.15,
              ),
            ),
          ),
          Text(
            currentUserName,
            style: TextStyle(
                color: ColorConstant.primaryColor,
                fontSize: width * 0.05,
                fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
              SizedBox(width: width * 0.03),
              GestureDetector(
                onTap: () {
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
              ),
            ],
          ),
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
                Text("Tier: $tier"),
              ],
            ),
          ),
          SizedBox(height: height * 0.015),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Earn more tiers by purchasing more products! 1 tier = ₹100 spent. Happy shopping!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
            onTap: () async {
              await signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StreamPage()),
                    (Route<dynamic> route) => false,
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
