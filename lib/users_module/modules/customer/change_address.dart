import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/color_constants/color_constant.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({super.key});

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  final nameController = TextEditingController();
  final postController = TextEditingController();
  final pinController = TextEditingController();
  final landmarkController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /// Load user data from Firestore and auto-fill the text fields
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid).collection('address')
            .doc('currentAddress')
            .get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            nameController.text = data['name'] ?? '';
            postController.text = data['post'] ?? '';
            pinController.text = data['pin'] ?? '';
            landmarkController.text = data['landmark'] ?? '';
            phoneController.text = data['phone'] ?? '';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  /// Save the updated address to Firestore
  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('address')
              .doc('currentAddress')
              .set({
            'name': nameController.text.trim(),
            'post': postController.text.trim(),
            'pin': pinController.text.trim(),
            'landmark': landmarkController.text.trim(),
            'phone': phoneController.text.trim(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address saved successfully!')),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save address: $e')),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Auto-fill fields on initialization
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(backgroundColor: ColorConstant.primaryColor,
      iconTheme: IconThemeData(
        color: ColorConstant.secondaryColor
      ),),
      backgroundColor: ColorConstant.primaryColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(width * 0.05),
              height: height * 0.85,
              width: width * 0.85,
              decoration: BoxDecoration(
                color: ColorConstant.secondaryColor,
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _buildTextField('Name', nameController),
                      SizedBox(height: height * 0.02),
                      _buildTextField('Post', postController),
                      SizedBox(height: height * 0.02),
                      _buildTextField('Pin', pinController),
                      SizedBox(height: height * 0.02),
                      _buildTextField('Any Landmark', landmarkController),
                      SizedBox(height: height * 0.02),
                      _buildTextField('Phone', phoneController),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Update your address for an easier delivery process.",
                        style: TextStyle(
                          color: ColorConstant.primaryColor.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.04,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.015),
                      InkWell(
                        onTap: _saveAddress,
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.4,
                          decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Center(
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                color: ColorConstant.secondaryColor,
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a styled TextFormField
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: ColorConstant.primaryColor.withOpacity(0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.primaryColor.withOpacity(0.6),
          ),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
