
import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/core/image_constants/image_constant.dart';
import 'package:elegantia_art/features/login_signup/login.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        elevation: 0,
        leading: Container(),
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: ColorConstant.secondaryColor,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
            },
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: width*0.2,
                  backgroundImage: AssetImage(ImageConstant.user_profile),
                ),
                SizedBox(height: height*0.01,),
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ProfileInfoRow(label: 'email', value: 'user123@gmail.com'),
                ProfileInfoRow(
                    label: 'address',
                    value: 'kalliparambil house,\nkunnappally post,'),
                ProfileInfoRow(label: 'phone', value: '9188292482'),
                SizedBox(height: 40),
                Text(
                  'CREDITS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 250,
                  height: 25,
                  decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: ColorConstant.primaryColor.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )]
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.4, // Change to reflect current points
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('0'),
                    Text('50'),
                    Text('100'),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: 'Current points: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: '40/100',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        TextSpan(
                            text:
                            '\n\nThe more you buy the products from us will get your points to increase, which is useful for your next purchase as it reduce the cost, happy shopping!'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

