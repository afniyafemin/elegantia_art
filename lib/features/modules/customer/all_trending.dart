import 'package:carousel_slider/carousel_slider.dart';
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../main.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  int selectIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorConstant.secondaryColor,
        title: Text("MOST TRENDINGS",
          style: TextStyle(
            color: ColorConstant.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: width*0.05,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  height: height*0.2,
                  width: width*1,
                  color: ColorConstant.secondaryColor,
                  child: Center(
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index, int realIndex) {
                          return Container(
                            height: height*0.15,
                            width: width*1,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("asset/images/Product_2.jpg"),fit: BoxFit.cover)
                            ),
                          );
                        },
                        options: CarouselOptions(
                          aspectRatio: 2.25,
                          viewportFraction: 1,
                        onPageChanged: (index, reason) {
                            setState(() {
                              selectIndex=index;
                            });
                        },
                      ),

                      ),
                        Padding(
                          padding:  EdgeInsets.only(left: width*0.1,top: width*0.025),
                          child: AnimatedSmoothIndicator(
                              activeIndex: selectIndex,
                              count: 10,
                              effect: JumpingDotEffect(
                                activeDotColor: ColorConstant.primaryColor,
                                dotWidth: width*0.05,
                                dotHeight: height*0.01,
                                dotColor: Colors.white,
                              )
                          ),
                        )
                      ]
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: height*0.03,
                );
              },
              itemCount: 6
                            ),
          )
        ],
      ),
    );
  }
}
