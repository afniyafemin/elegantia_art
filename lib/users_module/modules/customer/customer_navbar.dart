import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/99%20mall.dart';
import 'package:elegantia_art/users_module/modules/customer/categories.dart';
import 'package:elegantia_art/users_module/modules/customer/home_customer.dart';
import 'package:elegantia_art/users_module/modules/customer/pins.dart';
import 'package:flutter/material.dart';

import 'cart_c.dart';

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
    // Pins(),
    CartCustomer()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: ColorConstant.primaryColor,
        color: ColorConstant.primaryColor,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

        },
        backgroundColor: ColorConstant.secondaryColor,
        height: height * 0.075,
        items: [
          Icon(Icons.home,color: ColorConstant.secondaryColor,),
          Icon(Icons.category_outlined,color: ColorConstant.secondaryColor,),
          Icon(Icons.local_mall_outlined,color: ColorConstant.secondaryColor,),
          Icon(Icons.add_shopping_cart,color: ColorConstant.secondaryColor,),
        ],
      ),
    );
  }
}