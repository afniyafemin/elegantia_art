import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class Catelogs extends StatefulWidget {
  const Catelogs({super.key});

  @override
  State<Catelogs> createState() => _CatelogsState();
}

bool lg = true;
List p_names = ["Ring album", "Journals", "Resin", "Charm", "Stamps"];
List<Map> products = [
  {"name": "product 1", "price": "Rs"},
  {"name": "product 2", "price": "Rs"},
  {"name": "product 3", "price": "Rs"},
  {"name": "product 4", "price": "Rs"},
  {"name": "product 5", "price": "Rs"},
  {"name": "product 6", "price": "Rs"},
  {"name": "product 7", "price": "Rs"},
  {"name": "product 8", "price": "Rs"},
  {"name": "product 9", "price": "Rs"},
  {"name": "product 10", "price": "Rs"},
  {"name": "product 11", "price": "Rs"},
  {"name": "product 12", "price": "Rs"},
  {"name": "product 13", "price": "Rs"},
  {"name": "product 14", "price": "Rs"},
  {"name": "product 15", "price": "Rs"},
];
List sort = [
  "Popular",
  "Newest",
  "Customer Review",
  "Price: Low to High",
  "Price: High to Low"
];

class _CatelogsState extends State<Catelogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.secondaryColor,
        body: Column(children: [
          Container(
            
            child: Stack(
              children: <Widget>[
                Container(
                  height: height * 0.3,
                  width: width*1,
                  color: ColorConstant.primaryColor,
                  child: Icon(Icons.sort_outlined,color: ColorConstant.secondaryColor,),
                ),
               Positioned(
                   top: 20.0,
                   left: 0.0,
                   right: 0.0,
                   child: Container(
                 height: height*0.7,
                 child: Column(
                   children: [Expanded(
                       child:ListView.builder(itemCount: products.length,
                           shrinkWrap: true,
                           physics: BouncingScrollPhysics(),
                           itemBuilder: (context,index){
                         return Container(
                           height: height*0.2,
                           width: width*0.8,
                           decoration: BoxDecoration(
                             color: ColorConstant.primaryColor,
                             borderRadius: BorderRadius.all(Radius.circular(20))
                           ),
                         );
                           })
                   )],
                 ),
               ))
              ],
            ),
          ),
        ]));
  }
}
