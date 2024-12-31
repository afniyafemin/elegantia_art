

import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/login_signup/otp_login.dart';
import 'package:elegantia_art/users_module/login_signup/signup.dart';
import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/sign_in_method.dart';

class Login extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const Login({super.key, required this.showRegisterPage});
  @override
  State<Login> createState() => _LoginState();
}

bool pass = true;

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  // void signUserIn()async{
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text,
  //       password: passwordController.text
  //   );
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 1,
              width: width * 1,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageConstant.bg), fit: BoxFit.fill)),
              child: Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: height * 0.2,
                      width: width * 0.75,
                      child: Text(
                        "Timeless beauty \n and \n cherished memories \n are both stitched \n with love \n and \n elegance",
                        style: TextStyle(color: ColorConstant.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: height * 0.5,
                      width: width * 0.75,
                      color: Colors.white.withOpacity(0.45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.55,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorConstant.primaryColor
                                                  .withOpacity(0.4)),
                                          bottom: BorderSide(
                                              color: ColorConstant.primaryColor
                                                  .withOpacity(0.4)))),
                                  child: TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      final regExp = RegExp(
                                          r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your email";
                                      } else if (!regExp.hasMatch(value)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.person,
                                          color: ColorConstant.primaryColor,
                                          size: height * 0.02,
                                        ),
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(fontSize: width * 0.03),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.55,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorConstant.primaryColor
                                                  .withOpacity(0.4)),
                                          bottom: BorderSide(
                                              color: ColorConstant.primaryColor
                                                  .withOpacity(0.4)))),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter a strong password";
                                      } else if (value.length < 8) {
                                        return "Password length should be more than 8 characters";
                                      }
                                      return null;
                                    },
                                    controller: passwordController,
                                    obscureText: pass ? true : false,
                                    decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                pass = !pass;
                                              });
                                            },
                                            child: Icon(
                                              pass
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: ColorConstant.primaryColor,
                                              size: height * 0.02,
                                            )),
                                        hintText: "password",
                                        hintStyle:
                                            TextStyle(fontSize: width * 0.03),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                signIn(emailController.text, passwordController.text);
                              });
                            },
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.55,
                              color:
                                  ColorConstant.primaryColor.withOpacity(0.65),
                              child: Center(
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.03,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Forgot Password ?",
                            textAlign: TextAlign.end,
                          ),
                          Column(
                            children: [
                              Text(
                                "Sign in with",
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height * 0.04,
                                    width: width * 0.075,
                                    decoration: BoxDecoration(
                                        // image: DecorationImage(image: AssetImage(ImageConstant.google_logo)),
                                        color: ColorConstant.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.03)),
                                    child: Icon(
                                      Icons.g_mobiledata_sharp,
                                      size: width * 0.08,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OtpLogin(),
                                          ));
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: height * 0.04,
                                      width: width * 0.075,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                              width * 0.03)),
                                      child: Icon(Icons.phone),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Container(
                        height: height * 0.15,
                        width: width * 0.75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have an accout ?",
                              style: TextStyle(color: ColorConstant.primaryColor),
                            ),
                            Text(
                              "Create New",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: width * 0.03,
                                  color: ColorConstant.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
