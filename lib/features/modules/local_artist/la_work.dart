import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class LaWork extends StatefulWidget {
  const LaWork({super.key});

  @override
  State<LaWork> createState() => _LaWorkState();
}

class _LaWorkState extends State<LaWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        title: Text("WORKS",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: width*0.05
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding:  EdgeInsets.all(width*0.05),
            child: Icon(Icons.cloud_done),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: height*0.035,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_list),
                    Text("Filters")
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.sort)
                  ],
                ),
                Icon(Icons.list)
              ],
            ),
          )
        ],
      ),
    );
  }
}
