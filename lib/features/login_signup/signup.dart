import 'package:elegantia_art/features/modules/module.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../core/color_constants/color_constant.dart';
import '../../core/image_constants/image_constant.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}
bool pass=true;
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
                  Container(
                    height: height*0.2,
                    width: width*0.75,
                    child: Text("Timeless beauty \n and \n cherished memories \n are both stitched \n with love \n and \n elegance",style: TextStyle(
                      color: ColorConstant.primaryColor
                    ),textAlign: TextAlign.center,),
                  ),
                  Container(
                    height: height*0.5,
                    width: width*0.75,
                    color: Colors.white.withOpacity(0.45),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(),
                        Column(
                          children: [
                            Container(
                              height: height*0.05,
                              width: width*0.55,
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
                              width: width*0.55,
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
                              width: width*0.55,
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
                              width: width*0.55,
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
                              width: width*0.55,
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
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ModuleDivision(),));
                            setState(() {

                            });
                          },
                          child: Container(
                            height: height*0.05,
                            width: width*0.55,
                            color: ColorConstant.primaryColor.withOpacity(0.65),
                            child: Center(
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
                  Container(
                    height: height*0.15,
                    width: width*0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Already have an account ?"),
                        InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                            setState(() {

                            });
                          },
                          child: Container(
                            height: height*0.03,
                            width: width*0.3,
                            color: ColorConstant.primaryColor.withOpacity(0.65),
                            child: Center(
                              child: Text(
                                "LOGIN",
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
