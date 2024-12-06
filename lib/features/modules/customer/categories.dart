
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/features/login_signup/login.dart';
import 'package:elegantia_art/features/modules/customer/catelog_1.dart';
import 'package:elegantia_art/features/modules/customer/catelogs.dart';
import 'package:elegantia_art/features/modules/customer/catelogs_new_ui.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';
String c="";
class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List categories=[
    "Paper Crafts",
    "Resin Art",
    "Digital Crafts",
    "Mixed Media Crafts",
    "Other Creative Ideas"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios)
        ),
        backgroundColor: ColorConstant.primaryColor,
        title: Text("Categories",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorConstant.secondaryColor
        ),),
        centerTitle: true,
        actions: [Icon(
          Icons.search_sharp,size: width*0.07,
          color: Colors.black,
        ),
        SizedBox(
        width: Checkbox.width*0.5,
        )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width*0.05),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      c=categories[index];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CatelogsNewUi(),));
                      setState(() {

                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height*0.2,
                        width: width*0.9,
                        decoration: BoxDecoration(
                          color: ColorConstant.primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(width*0.03),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width*0.45,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(width*0.03),
                                  bottomLeft:  Radius.circular(width*0.03)
                                ),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "asset/images/Product 1.jpg"
                                    ,),fit: BoxFit.cover
                                )
                              ),
                            ),
                            Text(categories[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width*0.03,
                              color: ColorConstant.secondaryColor
                            ),),
                            SizedBox(width: 10,)
                          ],
                        ),
                        // child: Card(
                        //   color: ColorConstant.secondaryColor.withOpacity(0.7),
                        //   child: ListTile(
                        //     title: Text(categories[index],
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //       ),
                        //       textAlign: TextAlign.center,),
                        //   ),
                        // ),
                      ),
                    ),
                  );
                } ,
                    itemCount: categories.length
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
