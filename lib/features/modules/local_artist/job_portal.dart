import 'package:carousel_slider/carousel_slider.dart';
import 'package:elegantia_art/components/custom_drawer.dart';
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/core/image_constants/image_constant.dart';
import 'package:elegantia_art/features/modules/customer/catelog_1.dart';
import 'package:elegantia_art/features/modules/customer/home_customer.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class JobPortal extends StatefulWidget {
  const  JobPortal({super.key});

  @override
  State<JobPortal> createState() => _JobPortalState();
}

class _JobPortalState extends State<JobPortal> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  int currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      drawer: CustomDrawer(
        scaffoldKey: scaffoldkey,
      ),
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        leadingWidth: width*0.8,
        backgroundColor: ColorConstant.primaryColor,
        toolbarHeight: height*0.2,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding:  EdgeInsets.only(top:width*0.03,left: width*0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome Back !",
                style: TextStyle(
                  color: ColorConstant.secondaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: width*0.04
                ),
              ),
              Text("John",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: width*0.075,
                  fontWeight: FontWeight.w900,
                  color: ColorConstant.secondaryColor
                ),
              ),
              SizedBox(height: height*0.015,),
              TextFormField(
                cursorColor: ColorConstant.primaryColor,
                cursorHeight: height*0.02,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstant.secondaryColor,
                  prefixIcon: Icon(Icons.search,color: ColorConstant.primaryColor,),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorConstant.primaryColor,
                      width: width*0.01
                    ),
                    borderRadius: BorderRadius.circular(width*0.05)
                  ),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width*0.05),
                      borderSide: BorderSide(
                          color: ColorConstant.primaryColor,
                          width: width*0.01
                      ),
                  ),
                  hintText: "search for jobs or products",
                    hintStyle: TextStyle(color: ColorConstant.primaryColor.withOpacity(0.4))
                ),
              )
            ],
          ),
        ),
        actions: [
          Column(
            children: [
              Padding(
                padding:EdgeInsets.all(width*0.05),
                child: InkWell(
                  onTap: () {
                    scaffoldkey.currentState?.openDrawer();
                  },
                  child: CircleAvatar(
                    radius: width*0.06,
                    backgroundImage: AssetImage(ImageConstant.user_profile),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.all(width*0.03),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Featured Jobs",
                    style: TextStyle(
                        fontSize: width*0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  Text("see all",
                    style: TextStyle(
                        fontSize: width*0.03,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
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
                          ),
                        ),
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Recommended Jobs",
                      style: TextStyle(
                          fontSize: width*0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text("see all",
                      style: TextStyle(
                        fontSize: width*0.03,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: height*0.5,
                width: width*0.9,
                child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        height: height*0.15,
                        width: width*0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width*0.03),
                          color: ColorConstant.primaryColor,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: height*0.01,);
                    },
                    itemCount: 5
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
