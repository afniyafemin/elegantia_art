//
// import 'package:elegantia_art/components/custom_container_in_lahomepage.dart';
// import 'package:elegantia_art/components/custom_drawer.dart';
// import 'package:elegantia_art/core/color_constants/color_constant.dart';
// import 'package:elegantia_art/core/image_constants/image_constant.dart';
// import 'package:flutter/material.dart';
//
// class LaHomepage extends StatefulWidget {
//
//   @override
//   State<LaHomepage> createState() => _LaHomepageState();
// }
//
// class _LaHomepageState extends State<LaHomepage> {
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool isSwitched = false;
//   @override
//   Widget build(BuildContext context) {
//     var height= MediaQuery.of(context).size.height;
//     var width=MediaQuery.of(context).size.width;
//     return Scaffold(
//
//       //this key is needed , when the userprofile is clicked th key will get
//       //enabled and the drawer will come up
//       key: _scaffoldKey,
//
//       //Drawer
//
//       drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
//       backgroundColor: ColorConstant.secondaryColor,
//
//         body:
//
//         SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding:  EdgeInsets.only(top:width*0.03),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           InkWell(
//                             onTap: (){
//                               _scaffoldKey.currentState?.openDrawer();
//                             },
//                             child: CircleAvatar(
//                               backgroundImage: AssetImage(ImageConstant.user_profile),
//                             ),
//                           ),
//                           SizedBox(width: width*0.03,),
//                           Text("Username",
//                             style: TextStyle(
//                                 fontSize: width*0.05,
//                                 fontWeight: FontWeight.w700
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: width*0.04,
//                             backgroundColor: ColorConstant.primaryColor,
//                             child: Icon(Icons.search,color: ColorConstant.secondaryColor,),
//                           ),
//                           SizedBox(width: width*0.03,),
//                           CircleAvatar(
//                             radius: width*0.04,
//                             backgroundColor: ColorConstant.primaryColor,
//                             child: Icon(Icons.add_shopping_cart,color: ColorConstant.secondaryColor,),
//                           ),
//                           SizedBox(width: width*0.03,),
//                         ],
//                       )
//                     ],
//                   ),
//                   Divider(
//                     height: height*0.015,
//                     color: ColorConstant.primaryColor,
//                   ),
//
//                   // 1st part
//                   Container(
//                     height: height*0.3,
//                     width: width*1,
//                     color: ColorConstant.primaryColor,
//                     child: Center(
//                       child: Container(
//                         height: height*0.18,
//                         width: width*0.8,
//                         decoration: BoxDecoration(
//                           color: ColorConstant.secondaryColor,
//                           borderRadius: BorderRadius.all(Radius.circular(width*0.05))
//                         ),
//                         child: Column(
//                           children: [
//                             Text("Nov 9 2024"),
//                             Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Column(
//                                   children: [Text("ORDERS"),
//                                   Text("10")],
//                                 ),
//                                 Padding(
//                                   padding:  EdgeInsets.only(left: 20,right: 20),
//                                   child: Column(children: [Text("PROFIT"),
//                                   Text("+0.5")],),
//                                 ),
//                                 Column(
//                                   children: [Text("SAVED"),
//                                   Text("05")],
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   //2nd part
//                   SizedBox(height: height*0.04,),
//                   CustomContainer(
//                     title: "New work Opportunities",
//                     subtitle: "3 new works are available",
//                     color: ColorConstant.primaryColor,
//                   ),
//                   SizedBox(height: height*0.02,),
//                   CustomContainer(
//                     title: "Pending Work",
//                     subtitle: "You have 7 pending works",
//                     color: ColorConstant.secondaryColor,
//                   ),
//                   SizedBox(height: height*0.02,),
//                   CustomContainer(
//                     title: "Messages",
//                     subtitle: "2 new notifications",
//                     color: ColorConstant.primaryColor,
//                   ),
//
//                   //message section
//                   Padding(
//                     padding:  EdgeInsets.all(width*0.04),
//                     child: GridView.count(
//                       shrinkWrap: true, // add this
//                       crossAxisCount: 3,// number of columns
//                       mainAxisSpacing: 10.0, // add this
//                       crossAxisSpacing: 10.0, // add this
//                       children: List.generate(6, (index) { // generate 10 CircleAvatar widgets
//                         return Column(
//                           children: [
//                             CircleAvatar(
//                               backgroundImage: AssetImage(ImageConstant.user_profile),
//                               radius: width*0.1,
//                             ),
//                             Text("Username")
//                           ],
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//     );
//   }
// }
