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
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text("Job Name"),
                subtitle: Text("dead line"),
                trailing: Container(
                  height: height*0.03,
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
            );
          },
        )
    );
  }
}
