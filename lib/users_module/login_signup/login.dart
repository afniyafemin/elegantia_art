import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/services/google_signup.dart';
import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
//import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
import 'package:elegantia_art/users_module/modules/module.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const Login({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

bool pass = true;

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false; // To show loading indicator

  void handleGoogleSignIn(BuildContext context) async {
    try {
      User? user = await SigninWithGoogle(context);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ModuleDivision()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In failed or was canceled.")),
        );
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }



  Future<void> handleEmailPasswordSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        // Attempt to sign in with email and password (assuming Firebase is configured)
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerNavbar()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width * 1,
              height: height * 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.bg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.all(width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height*0.15,),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width*0.05),
                        color: Colors.white.withOpacity(0.45),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.6,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: ColorConstant.primaryColor.withOpacity(0.4),
                                      ),
                                      bottom: BorderSide(
                                        color: ColorConstant.primaryColor.withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your email";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.person,
                                        color: ColorConstant.primaryColor,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: height * 0.015),
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.6,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: ColorConstant.primaryColor
                                            .withOpacity(0.4),
                                      ),
                                      bottom: BorderSide(
                                        color: ColorConstant.primaryColor
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: passwordController,
                                    obscureText: pass,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter a strong password";
                                      } else if (value.length < 8) {
                                        return "Password length should be more than 8 characters";
                                      }
                                      return null;
                                    },
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
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: handleEmailPasswordSignIn,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.55,
                              decoration: BoxDecoration(
                                color: ColorConstant.primaryColor,
                                borderRadius: BorderRadius.circular(width*0.05)
                              ),
                              child: Center(
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgotPassword()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              // Text("Sign in with", textAlign: TextAlign.center),
                              InkWell(
                                onTap: () => handleGoogleSignIn(context),
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.5,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primaryColor,
                                      borderRadius: BorderRadius.circular(width*0.05)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.g_mobiledata_rounded,size: width*0.1 ,color: ColorConstant.secondaryColor,),
                                      isLoading
                                          ? CircularProgressIndicator(
                                          color: Colors.white)
                                          : Text(
                                        "sign in with GOOGLE",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: width * 0.03,
                                          color: ColorConstant.secondaryColor,
                                        ),
                                      ),
                                      SizedBox(width: width*0.05,)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height*0.015,),
                              InkWell(
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.5,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primaryColor,
                                      borderRadius: BorderRadius.circular(width*0.05)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.phone,color: ColorConstant.secondaryColor,),
                                      isLoading
                                          ? CircularProgressIndicator(
                                          color: Colors.white)
                                          : Text(
                                        "sign in with OTP",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize:width * 0.03,
                                          color: ColorConstant.secondaryColor,
                                        ),
                                      ),
                                      SizedBox(width: width*0.05,)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Container(
                        height:height * 0.055,
                        width: width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(width*0.05)
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Don't have an account?",
                              style:
                              TextStyle(color: ColorConstant.primaryColor),
                            ),
                            Text(
                              "Create New",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: width * 0.03,
                                color: ColorConstant.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
