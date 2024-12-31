//
// import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../constants/color_constants/color_constant.dart';
// import 'categories.dart';
//
// String p="";
//
//
// class Catelog1 extends StatefulWidget {
//   const Catelog1({super.key});
//
//   @override
//   State<Catelog1> createState() => _Catelog1State();
// }
// bool lg = true;
// List p_names=[
//   "Ring album",
//   "Journals",
//   "Resin",
//   "Charm",
//   "Stamps"
// ];
// List<Map> products = [
//   {"name": "product 1", "price": "Rs"},
//   {"name": "product 2", "price": "Rs"},
//   {"name": "product 3", "price": "Rs"},
//   {"name": "product 4", "price": "Rs"},
//   {"name": "product 5", "price": "Rs"},
//   {"name": "product 6", "price": "Rs"},
//   {"name": "product 7", "price": "Rs"},
//   {"name": "product 8", "price": "Rs"},
//   {"name": "product 9", "price": "Rs"},
//   {"name": "product 10", "price": "Rs"},
//   {"name": "product 11", "price": "Rs"},
//   {"name": "product 12", "price": "Rs"},
//   {"name": "product 13", "price": "Rs"},
//   {"name": "product 14", "price": "Rs"},
//   {"name": "product 15", "price": "Rs"},
// ];
// List sort=[
//   "Popular",
//   "Newest",
//   "Customer Review",
//   "Price: Low to High",
//   "Price: High to Low"
// ];
//
// class _Catelog1State extends State<Catelog1> {
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: ColorConstant.secondaryColor,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: ColorConstant.primaryColor,
//         title: Text(
//           "c",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: width * 0.05,
//           ),
//         ),
//       ),
//       body: ListView(
//           shrinkWrap: true,
//           physics: BouncingScrollPhysics(),
//           children: [
//             SizedBox(height: height*0.01,),
//             Padding(
//               padding: EdgeInsets.only(left: width*0.03,right: width*0.03),
//               child: Container(
//                 height: height * 0.03,
//                 color: Colors.white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         showModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return Container(
//                                 height: height*0.45,
//                                 width: width*1,
//                                 decoration: BoxDecoration(
//                                     color: ColorConstant.secondaryColor,
//                                     borderRadius:BorderRadius.only(
//                                         topLeft: Radius.circular(width*0.05),
//                                         topRight: Radius.circular(width*0.05)
//                                     )
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                   children: [
//                                     SizedBox(height: height*0.015,),
//                                     Container(
//                                       height: height*0.01,
//                                       width: width*0.25,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(width*0.1)
//                                       ),
//                                     ),
//                                     SizedBox(height: height*0.015,),
//                                     Text("Sort By",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: width*0.05
//                                       ),
//                                     ),
//                                     SizedBox(height: height*0.015,),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         itemCount: 5,
//                                         itemBuilder: (BuildContext context, int index) {
//                                           return Card(
//                                             color: ColorConstant.primaryColor,
//                                             child: ListTile(
//                                               leading: Text(sort[index],
//                                                 style: TextStyle(
//                                                     color: ColorConstant.secondaryColor
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             }
//                         );
//                         setState(() {
//
//                         });
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.sort_outlined),
//                           SizedBox(
//                             width: width * 0.01,
//                           ),
//                           Text("Sort By")
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           lg = !lg;
//                         });
//                       },
//                       child: Icon(lg ? Icons.grid_view_sharp : Icons.list),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: height*0.01,),
//             InkWell(
//               onTap: (){
//                 setState(() {
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductInfo()));
//                 });
//               },
//               child: Container(
//                   height: height*1,
//                   width: width*0.85,
//                   color: ColorConstant.secondaryColor,
//                   child: lg?ListView.builder(
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding:EdgeInsets.all(width*0.03),
//                           child: Stack(
//                               children: [
//                                 Container(
//                                   height: height*0.175,
//                                   width: width*0.9,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(width*0.03),
//                                       color: ColorConstant.primaryColor.withOpacity(0.5)
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         height: height*0.175,
//                                         width: width*0.3,
//                                         decoration: BoxDecoration(
//                                             image: DecorationImage(image: AssetImage("asset/images/Product_1.jpg"),
//                                                 fit: BoxFit.cover ),
//                                             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width*0.03),topLeft:Radius.circular(width*0.03))
//                                         ),
//                                       ),
//                                       Container(
//                                         height: height*0.175,
//                                         width: width*0.4,
//
//                                         child: Padding(
//                                           padding:  EdgeInsets.only(left: width*0.015),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(products[index]["name"]),
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   Icon(Icons.star,color: Colors.yellow,size: width*0.075,),
//                                                   Icon(Icons.star,color : Colors.yellow,size: width*0.075,),
//                                                   Icon(Icons.star,color: Colors.yellow,size: width*0.075,),
//                                                   Icon(Icons.star_outline,size: width*0.075,),
//                                                   Icon(Icons.star_outline,size: width*0.075,),
//                                                 ],),
//                                               Text(products[index]["price"]),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:  EdgeInsets.only(
//                                       left: width*0.8,
//                                       top: width*0.275                       ),
//                                   child: Container(
//                                     height: height*0.06,
//                                     width: width*0.12,
//                                     decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: ColorConstant.primaryColor,
//                                             blurRadius: width*0.03
//                                         )
//                                       ],
//                                       borderRadius: BorderRadius.circular(width*0.2),
//                                       color: Colors.white,
//                                     ),
//                                     child: Icon(Icons.favorite_outline),
//                                   ),
//                                 ),
//                               ]
//                           ),
//
//
//
//                         );
//                       },
//                       // separatorBuilder: (context, index) {
//                       //   return SizedBox(height: height*0.015,);
//                       // },
//                       itemCount: 10
//                   ):
//                   GridView.builder(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.vertical,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 0.7
//                       //mainAxisSpacing: width*0.03,crossAxisSpacing: width*0.03
//                     ),
//                     itemCount: 5,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         color: ColorConstant.secondaryColor,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Stack(
//                               children: [
//                                 Container(
//                                   height: height*0.225,
//                                   width: width*0.35,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(width*0.03),
//                                       image: DecorationImage(image: AssetImage("asset/images/Product_1.jpg"),fit: BoxFit.cover)
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:  EdgeInsets.only(
//                                       left: width*0.25,
//                                       top: width*0.3525                       ),
//                                   child: Container(
//                                     height: height*0.06,
//                                     width: width*0.12,
//                                     decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: ColorConstant.primaryColor,
//                                             blurRadius: width*0.03
//                                         )
//                                       ],
//                                       borderRadius: BorderRadius.circular(width*0.2),
//                                       color: Colors.white,
//                                     ),
//                                     child: Icon(Icons.favorite_outline),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.star,color: Colors.yellow,size: width*0.075,),
//                                 Icon(Icons.star,color: Colors.yellow,size: width*0.075,),
//                                 Icon(Icons.star,color: Colors.yellow,size: width*0.075,),
//                                 Icon(Icons.star_outline,size: width*0.075,),
//                                 Icon(Icons.star_outline,size: width*0.075,),
//                               ],),
//                             Text(p_names[index],
//                               style: TextStyle(
//                                   fontSize: width*0.05,
//                                   fontWeight: FontWeight.w700
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                             Padding(
//                               padding:EdgeInsets.only(left: width*0.05),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(products[index]["price"],
//                                     textAlign: TextAlign.left,
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     },
//                   )
//               ),
//             )
//           ]
//       ),
//     );
//   }
// }