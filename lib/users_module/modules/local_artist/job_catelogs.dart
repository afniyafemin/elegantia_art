import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:flutter/material.dart';

class JobCatelogs extends StatefulWidget {
  final String category;

  const JobCatelogs({Key? key, required this.category}) : super(key: key);

  @override
  State<JobCatelogs> createState() => _JobCatelogsState();
}

class _JobCatelogsState extends State<JobCatelogs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isGridView = true;

  Future<List<Map<String, dynamic>>> _fetchJobs(String category) async {
    List<Map<String, dynamic>> jobs = [];
    try {
      // Get collaborations based on the category
      Query<Map<String, dynamic>> query = _firestore.collection('collaborations');
      if (category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      final collaborationsSnapshot = await query.get();

      for (var doc in collaborationsSnapshot.docs) {
        final jobId = doc.get('jobId'); // Get jobId from the collaboration document

        // Fetch the corresponding job details from the 'orders' collection
        final orderSnapshot = await _firestore
            .collection('orders')
            .where('orderId', isEqualTo: jobId)
            .get();

        if (orderSnapshot.docs.isNotEmpty) {
          jobs.add({
            'collaboration': doc.data(), // Add collaboration data
            'order': orderSnapshot.docs.first.data(), // Add the corresponding order data
          });
        }
      }
    } catch (error) {
      print("Error fetching jobs: $error");
    }

    return jobs; // Return the combined list of jobs and collaboration data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(MediaQuery.of(context).size.width * 0.35),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    widget.category,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: MediaQuery.of(context).size.height * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.1,
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
                      child: Icon(
                        isGridView ? Icons.list : Icons.grid_view_sharp,
                        color: ColorConstant.secondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.25,
            ),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchJobs(widget.category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No jobs available."));
                }

                final jobs = snapshot.data!;
                return isGridView
                    ? GridView.builder(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.03,
                  ),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return _buildJobCard(job);
                  },
                )
                    : ListView.builder(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return _buildJobListTile(job);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return GestureDetector(
      onTap: () {
        // Navigate to job details
      },
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorConstant.secondaryColor,
          boxShadow: [
            BoxShadow(
              color: ColorConstant.primaryColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 200,
              offset: Offset(5, 5),
            )
          ],
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageConstant.product2),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Text(
              job['name'],
              style: TextStyle(
                color: ColorConstant.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "₹${job['price']}",
              style: TextStyle(color: ColorConstant.primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobListTile(Map<String, dynamic> job) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.015),
      decoration: BoxDecoration(
        color: ColorConstant.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Image(image: AssetImage(ImageConstant.product2)),
        title: Text(job['name']),
        subtitle: Text("₹${job['price']}"),
        onTap: () {
          // Navigate to job details
        },
      ),
    );
  }
}
