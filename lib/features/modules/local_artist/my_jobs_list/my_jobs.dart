import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/features/modules/local_artist/my_jobs_list/Accepted_jobs.dart';
import 'package:elegantia_art/features/modules/local_artist/my_jobs_list/requested_jobs.dart';
import 'package:elegantia_art/main.dart';
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
          appBar: AppBar(
            backgroundColor: ColorConstant.secondaryColor,
            title: Text("My Jobs"),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: ColorConstant.primaryColor,
                tabs: [
              Text("Requested",
                style: TextStyle(
                  color: ColorConstant.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: width*0.04
                ),
              ),
              Text("Accepted",
                style: TextStyle(
                    color: ColorConstant.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: width*0.04
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
