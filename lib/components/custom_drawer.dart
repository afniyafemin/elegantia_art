

import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/login_signup/login.dart';
import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
import 'package:elegantia_art/users_module/modules/local_artist/la_navbar.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;


  CustomDrawer({ required this.scaffoldKey,});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static bool _isSwitched = false;

  bool get isSwitched => _isSwitched;

  void toggleSwitch(bool value) {
    _isSwitched = value;
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: ColorConstant.secondaryColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height*0.05),
              child: CircleAvatar(
                backgroundImage: AssetImage(ImageConstant.user_profile),
                radius: width*0.15,
              ),
            ),
            Text("Username"),
            Container(
              height: height*0.35,
              width: width*1,
              decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)
                  )
              ),
              child: Column(
                children: [
                  Switch(value: isSwitched,
                      onChanged: (value) {
                        toggleSwitch(value);
                        if(isSwitched){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> LocalArtistNavbar()));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerNavbar()));
                        }
                      })
                ],
              ),
            ),
            SizedBox(),
            Text("CREDITS"),
            Container(
              height: height*0.06,
              width: width*0.4,
              color: ColorConstant.primaryColor,
            ),
            Text("Current points: 40/100 "),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("the more you buy the products from us will get your points to increase, which is useful for your next purchase as it reduce the cost. happy shopping!"),
            ),

            //LogOut button

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
              },
              child: Container(
                height: height*0.05,
                width: width*0.09,
                decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(Icons.logout,color: ColorConstant.secondaryColor,),
              ),
            )
          ],
        )
    );
  }
}
