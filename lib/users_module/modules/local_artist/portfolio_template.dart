import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';

class PortfolioTemplate extends StatefulWidget {
  const PortfolioTemplate({super.key});

  @override
  State<PortfolioTemplate> createState() => _PortfolioTemplateState();
}

class _PortfolioTemplateState extends State<PortfolioTemplate> {
  final List<File> _images = []; // List to hold selected images
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage(); // Allow multiple image selection
    if (pickedFiles != null) {
      setState(() {
        for (var file in pickedFiles) {
          _images.add(File(file.path)); // Add selected images to the list
        }
      });
    }
  }

  Future<void> uploadPortfolio() async {
    String userId = FirebaseAuth.instance.currentUser !.uid; // Get the current user ID
    String workName = nameController.text.trim();
    String workDescription = descriptionController.text.trim();

    if (workName.isEmpty || workDescription.isEmpty || _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields and select images.")),
      );
      return;
    }

    try {
      // Create a reference to the user's portfolio subcollection
      CollectionReference portfolioRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('portfolio');

      // Upload images and get their URLs
      List<String> imageUrls = [];
      for (var image in _images) {
        // Create a unique file name
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference storageRef = FirebaseStorage.instance.ref().child('portfolio/$userId/$fileName');

        // Upload the image to Firebase Storage
        await storageRef.putFile(image);
        // Get the download URL
        String downloadUrl = await storageRef.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Add the portfolio entry to Firestore
      await portfolioRef.add({
        'workName': workName,
        'workDescription': workDescription,
        'images': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Portfolio submitted successfully!")),
      );

      // Clear the fields and images after submission
      nameController.clear();
      descriptionController.clear();
      setState(() {
        _images.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting portfolio: $e")),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index); // Remove the image at the specified index
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        title: Text(
          "Make your portfolio",
          style: TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontSize: width * 0.03,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: height * 0.85,
            width: width * 0.85,
            decoration: BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.circular(width * 0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: width * 0.03,
                  spreadRadius: width * 0.003,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: pickImages, // Call pickImages method
                        child: Container(
                          height: height * 0.2,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            color: ColorConstant.secondaryColor,
                            borderRadius: BorderRadius.circular(width * 0.05),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Add images of your work",
                                  style: TextStyle(color: Colors.black.withOpacity(0.4)),
                                ),
                                Icon(Icons.add, color: Colors.black.withOpacity(0.4)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      TextFormField(
                        controller: nameController,
                        cursorColor: ColorConstant.secondaryColor,
                        decoration: InputDecoration(
                          label: Text(
                            "Name",
                            style: TextStyle(
                              color: ColorConstant.secondaryColor.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03),
                            borderSide: BorderSide(
                              color: ColorConstant.secondaryColor,
                              width: width * 0.005,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03),
                            borderSide: BorderSide(
                              color: ColorConstant.secondaryColor,
                              width: width * 0.005,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      TextFormField(
                        controller: descriptionController,
                        cursorColor: ColorConstant.secondaryColor,
                        maxLines: 4,
                        decoration: InputDecoration(
                          label: Text(
                            "Description",
                            style: TextStyle(
                              color: ColorConstant.secondaryColor.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03),
                            borderSide: BorderSide(
                              color: ColorConstant.secondaryColor,
                              width: width * 0.005,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.03),
                            borderSide: BorderSide(
                              color: ColorConstant.secondaryColor,
                              width: width * 0.005,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      // Display selected images
                      if (_images.isNotEmpty) ...[
                        Container(
                          height: height * 0.2,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      _images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () => _removeImage(index), // Remove image on button press
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  GestureDetector(
                    onTap: uploadPortfolio, // Call uploadPortfolio method
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: ColorConstant.secondaryColor,
                        borderRadius: BorderRadius.circular(width * 0.03),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: ColorConstant.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}