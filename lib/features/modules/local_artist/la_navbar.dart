import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/features/modules/local_artist/job_category.dart';
import 'package:elegantia_art/features/modules/local_artist/job_portal.dart';
import 'package:elegantia_art/features/modules/local_artist/message_page.dart';
import 'package:elegantia_art/features/modules/local_artist/portfolio_page.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalArtistNavbar extends StatefulWidget {
  const LocalArtistNavbar({super.key});

  @override
  State<LocalArtistNavbar> createState() => _LocalArtistNavbarState();
}

class _LocalArtistNavbarState extends State<LocalArtistNavbar> {
  int currentIndex=0;
  List pages=[
    JobPortal(),
    PortfolioPage(),
    JobCategoryPage(),
    MessagePage(),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (value) {
          currentIndex=value;
          setState(() {

          });
        },
        backgroundColor: ColorConstant.secondaryColor,
        height: height*0.075,
        animationDuration: Duration(milliseconds: 300),
        color: ColorConstant.primaryColor,
        items: [
          Icon(Icons.home,color: ColorConstant.secondaryColor),
          Icon(Icons.category_outlined,color: ColorConstant.secondaryColor),
          Icon(Icons.work,color: ColorConstant.secondaryColor),
          Icon(Icons.message,color: ColorConstant.secondaryColor),
        ],
      ),
    );
  }
}
