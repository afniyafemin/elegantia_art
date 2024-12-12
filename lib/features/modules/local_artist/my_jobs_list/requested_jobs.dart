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
        backgroundColor: ColorConstant.secondaryColor,
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                  top: width * 0.007, left: width * 0.02, right: width * 0.02),
              child: Container(
                height: height * 0.1,
                decoration: BoxDecoration(
                  color: ColorConstant.secondaryColor,
                  borderRadius: BorderRadius.circular(width * 0.02),
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
                    trailing: Container(
                      height: height * 0.05,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.circular(width * 0.03),
                      ),
                      child: InkWell(
                        onTap: () {
                          _showCancelRequestAlert(context);
                        },
                        child: Center(child: Text("requested",
                          style: TextStyle(
                            color: ColorConstant.secondaryColor,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }


  void _showCancelRequestAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorConstant.secondaryColor,
          title: const Text('Cancel Request?'),
          content: const Text('Are you sure you want to cancel this request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No',style: TextStyle(color: ColorConstant.primaryColor),),
            ),
            TextButton(
              onPressed: () {
                // Add your cancel request logic here
                Navigator.of(context).pop();
              },
              child: const Text('Yes',style: TextStyle(color: ColorConstant.primaryColor)),
            ),
          ],
        );
      },
    );
  }
}