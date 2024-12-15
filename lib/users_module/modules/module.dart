

import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
import 'package:elegantia_art/users_module/modules/local_artist/la_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

