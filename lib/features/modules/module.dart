import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elegantia_art/features/modules/customer/customer_navbar.dart';
import 'package:elegantia_art/features/modules/local_artist/job_category.dart';
import 'package:elegantia_art/features/modules/local_artist/la_homepage.dart';
import 'package:elegantia_art/features/modules/local_artist/la_navbar.dart';
import 'package:elegantia_art/features/modules/local_artist/message_page.dart';
import 'package:elegantia_art/features/modules/local_artist/profile_page.dart';
import 'package:flutter/material.dart';

import '../../core/color_constants/color_constant.dart';
import '../../core/image_constants/image_constant.dart';
import '../../main.dart';

class ModuleDivision extends StatefulWidget {
  const ModuleDivision({super.key});

  @override
  State<ModuleDivision> createState() => _ModuleDivisionState();
}

class _ModuleDivisionState extends State<ModuleDivision> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height*1,
            width: width*1,
            decoration:BoxDecoration(
              image: DecorationImage(image: AssetImage(ImageConstant.bg),fit: BoxFit.cover)
            ),
            child: Center(
              child: Container(
                height: height*0.5,
                width: width*0.75,
                color: Colors.white.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("select your profile type to get started"),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerNavbar(),));
                        setState(() {

                        });
                      },
                      child: Container(
                        height: height*0.06,
                        width: width*0.5,
                        color: ColorConstant.primaryColor.withOpacity(0.5),
                        child: Center(
                          child: Text("CUSTOMER",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LocalArtistNavbar(),));
                        setState(() {

                        });
                      },
                      child: Container(
                        height: height*0.06,
                        width: width*0.5,
                        color: ColorConstant.primaryColor.withOpacity(0.5),
                        child: Center(
                          child: Text("ARTIST",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox()
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}

