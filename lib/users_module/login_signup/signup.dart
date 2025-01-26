


import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/sign_up_method.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUp({super.key, required this.showLoginPage});

  @override
  State<SignUp> createState() => _SignUpState();
}
bool pass=true;

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: height*1 ,
            width: width*1,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(ImageConstant.bg),fit: BoxFit.fill
              )
            ),
            child: Padding(
              padding:EdgeInsets.all(width*0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height*0.15,),
                  Container(
                    height: height*0.5,
                    width: width*0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width*0.05),
                      color: Colors.white.withOpacity(0.45),
                    ),                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(),
                        Column(
                          children: [
                            Container(
                              height: height*0.05,
                              width: width*0.7,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: ColorConstant.primaryColor.withOpacity(0.4)
                                  ),
                                  bottom: BorderSide(
                                    color: ColorConstant.primaryColor.withOpacity(0.4)
                                  )
                                )
                              ),
                              child: TextFormField(
                                cursorColor: ColorConstant.primaryColor,
                                cursorHeight: height*0.02,
                                controller: nameController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.person,color: ColorConstant.primaryColor,size: height*0.02,),
                                    hintText: "Username",
                                  hintStyle: TextStyle(
                                    fontSize: width*0.03
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                  )
                                ),
                              ),
                            ),
                            SizedBox(height: height*0.015,),
                            Container(
                              height: height*0.05,
                              width: width*0.7,
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      ),
                                      bottom: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      )
                                  )
                              ),
                              child: TextFormField(
                                cursorColor: ColorConstant.primaryColor,
                                keyboardType: TextInputType.emailAddress,
                                cursorHeight: height*0.02,
                                controller: emailController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.mail,color: ColorConstant.primaryColor,size: height*0.02,),
                                    hintText: "valid email",
                                    hintStyle: TextStyle(
                                        fontSize: width*0.03
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: height*0.015,),
                            Container(
                              height: height*0.05,
                              width: width*0.7,
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      ),
                                      bottom: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      )
                                  )
                              ),
                              child: TextFormField(
                                cursorColor: ColorConstant.primaryColor,
                                cursorHeight: height*0.02,
                                controller: passwordController,
                                obscureText: pass?true:false,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        pass=!pass;
                                      });
                                    },
                                      child: Icon(pass?Icons.visibility_off:Icons.visibility,color: ColorConstant.primaryColor,size: height*0.02,)
                                  ),
                                    hintText: "password",
                                    hintStyle: TextStyle(
                                        fontSize: width*0.03
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: height*0.015,),
                            Container(
                              height: height*0.05,
                              width: width*0.7,
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      ),
                                      bottom: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      )
                                  )
                              ),
                              child: TextFormField(
                                cursorColor: ColorConstant.primaryColor,
                                cursorHeight: height*0.02,
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            pass=!pass;
                                          });
                                        },
                                        child: Icon(pass?Icons.visibility_off:Icons.visibility,color: ColorConstant.primaryColor,size: height*0.02,)
                                    ),
                                    hintText: "confirm password",
                                    hintStyle: TextStyle(
                                        fontSize: width*0.03
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: height*0.015,),
                            Container(
                              height: height*0.05,
                              width: width*0.7,
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      ),
                                      bottom: BorderSide(
                                          color: ColorConstant.primaryColor.withOpacity(0.4)
                                      )
                                  )
                              ),
                              child: TextFormField(
                                cursorColor: ColorConstant.primaryColor,
                                cursorHeight: height*0.02,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "phone number required";
                                  }
                                },
                                controller: phoneController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.phone,color: ColorConstant.primaryColor,size: height*0.02,),
                                    hintText: "phone no",
                                    hintStyle: TextStyle(
                                        fontSize: width*0.03
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {

                            });
                            final userModel= await signUp(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                phoneController.text
                            );

                            if (userModel != null) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ModuleDivision(),));
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Failed")));
                            }
                          },
                          child: Container(
                            height: height*0.05,
                            width: width*0.55,
                            decoration: BoxDecoration(
                                color: ColorConstant.primaryColor,
                                borderRadius: BorderRadius.circular(width*0.05)
                            ),                            child: Center(
                              child: Text("SIGN UP",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: width*0.03,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        )

                      ],

                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
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
                            "Already have an account?",
                            style:
                            TextStyle(color: ColorConstant.primaryColor),
                          ),
                          Text(
                            "Login",
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
