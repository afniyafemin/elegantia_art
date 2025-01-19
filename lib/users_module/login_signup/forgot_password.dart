import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // To show loading indicator

  Future<void> handleForgotPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      String email = emailController.text.trim();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset email sent. Check your inbox!")),
        );
        Navigator.pop(context); // Return to the login screen
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send reset email: ${e.message}")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.bg),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height*0.15,),
                // Email input and reset button
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(width*0.05)
                  ),
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
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
                            cursorColor: ColorConstant.primaryColor,
                            cursorHeight: height*0.02,
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.email,
                                color: ColorConstant.primaryColor,
                                size: MediaQuery.of(context).size.height * 0.02,
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: handleForgotPassword,
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width*0.05),
                            color: ColorConstant.primaryColor,
                          ),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              "RESET PASSWORD",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                          "Remember your password?",
                          style: TextStyle(color: ColorConstant.primaryColor),
                        ),
                        Text(
                          "Go back to Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
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
      ),
    );
  }
}
