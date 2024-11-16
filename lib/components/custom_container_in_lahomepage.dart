
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  CustomContainer({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*0.1,
      width: width*0.9,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width * 0.02),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.primaryColor.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title),
          Text(subtitle),
        ],
      ),
    );
  }
}