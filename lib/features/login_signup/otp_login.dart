import 'package:country_code_picker/country_code_picker.dart';
import 'package:elegantia_art/features/modules/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../core/color_constants/color_constant.dart';
import '../../core/image_constants/image_constant.dart';
import '../../main.dart';
import 'login.dart';

class OtpLogin extends StatefulWidget {
  const OtpLogin({super.key});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}
class _OtpLoginState extends State<OtpLogin> {
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Container(
                            height: height*0.06,
                            width: width*0.7,
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: ColorConstant.primaryColor.withOpacity(0.4)
                                    ),
                                )
                            ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorConstant.primaryColor.withOpacity(0.4)
                                    )
                                  ),
                                  prefixIcon: CountryCodePicker(
                                    onChanged: (value) => print(value),
                                    showFlag: true,
                                    initialSelection: 'IN',
                                  )
                                ),
                              ),
                            ),
                              SizedBox(height: width*0.03,),
                              Container(
                                height: height*0.05,
                                width: width*0.55,
                                color: ColorConstant.primaryColor.withOpacity(0.65),
                                child: Center(
                                  child: Text("SEND OTP",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width*0.03,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: width*0.03,),
                              Text("Haven't got the confirmation code yet? ",
                              style:TextStyle(
                                fontSize: width*0.04
                              ),
                              ),
                              Text("Resend",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: width*0.04
                                ),
                                ),
                            ],

                          ),
                          Column(
                            children: [
                              Pinput(
                                onCompleted: (value) => print(value),
                                length: 6,
                                disabledPinTheme: PinTheme(
                                  height: height*0.08,
                                  width: width*0.075,
                                  decoration: BoxDecoration(
                                  color: ColorConstant.primaryColor,
                                  shape: BoxShape.circle
                                  )
                                ),
                              ),
                              SizedBox(height: width*0.03,),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleDivision(),));
                                  setState(() {

                                  });
                                },
                                child: Container(
                                  height: height*0.05,
                                  width: width*0.55,
                                  color: ColorConstant.primaryColor.withOpacity(0.65),
                                  child: Center(
                                    child: Text("VERIFY OTP",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: width*0.03,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height*0.15,
                      width: width*0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Try Another ",
                                style: TextStyle(
                                    color: ColorConstant.primaryColor
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                                  setState(() {

                                  });
                                },
                                child: Text("Method?",
                                  style: TextStyle(
                                      color: ColorConstant.primaryColor,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ],
                          ),
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
