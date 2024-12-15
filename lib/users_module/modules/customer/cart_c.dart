import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/change_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartCustomer extends StatefulWidget {
  const CartCustomer({super.key});

  @override
  State<CartCustomer> createState() => _CartCustomerState();
}

class _CartCustomerState extends State<CartCustomer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
      Scaffold(
        backgroundColor: ColorConstant.secondaryColor,
        appBar: AppBar(
          backgroundColor: ColorConstant.primaryColor,
          title: Text(
            "My Cart",
            style: TextStyle(
                color: ColorConstant.secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: width * 0.05),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.05),
                height: height * 0.1,
                decoration: BoxDecoration(
                    color: ColorConstant.primaryColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(width * 0.05)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Deliver to : Username"),
                        Text("Address")
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeAddress(),));
                        setState(() {

                        });
                      },
                      child: Container(
                        height: height * 0.04,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(width * 0.05)),
                        child: Center(
                          child: Text(
                            "Change",
                            style: TextStyle(
                                color: ColorConstant.secondaryColor,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height*0.015,),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(width * 0.03),
                      margin: EdgeInsets.only(top: width * 0.03),
                      height: height * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          color: ColorConstant.primaryColor.withOpacity(0.4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(children: [
                            Container(
                              height: height * 0.2,
                              width: width * 0.35,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
                                  image: DecorationImage(
                                      image: AssetImage(ImageConstant.product1),
                                      fit: BoxFit.fill)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.12, left: width * 0.25),
                              child: CircleAvatar(
                                radius: width * 0.04,
                                backgroundColor: ColorConstant.secondaryColor,
                                child: Icon(
                                  Icons.favorite_outline_rounded,
                                  color: ColorConstant.primaryColor,
                                ),
                              ),
                            )
                          ]),
                          // SizedBox(width: width*0.1,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "Category : Product name \n Product Id \n Price"),
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.05,
                                    width: width * 0.275,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.primaryColor,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.03)),
                                    child: Center(
                                      child: Text(
                                        "Buy Now",
                                        style: TextStyle(
                                            color: ColorConstant.secondaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width * 0.03),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Container(
                                    height: height * 0.05,
                                    width: width * 0.15,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.primaryColor,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.03)),
                                    child: Center(
                                        child: Icon(
                                      Icons.delete,
                                      color: ColorConstant.secondaryColor,
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      Positioned(
        top:height*0.92,
        child: Container(
          width: width*1,
          height: height*0.08,
          decoration: BoxDecoration(
            color: ColorConstant.secondaryColor,
            borderRadius: BorderRadius.circular(width*0.05)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("TOTAL \nRs. 2000",
                style: TextStyle(
                  fontSize: width*0.03,
                  color: ColorConstant.primaryColor
                ),
              ),
              Container(
                height: height*0.05,
                width: width*0.4,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.circular(width*0.03)
                ),
                child: Center(
                  child: Text("Buy Now",
                    style: TextStyle(
                      color: ColorConstant.secondaryColor,
                      fontSize: width*0.03
                    ),),
                ),
              )
            ],
          ),
        ),
      )
     ]
    );
  }
}
