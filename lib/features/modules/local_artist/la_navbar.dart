import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';


class LocalArtistNavbar extends StatefulWidget {
  const LocalArtistNavbar({super.key});

  @override
  State<LocalArtistNavbar> createState() => _LocalArtistNavbarState();
}

class _LocalArtistNavbarState extends State<LocalArtistNavbar> {
   int currentIndex=0;
  List pages=[
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
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
        backgroundColor: ColorConstant.primaryColor,
        height: height*0.075,
        items: [
          Icon(Icons.home),
          Icon(Icons.category_outlined),
          Icon(Icons.area_chart),
          Icon(Icons.message),
          Icon(Icons.person),
        ],
      ),
    );
  }
}
