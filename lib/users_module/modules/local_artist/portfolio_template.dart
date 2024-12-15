import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class PortfolioTemplate extends StatefulWidget {
  const PortfolioTemplate({super.key});

  @override
  State<PortfolioTemplate> createState() => _PortfolioTemplateState();
}

class _PortfolioTemplateState extends State<PortfolioTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        title: Text("Make your portfolio",
          style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: width*0.03,
              fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: height*0.85,
          width: width*0.85,
          decoration: BoxDecoration(
            color: ColorConstant.primaryColor,
            borderRadius: BorderRadius.circular(width*0.05),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: width*0.03,
                spreadRadius: width*0.003,
                offset: Offset(0, 4)
              )
            ]
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: height*0.2,
                  width: width*0.7,
                  decoration: BoxDecoration(
                    color: ColorConstant.secondaryColor,
                    borderRadius: BorderRadius.circular(width*0.05),
                  ),
                  child: Center(
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("add image of your work ",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.4)
                            ),
                          ),
                          Icon(Icons.add,color: Colors.black.withOpacity(0.4),)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
