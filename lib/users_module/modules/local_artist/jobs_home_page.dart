import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/components/custom_drawer.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class JobPortal extends StatefulWidget {
  const JobPortal({super.key});

  @override
  State<JobPortal> createState() => _JobPortalState();
}

class _JobPortalState extends State<JobPortal> {
  Future<Map<String , dynamic>> fetchCollaborationData() async {

    final collabId = await FirebaseFirestore.instance.collection('collaborations').doc('jobId').get();

    if (collabId == null) {
      return {};
    }

    final collabDoc = await FirebaseFirestore.instance.collection('orders')
    .where('orderId', isEqualTo: collabId).get();

    return collabDoc as Map<String , dynamic>;

  }

  Future<void> applyForJob(String userId, String jobId, double amount) async {
    final requestedJobsCollection = FirebaseFirestore.instance.collection('requestedJobs');

    try {
      await requestedJobsCollection.add({
        'userId' : FirebaseAuth.instance.currentUser!.uid,
        'jobId': jobId,
        'amount' : amount
      });
      print("Job applied successfully!");
    } catch (e) {
      print("Error applying for job: $e");
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  late List<Map<String , dynamic>> data =[{}] ;

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
                    borderRadius: BorderRadius.circular(width * 0.03),
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
                children: [
                  Text(
                    "Featured Jobs",
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
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
                      currentIndex = index;
                    });
                  },
                ),
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
              Container(
                height: (height * 0.15)*(data.length)+(height*0.05),
                width: width * 0.9,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: fetchCollaborationData(),
                  builder: (context, snapshot) {

                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return Center(child: CircularProgressIndicator());
                    // }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    data = snapshot.data! as List<Map<String, dynamic>>;

                    return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = data[index];

                        return Container(
                          height: height * 0.15,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.03),
                            color: ColorConstant.primaryColor,
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
                                    image: DecorationImage(image: AssetImage(ImageConstant.product1),fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(width: width * 0.025),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Category: ${item['category'] ?? 'N/A'}",
                                        style: TextStyle(
                                          color: ColorConstant.secondaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Amount: ${item['amount']?.toString() ?? 'N/A'}",
                                        style: TextStyle(
                                          color: ColorConstant.secondaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          String userId = FirebaseAuth.instance.currentUser!.uid; // Replace with actual user ID
                                          String jobId = item['jobId'] ?? ''; // Ensure jobId is not null
                                          double amount;

                                          // Check if amount is a String and convert it to double
                                          if (item['amount'] is String) {
                                            amount = double.tryParse(item['amount']) ?? 0.0;
                                          } else {
                                            amount = item['amount'] ?? 0.0; // Get the amount
                                          }

                                          if (jobId.isNotEmpty) {
                                            applyForJob(userId, jobId, amount);
                                          } else {
                                            print("Job ID is null or empty");
                                          }
                                        },
                                        child: Text(
                                          "Apply",
                                          style: TextStyle(
                                            color: ColorConstant.secondaryColor,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: height * 0.01);
                      },
                      itemCount: data.length,
                    );
                  },
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
    "Res in",
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