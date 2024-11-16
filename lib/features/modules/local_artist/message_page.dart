
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/core/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        title: Text("MESSAGES",style: TextStyle(
          color: ColorConstant.secondaryColor,
          fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
      ),
      backgroundColor: ColorConstant.secondaryColor,
      body:
      Padding(
        padding:  EdgeInsets.all(width*0.04),
        child: GridView.count(
          shrinkWrap: true, // add this
          crossAxisCount: 3,// number of columns
          mainAxisSpacing: 10.0, // add this
          crossAxisSpacing: 10.0, // add this
          children: List.generate(20, (index) { // generate 10 CircleAvatar widgets
            return Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(ImageConstant.user_profile),
                  radius: width*0.1,
                ),
                Text("Username")
              ],
            );
          }),
        ),
      ),
    );
  }
}
