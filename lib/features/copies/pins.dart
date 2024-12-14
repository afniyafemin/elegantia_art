

import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pins extends StatefulWidget {
  const Pins({super.key});

  @override
  State<Pins> createState() => _PinsState();
}

class _PinsState extends State<Pins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        centerTitle: true,
        title: Text("My Orders",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ColorConstant.primaryColor,
            fontSize: width*0.03
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: height*0.25,
            width: width*1,
            color: Colors.white,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: height*0.1,
                    width: width*0.95,
                    color: ColorConstant.primaryColor,
                  );
                },
            ),
          )
        ],
      ),
    );
  }
}
