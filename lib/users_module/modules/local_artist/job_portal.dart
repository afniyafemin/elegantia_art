import 'package:carousel_slider/carousel_slider.dart';
import 'package:elegantia_art/components/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constants/color_constant.dart';
import '../../../constants/image_constants/image_constant.dart';
import '../../../main.dart';

class JobPortal extends StatefulWidget {
  const JobPortal({super.key});

  @override
  State<JobPortal> createState() => _JobPortalState();
}

class _JobPortalState extends State<JobPortal> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(scaffoldKey: scaffoldKey),
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        leadingWidth: width * 0.8,
        backgroundColor: ColorConstant.primaryColor,
        toolbarHeight: height * 0.2,
        automaticallyImplyLeading: false,
        leading: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: CircleAvatar(
                      radius: width * 0.06,
                      backgroundImage: AssetImage(ImageConstant.user_profile),
                    ),
                  ),
                ),
                Text(
                  "John",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w900,
                    color: ColorConstant.secondaryColor,
                  ),
                ),
              ],
            ),
            // Search TextField
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: TextField(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
                decoration: InputDecoration(
                  hintText: "Search for jobs or products",
                  prefixIcon: Icon(Icons.search, color: ColorConstant.primaryColor),
                  filled: true,
                  fillColor: ColorConstant.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Jobs",
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "see all",
                    style: TextStyle(
                      fontSize: width * 0.03,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              CarouselSlider.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Stack(
                    children: [
                      Container(
                        height: height * 0.3,
                        width: width * 0.88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          color: ColorConstant.primaryColor,
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  height: height * 0.3,
                  autoPlayAnimationDuration: Duration(seconds: 4),
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index; // Fixed variable name
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommended Jobs",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "see all",
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: height * 0.5,
                width: width * 0.9,
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: height * 0.15,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        color: ColorConstant.primaryColor,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height * 0.01);
                  },
                  itemCount: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    "Ring album",
    "Journals",
    "Resin",
    "Charm",
    "Stamps",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: ColorConstant.primaryColor),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back, color: ColorConstant.primaryColor),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = searchTerms
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
      color: ColorConstant.secondaryColor,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = searchTerms
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
      color: ColorConstant.secondaryColor,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        },
      ),
    );
  }
}