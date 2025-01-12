import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_category.dart';
import 'package:elegantia_art/users_module/modules/local_artist/my_jobs_list/my_jobs.dart';
import 'package:elegantia_art/users_module/modules/local_artist/portfolio_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'jobs_home_page.dart';

class LocalArtistNavbar extends StatefulWidget {
  const LocalArtistNavbar({super.key});

  @override
  State<LocalArtistNavbar> createState() => _LocalArtistNavbarState();
}

class _LocalArtistNavbarState extends State<LocalArtistNavbar> {
  int currentIndex=0;
  List pages=[
    JobPortal(),
    JobCategoryPage(),
    PortfolioPage(),
    MyJobs(),
    //ChatPage(),
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
          Icon(Icons.credit_score,color: ColorConstant.secondaryColor),
          Icon(Icons.list_outlined,color: ColorConstant.secondaryColor),
         // Icon(Icons.message,color: ColorConstant.secondaryColor),
        ],
      ),
    );
  }
}
