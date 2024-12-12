import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.secondaryColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: ColorConstant.primaryColor,
              floating: true,
              expandedHeight: 300,
              title: Text(
                "PORTFOLIO",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.secondaryColor),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    //Image(image: AssetImage("asset/images/Product 1.jpg")),
                    // CircleAvatar
                    Positioned(
                      top: height * 0.165, // Adjust the position as needed
                      left: width * 0.4, // Adjust the position as needed
                      child: Container(
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: Offset(3, 3),
                          )
                        ]),
                        child: CircleAvatar(
                          radius: 40, // Adjust// the size as needed
                          backgroundColor:
                              ColorConstant.secondaryColor.withOpacity(0.5),
                          child: Icon(
                            Icons.add,
                            color: ColorConstant.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverGrid.builder(
              //delegate: SliverChildBuilderDelegate(builder),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.7),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.005),
                    /*The Gesture detector detect when a container in the grid
                    * is tapped ,it should popup a alerdialog to know the details
                    * about the container */
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: ColorConstant.secondaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                content: Container(
                                  width: width * 0.95,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: height*0.01),
                                        child: Container(height: height*0.3,
                                            width: width*0.9,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(image:  AssetImage(
                                                  "asset/images/Product_1.jpg"),fit: BoxFit.cover,),
                                              borderRadius: BorderRadius.circular(width*0.02)
                                            )
                                            ),
                                      ),
                                      Text("Project Name"),
                                      Row(mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: height*0.05,
                                            width: width*0.1,
                                            decoration: BoxDecoration(
                                                color: ColorConstant.primaryColor,
                                                borderRadius: BorderRadius.circular(width*0.03)
                                            ),
                                            child: Icon(Icons.delete,color: ColorConstant.secondaryColor,),
                                          ),
                                          SizedBox(
                                            width: width*0.02,
                                          ),
                                          Container(
                                            height: height*0.05,
                                            width: width*0.1,
                                            decoration: BoxDecoration(
                                                color: ColorConstant.primaryColor,
                                                borderRadius: BorderRadius.circular(width*0.03)
                                            ),
                                            child: Icon(Icons.edit,color: ColorConstant.secondaryColor,),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      //the image containers in the grid
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("asset/images/Product_1.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        )
        );
  }
}
