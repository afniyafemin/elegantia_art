
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/local_artist/my_jobs_list/Accepted_jobs.dart';
import 'package:elegantia_art/users_module/modules/local_artist/my_jobs_list/requested_jobs.dart';
import 'package:flutter/material.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({super.key});

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false,
            backgroundColor: ColorConstant.primaryColor,
            title: Text("My Jobs",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.secondaryColor
              ),),
            centerTitle: true,
            bottom: TabBar(
//              indicatorSize: height*0.02,
                indicatorColor: ColorConstant.primaryColor,
                tabs: [
                  Container(
                    height: height*0.04,
                    child: Text("Requested",
                      style: TextStyle(
                          color: ColorConstant.secondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: width*0.04
                      ),
                    ),
                  ),
                  Container(
                    height: height*0.04,
                    child: Text("Accepted",
                      style: TextStyle(
                          color: ColorConstant.secondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: width*0.04
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              RequestedJobs(),
              AcceptedJobs()
            ],
          ),
        )
    );
  }
}
