import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constants/color_constant.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({super.key});

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {

  final _formKey = GlobalKey<FormState>();
  String name = '';
  String post = '';
  String pin = '';
  String landmark = '';
  String phone = '';

  Future<void> _saveAddress() async {
  final user = FirebaseAuth.instance.currentUser ;
  if (user != null) {
  final addressCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('address');

  await addressCollection.doc('currentAddress').set({
  'name': name,
  'post': post,
  'pin': pin,
  'landmark': landmark,
  'phone': phone,
  });

  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Address saved successfully!')),
  );
  Navigator.pop(context);
  }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height*1,
                width: width*1,
                color: ColorConstant.primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.05),
                      height: height * 0.7,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                          color: ColorConstant.secondaryColor,
                          borderRadius: BorderRadius.circular(width * 0.05)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              TextFormField(
                                onChanged: (value) => name = value,
                                decoration: InputDecoration(
                                  label: Text(
                                    'Name',
                                    style: TextStyle(
                                      color: ColorConstant.primaryColor
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: Text(
                                    'Post',
                                    style: TextStyle(
                                      color: ColorConstant.primaryColor
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: Text(
                                    'Pin',
                                    style: TextStyle(
                                      color: ColorConstant.primaryColor
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: Text(
                                    'Any Landmark',
                                    style: TextStyle(
                                      color: ColorConstant.primaryColor
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: Text(
                                    'Phone',
                                    style: TextStyle(
                                      color: ColorConstant.primaryColor
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.primaryColor
                                              .withOpacity(0.4))),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Update your address for making delivery process easy",
                                style: TextStyle(
                                    color: ColorConstant.primaryColor
                                        .withOpacity(0.4),
                                    fontWeight: FontWeight.w400,
                                    fontSize: width * 0.0265),
                              ),
                              SizedBox(
                                height: height * 0.015,
                              ),
                              InkWell(
                                onTap: _saveAddress,
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(width * 0.03)),
                                  child: Center(
                                    child: Text(
                                      "Save changes",
                                      style: TextStyle(
                                          color: ColorConstant.secondaryColor,
                                          fontSize: width * 0.03,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
