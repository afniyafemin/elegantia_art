
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/features/login_signup/login.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
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
        title: Text("Categories",style: TextStyle(
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
                child: ListView.builder(itemBuilder: (context, index) {
                  return Card(
                    color: ColorConstant.secondaryColor.withOpacity(0.7),
                    child: ListTile(
                      title: Text("HEllo"),
                    ),
                  );
                } ,
                    itemCount: 15),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
