import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/components/custom_drawer.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/services/chatting/chat_page.dart';
import 'package:elegantia_art/services/search/search_jobs.dart';
import 'package:elegantia_art/services/search/search_products.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/fetch_jobs.dart';


class JobPortal extends StatefulWidget {
  const JobPortal({super.key});

  @override
  State<JobPortal> createState() => _JobPortalState();
}

class _JobPortalState extends State<JobPortal> {
  late Future<List<Map<String, dynamic>>> collaborationsFuture;
  late Future<List<Map<String, dynamic>>> topCollaborationsFuture;
  int currentIndex = 0;
  String profileImageUrl = ImageConstant.aesthetic_userprofile;

  @override
  void initState() {
    super.initState();
    topCollaborationsFuture = fetchTopJobs();
    collaborationsFuture = fetchCollaborationData(); // Fetch collaboration data once
    _fetchCurrentUserName();
  }

  String? currentUserName;

  Future<void> _fetchCurrentUserName() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            currentUserName = userDoc['username']; // Assuming 'username' is a field in the user document
            profileImageUrl = userDoc['profileImage'] ?? "";
          });
        } else {
          print("User  document does not exist.");
        }
      } catch (error) {
        print("Error fetching user name: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load user name. Please try again.")),
        );
      }
    } else {
      print("No user is currently signed in.");
    }
  }




  Future<List<Map<String, dynamic>>> fetchCollaborationData() async {
    final collaborationDocs = await FirebaseFirestore.instance.collection('collaborations').get();

    List<Map<String, dynamic>> collaborations = [];

    for (var doc in collaborationDocs.docs) {
      final jobId = doc.get('jobId'); // Get jobId from the collaboration document
      final orderDoc = await FirebaseFirestore.instance.collection('orders').where('orderId', isEqualTo: jobId).get();

      if (orderDoc.docs.isNotEmpty) {
        collaborations.add({
          'collaboration': doc.data(),
          'order': orderDoc.docs.first.data(), // Get the first matching order
        });
      } else {
        // Handle case when no order data is found
        collaborations.add({
          'collaboration': doc.data(),
          'order': {}, // Empty order data when no matching order is found
        });
      }
    }

    return collaborations;
  }

  Future<void> applyForJob(String userId, String jobId, double amount) async {
    final requestedJobsCollection = FirebaseFirestore.instance.collection('requestedJobs');

    try {
      await requestedJobsCollection.add({
        'userId': userId,
        'jobId': jobId,
        'amount': amount,
      });
      print("Job applied successfully!");
    } catch (e) {
      print("Error applying for job: $e");
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(scaffoldKey: scaffoldKey),
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leadingWidth: width * 0.8,
        backgroundColor: ColorConstant.secondaryColor,
       // toolbarHeight: height * 0.1,
        automaticallyImplyLeading: false,
        leading: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left : width*0.05, top: height*0.015),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: CircleAvatar(
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : AssetImage(ImageConstant.aesthetic_userprofile) as ImageProvider,
                    ),
                  ),
                  SizedBox(width: width*0.03,),
                  Text(
                    currentUserName ?? "User ",
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w900,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        // actions: [
        //   Padding(
        //     padding:  EdgeInsets.only(right: width*0.03),
        //     child: GestureDetector(
        //       onTap: () {
        //         showSearch(context: context, delegate: CustomSearchDelegate());
        //       },
        //         child: Icon(Icons.search,color: ColorConstant.primaryColor,size: width*0.075,)
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(),));
                },
                child: Column(
                  children: [
                    Text('''Interact with us ''',
                      style: TextStyle(
                        fontSize: width*0.075,
                        fontWeight: FontWeight.w900,
                        color: ColorConstant.primaryColor.withOpacity(0.5)
                      ),
                    ),
                    Text(''' to know more about the reward ''',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ColorConstant.primaryColor.withOpacity(0.25),
                          fontSize: width*0.03
                      ),
                    ),
                    SizedBox(height: height*0.025,)
                  ],
                ),
              ),

              TextField(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: JobSearchDelegate(),
                  );
                },
                cursorColor: ColorConstant.primaryColor,
                decoration: InputDecoration(
                  hintText: "Search for jobs",
                  hintStyle: TextStyle(
                      color: ColorConstant.primaryColor.withOpacity(0.3)
                  ),
                  prefixIcon: Icon(Icons.search, color: ColorConstant.primaryColor),
                  filled: true,
                  fillColor: ColorConstant.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    borderSide: BorderSide(
                        color: ColorConstant.primaryColor
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    borderSide: BorderSide(
                        color: ColorConstant.primaryColor
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    borderSide: BorderSide(
                        color: ColorConstant.primaryColor
                    ),
                  ),

                ),
              ),
              SizedBox(
                height: height*0.01,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: topCollaborationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No jobs available."));
                  } else {
                    final collaborations = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.01),
                        Padding(
                          padding: EdgeInsets.only(left: width*0.015),
                          child: Text(
                            "Featured Jobs",
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CarouselSlider.builder(
                          itemCount: collaborations.length,
                          itemBuilder: (context, index, realIndex) {
                            // Null checks before accessing the data
                            final collaboration = collaborations[index]['collaboration'];
                            final orderData = collaborations[index]['order'];

                            if (collaboration == null || orderData == null) {
                              return Container();  // If data is null, return an empty container (or some placeholder)
                            }

                            final job = collaboration;  // Safely access 'collaboration' data
                            final order = orderData;    // Safely access 'order' data

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobInfo(
                                      jobId: job['jobId'] ?? '', // Safely pass jobId
                                      productName: order['productName'] ?? 'N/A', // Safely access productName
                                      category: order['category'] ?? 'N/A', // Safely access category
                                      amount: job['amount'] ?? 0.0, // Safely access amount
                                      customizationText: order['customizationText'] ?? 'N/A', // Safely access customizationText
                                      customizationImages: order['customizationImages'] ?? '', // Safely access customizationImage
                                      date: order['orderDate'] ?? 'N/A', // Safely access orderDate
                                      address: orderData['address'] ?? [],
                                        imageUrl: orderData['imageUrl'] ?? 'N/A'
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(order['imageUrl']), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(width * 0.03),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                  width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(width * 0.04),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${order['productName'] ?? 'N/A'}", // Safely access jobId
                                        style: TextStyle(
                                          color: ColorConstant.secondaryColor,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black87,
                                              offset: Offset(0, 2),
                                              blurRadius: 2,
                                            ),
                                          ],
                                          fontSize: width * 0.07,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      //SizedBox(height: height * 0.01),
                                      Text(
                                        "Amount: ₹${job['amount']?.toString() ?? 'N/A'}", // Safely handle amount display
                                        style: TextStyle(
                                          shadows: [
                                            Shadow(
                                              color: ColorConstant.primaryColor,
                                              offset: Offset(0, 2),
                                              blurRadius: 2,
                                            ),
                                          ],
                                          fontSize: width * 0.04,
                                          color: ColorConstant.secondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            autoPlay: true,
                            height: height * 0.3,
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                        ),

                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: height*0.02,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: collaborationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final collaborations = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recommended Jobs",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        height: (height * 0.15) * (collaborations.length) + (height * 0.05),
                        width: width * 0.9,
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {

                            final collaborationData = collaborations[index]['collaboration'];
                            final orderData = collaborations[index]['order'];

                            return Container(
                              height: height * 0.15,
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width * 0.03),
                                color: ColorConstant.primaryColor.withOpacity(0.2),
                                border: Border.all(
                                  color: ColorConstant.primaryColor.withOpacity(0.2),
                                  width: 1,

                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(width * 0.03),
                                child: Row(
                                  children: [
                                    Container(
                                      height: height * 0.12,
                                      width: width * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(width * 0.02),
                                        image: DecorationImage(image: NetworkImage(orderData['imageUrl']), fit: BoxFit.cover),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.025),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Product Name: ${orderData['productName'] ?? 'N/A'}", // Fetch product name from order data
                                            style: TextStyle(
                                              color: ColorConstant.primaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "Category: ${orderData['category'] ?? 'N/A'}", // Fetch category from order data
                                            style: TextStyle(
                                              color: ColorConstant.primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: width*0.03
                                            ),
                                          ),
                                          Text(
                                            "Amount: \$${collaborationData['amount']?.toString() ?? 'N/A'}",
                                            style: TextStyle(
                                              color: ColorConstant.primaryColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: width*0.03
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap : (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => JobInfo(
                                              productName: orderData['productName'] ?? 'N/A',
                                              category: orderData['category'] ?? 'N/A',
                                              amount: collaborationData['amount'] ?? 0.0,
                                              customizationText: orderData['customizationText'] ?? 'N/A',
                                              customizationImages: orderData['customizationImages'] ?? '',
                                              date: orderData['orderDate'] ?? 'N/A',
                                              jobId: collaborationData['jobId'] ?? '',
                                              address: orderData['address'] ?? [],
                                              imageUrl: orderData['imageUrl'] ?? 'N/A'
                                            ),));
                                          },

                                          child: Container(
                                            height: height*0.03,
                                            width: width*0.15,
                                            decoration: BoxDecoration(
                                              color: ColorConstant.primaryColor,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Apply",
                                                style: TextStyle(
                                                    color: ColorConstant.secondaryColor,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 10
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: height * 0.01);
                          },
                          itemCount: collaborations.length,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

