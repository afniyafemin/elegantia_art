import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class AcceptedJobs extends StatefulWidget {
  const AcceptedJobs({super.key});

  @override
  State<AcceptedJobs> createState() => _AcceptedJobsState();
}

class _AcceptedJobsState extends State<AcceptedJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top:width*0.007, left: width*0.02, right: width*0.02),
              child: Container(
                height: height*0.1,
                decoration: BoxDecoration(
                  color: ColorConstant.secondaryColor,
                  borderRadius: BorderRadius.circular(width*0.02),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstant.primaryColor.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: ListTile(
                    title: Text("Job Name"),
                    subtitle: Text("DeadLine"),
                    trailing: Container(
                      height: height*0.05,
                      width: width*0.2,
                      decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.circular(width*0.03),
                      ),
                      child: Center(child: Text("Accepted",
                        style: TextStyle(
                          color: ColorConstant.secondaryColor,

                        ),
                      )),
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
