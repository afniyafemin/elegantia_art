

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

  List p_names = [
    "Ring album",
    "Journals",
    "Journals",
    "Resin",
    "Charm",
    "Charm",
    "Stamps",
    "Stamps",
  ];

  List<Map> products = [
    {"name": "product 1", "price": "Rs"},
    {"name": "product 2", "price": "Rs"},
    {"name": "product 3", "price": "Rs"},
    {"name": "product 4", "price": "Rs"},
    {"name": "product 5", "price": "Rs"},
    {"name": "product 6", "price": "Rs"},
    {"name": "product 7", "price": "Rs"},
    {"name": "product 8", "price": "Rs"},
  ];


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: height * 0.35,
                width: width * 1,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(width * 0.35),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Pins",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: height * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.25),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstant.primaryColor.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 200,
                          offset: Offset(-5, 5),
                        )
                      ],
                    ),
                    height: height * 0.725,
                    width: width * 0.9,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 60), // Add padding to avoid overlap with bottom navigation bar
                      child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorConstant.secondaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorConstant.primaryColor
                                        .withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 200,
                                    offset: Offset(5, 5),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Padding(
                                        padding: EdgeInsets.all(width * 0.04),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "asset/images/Product_1.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                        )),
                                  ),
                                  Text(
                                    products[index]["name"],
                                    style: TextStyle(
                                      color: ColorConstant.primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: height * 0.025,
                                    ),
                                  ),
                                  Text(products[index]["price"]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
