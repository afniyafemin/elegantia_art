import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class CatelogsNewUi extends StatefulWidget {
  const CatelogsNewUi({super.key});

  @override
  State<CatelogsNewUi> createState() => _CatelogsNewUiState();
}

class _CatelogsNewUiState extends State<CatelogsNewUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: height * 0.35,
                width: width * 1,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(width*0.35),
                  )
                ),
              ),
              Center(
                child: Padding(
                  padding:EdgeInsets.only(top: height*0.25),
                  child: Container(
                    height: height*0.725,
                    width: width*0.8,
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: height*0.15,
                                    width: width*0.7,
                                    decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.circular(width*0.05)
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: height*0.03,);
                                },
                                itemCount: 10
                            )
                        )
                      ],
                    ),
                    // color: Colors.white,
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
