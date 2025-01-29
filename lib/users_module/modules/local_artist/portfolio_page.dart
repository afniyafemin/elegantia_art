import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/users_module/modules/local_artist/portfolio_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  List<Map<String, dynamic>> _portfolioItems = []; // List to hold portfolio data

  @override
  void initState() {
    super.initState();
    fetchPortfolioData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchPortfolioData() async {
    String userId = FirebaseAuth.instance.currentUser !.uid; // Get the current user ID
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('portfolio')
        .get();

    setState(() {
      _portfolioItems = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(); // Convert documents to a list of maps
    });
  }

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
                  Positioned(
                    top: height * 0.165,
                    left: width * 0.4,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: ColorConstant.secondaryColor,
                              content: Text("add new portfolio ? "),
                              actions: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      width: width * 0.15,
                                      height: height * 0.03,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.primaryColor,
                                          borderRadius: BorderRadius.circular(width * 0.03)),
                                      child: Center(child: Text("cancel",
                                        style: TextStyle(
                                            color: ColorConstant.secondaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width * 0.03
                                        ),
                                      ))
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PortfolioTemplate()));
                                  },
                                  child: Container(
                                      width: width * 0.15,
                                      height: height * 0.03,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.primaryColor,
                                          borderRadius: BorderRadius.circular(width * 0.03)),
                                      child: Center(child: Text("add",
                                        style: TextStyle(
                                            color: ColorConstant.secondaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width * 0.03
                                        ),
                                      ))
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(3, 3),
                          )
                        ]),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: ColorConstant.secondaryColor.withOpacity(0.5),
                          child: Icon(
                            Icons.add,
                            color: ColorConstant.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.7),
            itemCount: _portfolioItems.length,
            itemBuilder: (BuildContext context, int index) {
              var item = _portfolioItems[index];
              var imageUrls = item['images'] as List<dynamic>;

              return AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: EdgeInsets.all(width * 0.005),
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
                                height: height * 0.8,
                                width: width * 0.95,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: height * 0.01),
                                      child: Container(
                                        height: height * 0.3,
                                        width: width * 0.9,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrls[0]), // Display the first image
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(width * 0.02),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text("Work Name",
                                          style: TextStyle(
                                              color: ColorConstant.primaryColor.withOpacity(0.25)
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("${item['workName']}"), // Display work name
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Description",
                                          style: TextStyle(
                                              color: ColorConstant.primaryColor.withOpacity(0.25)
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: height * 0.1,
                                          width: width * 0.6,
                                          child: Text("${item['workDescription']}"), // Display description
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("More images of my work",
                                          style: TextStyle(
                                              color: ColorConstant.primaryColor.withOpacity(0.25)
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: height * 0.15,
                                      width: width * 0.8,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, imgIndex) {
                                          return Container(
                                            height: height * 0.15,
                                            width: width * 0.3,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(imageUrls[imgIndex]), // Display additional images
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, imgIndex) {
                                          return SizedBox(width: width * 0.03);
                                        },
                                        itemCount: imageUrls.length,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: ColorConstant.secondaryColor,
                                                  title: Text("Do you want to delete this portfolio?"),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          FirebaseFirestore.instance
                                                              .collection('users')
                                                              .doc(FirebaseAuth.instance.currentUser !.uid)
                                                              .collection('portfolio')
                                                              .doc(item['id']) // Use the document ID to delete
                                                              .delete();
                                                          _portfolioItems.removeAt(index);
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      child: Text("Delete",
                                                        style: TextStyle(
                                                            color: ColorConstant.primaryColor,
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancel",
                                                        style: TextStyle(
                                                            color: ColorConstant.primaryColor,
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: height * 0.05,
                                            width: width * 0.1,
                                            decoration: BoxDecoration(
                                                color: ColorConstant.primaryColor,
                                                borderRadius: BorderRadius.circular(width * 0.03)
                                            ),
                                            child: Icon(Icons.delete, color: ColorConstant.secondaryColor,),
                                          ),
                                        ),
                                        SizedBox(width: width * 0.02),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PortfolioTemplate()));
                                          },
                                          child: Container(
                                            height: height * 0.05,
                                            width: width * 0.1,
                                            decoration: BoxDecoration(
                                                color: ColorConstant .primaryColor,
                                                borderRadius: BorderRadius.circular(width * 0.03)
                                            ),
                                            child: Icon(Icons.edit, color: ColorConstant.secondaryColor,),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(imageUrls[0]), // Display the first image
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}