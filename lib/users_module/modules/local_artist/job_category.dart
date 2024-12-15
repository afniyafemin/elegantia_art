import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/core/image_constants/image_constant.dart';
import 'package:elegantia_art/features/modules/local_artist/job_catelogs.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';
String j="";


class JobCategoryPage extends StatefulWidget {
  const JobCategoryPage({super.key});

  @override
  State<JobCategoryPage> createState() => _JobCategoryPageState();
}

class _JobCategoryPageState extends State<JobCategoryPage> {

  List categories=[
    "Paper Crafts",
    "Resin Art",
    "Digital Crafts",
    "Mixed Media Crafts",
    "Other Creative Ideas"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)
        ),
        backgroundColor: ColorConstant.primaryColor,
        title: Text("Job Categories",style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstant.secondaryColor
        ),),
        centerTitle: true,
        actions: [Icon(
          Icons.search_sharp,size: width*0.07,
          color: Colors.black,
        ),
          SizedBox(
            width: Checkbox.width*0.5,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width*0.05),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemBuilder: (BuildContext context , index){
                    return InkWell(
                      onTap: () {
                        j=categories[index];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => JobCatelogs(),));
                        setState(() {

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: height*0.2,
                          width: width*0.2,
                          decoration: BoxDecoration(
                            color: ColorConstant.primaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(width*0.03),
                            image: DecorationImage(
                                image: AssetImage(
                                    ImageConstant.product2
                                ),fit: BoxFit.cover,
                              opacity: 0.5
                            )
                          ),
                          child: Center(
                            child: Text(categories[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: width*0.03,
                                  color: ColorConstant.secondaryColor,

                              ),),
                          ),
                        ),
                      ),
                    );
                  },
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2))
              ),

            ],
          ),
        ),
      ),
    );
  }
}
