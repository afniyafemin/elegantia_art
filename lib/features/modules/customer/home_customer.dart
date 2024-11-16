import 'package:carousel_slider/carousel_slider.dart';
import 'package:elegantia_art/components/custom_drawer.dart';
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/core/image_constants/image_constant.dart';
import 'package:elegantia_art/features/modules/customer/all_trending.dart';
import 'package:elegantia_art/features/modules/customer/categories.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
int selectIndex=0;

class _HomePageState extends State<HomePage> {
  List products=[
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
  ];
  List p_names=[
    "Ring album",
    "Journals",
    "Resin",
    "Charm",
    "Stamps",
    "Ring album",
    "Journals",
    "Resin",
    "Charm",
    "Stamps"
  ];

  void signUserOut(){

  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //this key is needed , when the userprofile is clicked th key will get
      //enabled and the drawer will come up
        key: _scaffoldKey,
      drawer: CustomDrawer(
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: ColorConstant.secondaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(width*0.03),
            child: ListView(
              children: [
                Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage(ImageConstant.user_profile),
                            ),
                          ),
                          SizedBox(width: width*0.03,),
                          Text("Username",
                            style: TextStyle(
                              fontSize: width*0.05,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                              setState(() {

                              });
                            },
                            child: CircleAvatar(
                              radius: width*0.04,
                              backgroundColor: ColorConstant.primaryColor,
                              child: Icon(Icons.search,color: ColorConstant.secondaryColor,),
                            ),
                          ),
                          SizedBox(width: width*0.03,),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                            setState(() {

                            });
                          },
                            child: CircleAvatar(
                              radius: width*0.04,
                              backgroundColor: ColorConstant.primaryColor,
                              child: Icon(Icons.add_shopping_cart,color: ColorConstant.secondaryColor,),
                            ),
                          ),
                          SizedBox(width: width*0.03,),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                        height: height*0.3,
                        width: width*0.9,
                        decoration: BoxDecoration(
                          color: ColorConstant.secondaryColor,
                          borderRadius: BorderRadius.circular(width*0.03),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CarouselSlider.builder(
                              itemCount: 4,
                              itemBuilder: (BuildContext context, int index, int realIndex) {
                                return Stack(
                                  children: [
                                    Container(
                                    height: height*0.3,
                                    width: width*0.88,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(width*0.03),
                                        color: ColorConstant.primaryColor,
                                        image: DecorationImage(image: AssetImage(products[index]),fit: BoxFit.cover)
                                    ),
                                  ),
                                    Padding(
                                      padding:EdgeInsets.only(top: height*0.15,left: width*0.05),
                                      child: Text(p_names[index],
                                        style: TextStyle(
                                            fontSize: width*0.1,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    )
                                  ]
                                );
                              },
                              options: CarouselOptions(
        
                                viewportFraction: 1,
                                autoPlay: true,
                                height: height*0.3,
                                autoPlayAnimationDuration: Duration(
                                  seconds: 4
                                ),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    selectIndex=index;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ]
                    ),
                  ),
                  AnimatedSmoothIndicator(
                      activeIndex: selectIndex,
                      count: 5,
                    effect: ColorTransitionEffect(
                      activeDotColor: ColorConstant.primaryColor,
                      dotHeight: height*0.015,
                      dotWidth: width*0.03
                    ),
                  ),
                  SizedBox(height: height*0.015,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Categories"),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryList(),));
                          setState(() {
                            
                          });
                        },
                        child: Text("See all",
                          style: TextStyle(
                            fontSize: width*0.03
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: height*0.2,
                    width: width*0.95,
                    decoration: BoxDecoration(
                      color: ColorConstant.secondaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(width*0.03),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:  EdgeInsets.only(left:width*0.015,right:width*0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: width*0.1,
                                  backgroundImage: AssetImage(products[index])
                                ),
                                Padding(
                                  padding:EdgeInsets.all(width*0.015),
                                  child: Text(p_names[index],
                                    style: TextStyle(
                                        fontSize: width*0.03
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount:5
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Trending"),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TrendingPage(),));
                          setState(() {

                          });
                        },
                        child: Text("See all",
                          style: TextStyle(
                              fontSize: width*0.03
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: height*0.01,),
                  Container(
                  height: height*0.2,
                    width: width*0.95,
                    decoration: BoxDecoration(
                      color: ColorConstant.primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(width*0.03),
                    ),
                  child: ListView.builder(
                    shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:  EdgeInsets.all(width*0.015),
                          child: Container(
                            height: height*0.1,
                            width: width*0.2,
                            decoration: BoxDecoration(
                              color: ColorConstant.secondaryColor,
                              borderRadius: BorderRadius.circular(width*0.02),
                              // boxShadow: [BoxShadow(
                              //   color: ColorConstant.primaryColor.withOpacity(0.5),
                              //   spreadRadius: width*0.05,
                              //   blurRadius: width*0.8,
                              //   offset: Offset(-3,3),
                              // )]
                            ),
                            child: Column(
                              children: [SizedBox(height: height*0.01,),
                                Container(
                                  height: height*0.13,
                                  width: width*0.175,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(width*0.015),
                                    color: ColorConstant.primaryColor,
                                    image: DecorationImage(image: AssetImage(products[index]),fit: BoxFit.cover)
                                  ),
                                ),
                                SizedBox(height: width*0.015,),
                                Text(p_names[index],
                                  style: TextStyle(
                                    fontSize: width*0.03
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount:5
                  ),
                                    ),
                  SizedBox(height: height*0.015,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "New Arrivals"),
                      InkWell(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => TrendingPage(),));
                          setState(() {

                          });
                        },
                        child: Text("See all",
                          style: TextStyle(
                              fontSize: width*0.03
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: height*0.01,),
                  Container(
                    padding: EdgeInsets.all(width*0.005),
                    height: height*0.65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width*0.05),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        childAspectRatio: 0.9
                      ),
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.all(width*0.005),
                          decoration: BoxDecoration(
                            color:ColorConstant.secondaryColor,
                            borderRadius: BorderRadius.circular(width*0.02),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: height*0.175,
                                    width: width*0.35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(width*0.1),
                                      image: DecorationImage(image: AssetImage(products[index]),fit: BoxFit.fill)
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(
                                        left: width*0.253,
                                        top: width*0.275
                                      ),
                                    child: Container(
                                      height: height*0.045,
                                      width: width*0.09,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: ColorConstant.primaryColor,
                                              blurRadius: width*0.01,
                                              spreadRadius: width*0.001
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(width*0.1),
                                        color: Colors.white,
                                      ),
                                      child: Icon(Icons.favorite_outline,color: ColorConstant.primaryColor,),
                                    ),
                                  )
                                ],
                              ),
                              Text(p_names[index],),
                              Row(
                                // for viw until package used
                                children: [
                                  Icon(Icons.star,size: width*0.05,),
                                  Icon(Icons.star,size: width*0.05,),
                                  Icon(Icons.star,size: width*0.05,),
                                  Icon(Icons.star,size: width*0.05,),
                                  Icon(Icons.star,size: width*0.05,),
                                ],
                              )
                            ],
                          ),
                        );
                      },

                    ),
                  )
                ],
              ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}


class CustomText extends StatelessWidget {
  final String text;



  CustomText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          color: ColorConstant.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: width*0.035,
          shadows: [
            Shadow(
              color: ColorConstant.primaryColor.withOpacity(0.5),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}