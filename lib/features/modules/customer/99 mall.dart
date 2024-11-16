import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class MallMall extends StatefulWidget {
  const MallMall({super.key});

  @override
  State<MallMall> createState() => _MallMallState();
}

class _MallMallState extends State<MallMall> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        centerTitle: true,
        title: Text(
          "99 MALL",
          style: TextStyle(
              color: ColorConstant.primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: width * 0.05),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
              ),
              itemCount:8,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: height * 0.225,
                            width: width * 0.35,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "asset/images/Product_1.jpg"),
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.25, top: width * 0.3525),
                            child: InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                height: height * 0.06,
                                width: width * 0.12,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorConstant.primaryColor,
                                        blurRadius: width * 0.03)
                                  ],
                                  borderRadius:
                                      BorderRadius.circular(width * 0.2),
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.favorite_outline),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: width * 0.075,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: width * 0.075,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: width * 0.075,
                              ),
                              Icon(
                                Icons.star_outline,
                                size: width * 0.075,
                              ),
                              Icon(
                                Icons.star_outline,
                                size: width * 0.075,
                              ),
                            ],
                          ),
                          Text(
                            p_names[index],
                            style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            products[index]["price"],
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
