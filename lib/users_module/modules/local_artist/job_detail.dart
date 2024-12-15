
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class JobInfo extends StatefulWidget {
  const JobInfo({super.key});

  @override
  State<JobInfo> createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  // List<Map> portfolio =[
  //   {
  //     "job name" : "first job",
  //     "deadline" : "15-12-2024"
  //   },
  //   {
  //     "job name" : "second job",
  //     "deadline" : "15-12-2024"
  //   },
  //   {
  //     "job name" : "3rd job",
  //     "deadline" : "15-12-2024"
  //   },
  //   {
  //     "job name" : "4th job",
  //     "deadline" : "15-12-2024"
  //   },
  //   {
  //     "job name" : "5th job",
  //     "deadline" : "15-12-2024"
  //   },
  //
  // ];
  int count=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height*0.5,
            width: width*1,
            child: Image.asset("asset/images/Product_1.jpg",
            fit: BoxFit.cover,)),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: ColorConstant.secondaryColor,
                child:Icon(Icons.arrow_back)
                //BackdropFilter(filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
              maxChildSize: 1.0,
              minChildSize: 0.6,
              builder: (context,scrollController){
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      color: ColorConstant.secondaryColor ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      //realpart ,product details
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(height*0.02),
                              color: ColorConstant.primaryColor.withOpacity(0.5)
                            ),
                            child: Text("Send Portfolio"),
                          )
                        ],
                      )
                    ),
                  ),
                );
          })
        ],
      ),
    );
  }
}
