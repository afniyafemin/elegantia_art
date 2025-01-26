import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/components/custom_drawer.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/services/chatting/chat_page.dart';
import 'package:elegantia_art/services/search/search_products.dart';
import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_catelogs.dart';
import 'package:elegantia_art/users_module/modules/local_artist/job_detail.dart';
import 'package:elegantia_art/users_module/modules/local_artist/message_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class JobPortal extends StatefulWidget {
  const JobPortal({super.key});

  @override
  State<JobPortal> createState() => _JobPortalState();
}

class _JobPortalState extends State<JobPortal> {
  late Future<List<Map<String, dynamic>>> collaborationsFuture;
  late Future<List<Map<String, dynamic>>> topCollaborationsFuture;
  int currentIndex = 0;

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

  Future<List<Map<String, dynamic>>> fetchTopJobs() async {
    // Fetch all jobs and sort by amount in descending order, then take the top 5
    final querySnapshot = await FirebaseFirestore.instance
        .collection('collaborations')
        .orderBy('amount', descending: true)
        .limit(5)
        .get();

    List<Map<String, dynamic>> topJobs = [];

    for (var doc in querySnapshot.docs) {
      final jobId = doc.get('jobId'); // Get jobId from the collaboration document

      // Fetch the corresponding order document based on the jobId
      final orderDoc = await FirebaseFirestore.instance.collection('orders').where('orderId', isEqualTo: jobId).get();

      if (orderDoc.docs.isNotEmpty) {
        // If an order exists for the jobId, add the collaboration and order data
        topJobs.add({
          'collaboration': doc.data(),
          'order': orderDoc.docs.first.data(), // Get the first matching order
        });
      } else {
        // Handle case when no order data is found, add empty order data
        topJobs.add({
          'collaboration': doc.data(),
          'order': {}, // Empty order data when no matching order is found
        });
      }
    }

    return topJobs;
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
                      radius: width * 0.04,
                      backgroundImage: AssetImage(ImageConstant.user_profile),
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
                    delegate: CustomSearchDelegate(),
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
                height: height*0.02,
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
                      children: [
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.05),
                              child: Text(
                                "Featured Jobs",
                                style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
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
                                      customizationImage: order['customizationImage'] ?? '', // Safely access customizationImage
                                      date: order['orderDate'] ?? 'N/A', // Safely access orderDate
                                      address: orderData['address'] ?? [],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(ImageConstant.product2), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(width * 0.03),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(width * 0.04),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Job ID: ${job['jobId'] ?? 'N/A'}", // Safely access jobId
                                        style: TextStyle(
                                          shadows: [
                                            Shadow(
                                              color: ColorConstant.secondaryColor,
                                              offset: Offset(0, 2),
                                              blurRadius: 2,
                                            ),
                                          ],
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
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
                            viewportFraction: 0.8,
                            autoPlay: true,
                            height: height * 0.25,
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Recommended Jobs",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
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

                  return Container(
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
                                    image: DecorationImage(image: AssetImage(ImageConstant.product1), fit: BoxFit.cover),
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
                                          fontWeight: FontWeight.w200,
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
                                          customizationImage: orderData['customizationImage'] ?? '',
                                          date: orderData['orderDate'] ?? 'N/A',
                                          jobId: collaborationData['jobId'] ?? '',
                                          address: orderData['address'] ?? [],
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

