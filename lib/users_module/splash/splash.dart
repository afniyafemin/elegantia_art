
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/login_signup/login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState(){
    Future.delayed(
        Duration(seconds: 4)
    ).then((value)=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Login(),)));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: Center(
        child: Text("Elegantia",
          style: TextStyle(
            fontSize: width*0.1,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
