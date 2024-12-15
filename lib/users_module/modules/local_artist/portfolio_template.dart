import 'dart:io';

import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioTemplate extends StatefulWidget {
  final workName;
  final workDescription;

  const PortfolioTemplate({required this.workName, required this.workDescription, super.key});

  @override
  State<PortfolioTemplate> createState() => _PortfolioTemplateState();
}

String? workName;
String? workDescription;
class _PortfolioTemplateState extends State<PortfolioTemplate> {
  var file_;

  final nameController=TextEditingController();
  final descriptionController=TextEditingController();

  pickFile(ImageSource) async {
    final imageFile=await ImagePicker().pickImage(source: ImageSource);
    file_=File(imageFile!.path);
    if(mounted){
      setState(() {
        file_=File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        title: Text("Make your portfolio",
          style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: width*0.03,
              fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: height*0.85,
            width: width*0.85,
            decoration: BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.circular(width*0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: width*0.03,
                  spreadRadius: width*0.003,
                  offset: Offset(0, 4)
                )
              ]
            ),
            child: Padding(
              padding:EdgeInsets.all(width*0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {

                          });
                          showCupertinoDialog(
                            context: context, builder: (context) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    ImagePicker().pickImage(source: ImageSource.gallery);
                                  },
                                  child: Text("Photo Gallery",style: TextStyle(color:ColorConstant.primaryColor),)
                              ),
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    ImagePicker().pickImage(source: ImageSource.camera);
                                  },
                                  child: Text("Camera",style: TextStyle(color: ColorConstant.primaryColor),)
                              ),
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel",style: TextStyle(color: ColorConstant.primaryColor),)
                              )
                            ],
                          ),
                          );
                        },
                        child: Container(
                          height: height*0.2,
                          width: width*0.7,
                          decoration: BoxDecoration(
                            color: ColorConstant.secondaryColor,
                            borderRadius: BorderRadius.circular(width*0.05),
                          ),
                          child: Center(
                            child: GestureDetector(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("add image of your work ",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.4)
                                    ),
                                  ),
                                  Icon(Icons.add,color: Colors.black.withOpacity(0.4),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height*0.03,),
                      TextFormField(
                        controller: nameController,
                        cursorColor: ColorConstant.secondaryColor,
                        decoration: InputDecoration(
                            label: Text("Name",
                              style: TextStyle(
                                color: ColorConstant.secondaryColor.withOpacity(0.5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width*0.03),
                          borderSide: BorderSide(
                              color: ColorConstant.secondaryColor,
                              width: width*0.005
                          )
                      ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width*0.03),
                                borderSide: BorderSide(
                                    color: ColorConstant.secondaryColor,
                                    width: width*0.005
                                )
                            )
                        ),
                      ),
                      SizedBox(height: height*0.03,),
                      TextFormField(
                        controller: descriptionController,
                        cursorColor: ColorConstant.secondaryColor,
                        maxLines: 4,
                        decoration: InputDecoration(
                            label: Text("Description",
                            style: TextStyle(
                              color: ColorConstant.secondaryColor.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width*0.03),
                                borderSide: BorderSide(
                                    color: ColorConstant.secondaryColor,
                                    width: width*0.005
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width*0.03),
                                borderSide: BorderSide(
                                    color: ColorConstant.secondaryColor,
                                    width: width*0.005
                                )
                            )
                        ),
                      ),
                      SizedBox(height: height*0.03,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCupertinoDialog(
                                context: context, builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        ImagePicker().pickImage(source: ImageSource.gallery);
                                      },
                                      child: Text("Photo Gallery",style: TextStyle(color:ColorConstant.primaryColor),)
                                  ),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        ImagePicker().pickImage(source: ImageSource.camera);
                                      },
                                      child: Text("Camera",style: TextStyle(color: ColorConstant.primaryColor),)
                                  ),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel",style: TextStyle(color: ColorConstant.primaryColor),)
                                  )
                                ],
                              ),
                              );
                            },
                            child: Container(
                              height: height*0.05,
                              width: width*0.3,
                              decoration: BoxDecoration(
                                  color: ColorConstant.secondaryColor,
                                  borderRadius: BorderRadius.circular(width*0.03)
                              ),
                              child: Center(
                                child: Text("Add Photo",
                                  style: TextStyle(
                                    color: ColorConstant.primaryColor,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          
                  // SizedBox(height: height*0.2,),
                  GestureDetector(
                    onTap: () {
                      setState(() {

                        workName = nameController.text.trim();
                        workDescription = descriptionController.text.trim();

                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      height: height*0.05,
                      width: width*0.3,
                      decoration: BoxDecoration(
                          color: ColorConstant.secondaryColor,
                          borderRadius: BorderRadius.circular(width*0.03)
                      ),
                      child: Center(
                        child: Text("Submit",
                          style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.w700
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
