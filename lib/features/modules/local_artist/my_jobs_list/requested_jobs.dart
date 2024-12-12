import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class RequestedJobs extends StatefulWidget {
  const RequestedJobs({super.key});

  @override
  State<RequestedJobs> createState() => _RequestedJobsState();
}

class _RequestedJobsState extends State<RequestedJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Job Name"),
              trailing: Container(
                height: height*0.03,
                width: width*0.2,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.circular(width*0.03),
                ),
                child: Center(child: Text("requested",
                  style: TextStyle(
                    color: ColorConstant.secondaryColor,

                  ),
                )),
              ),
            ),
          );
        },
      )
    );
  }
}
