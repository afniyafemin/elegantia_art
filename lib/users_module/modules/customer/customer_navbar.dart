import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/99%20mall.dart';
import 'package:elegantia_art/users_module/modules/customer/categories.dart';
import 'package:elegantia_art/users_module/modules/customer/home_customer.dart';
import 'package:flutter/material.dart';

class CustomerNavbar extends StatefulWidget {
  const CustomerNavbar({super.key});

  @override
  State<CustomerNavbar> createState() => _CustomerNavbarState();
}
//
class _CustomerNavbarState extends State<CustomerNavbar> {
  int currentIndex = 0;
  List pages = [
    HomePage(),
    CategoryList(),
    MallMall(),
    MallMall()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

        },
        backgroundColor: ColorConstant.secondaryColor,
        height: height * 0.075,
        items: [
          Icon(Icons.home),
          Icon(Icons.category_outlined),
          Icon(Icons.local_mall_outlined),
          Icon(Icons.favorite_outline_rounded),
        ],
      ),
    );
  }
}