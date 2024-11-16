


import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/features/modules/customer/catelog_1.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductInfo extends StatefulWidget {
  const ProductInfo({super.key});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int count=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height*0.5,
            width: width*1,
            child: Image.asset("asset/images/Product_1.jpg",
            fit: BoxFit.cover,)),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Catelog1()));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: ColorConstant.secondaryColor,
                child:Icon(Icons.arrow_back)
                //BackdropFilter(filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
              maxChildSize: 1.0,
              minChildSize: 0.6,
              builder: (context,scrollController){
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      color: ColorConstant.secondaryColor ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: 10,bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 5,
                                  width: 35,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                          ),
                          Text("Product Name",
                          style: TextStyle(
                            color: ColorConstant.primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),),
                          Row(
                            children: [
                            Text("Category",
                              style: TextStyle(
                                  color: ColorConstant.primaryColor.withOpacity(0.5)
                              ),),
                              SizedBox(width: width*0.5,),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.favorite,size: 20,color: ColorConstant.primaryColor,),
                                ),
                              ),
                              Text("273 Likes",style: TextStyle(
                                color: ColorConstant.primaryColor
                              ),),
                          ],),
                          Divider(
                            height: 20,
                            color: ColorConstant.primaryColor,
                          ),
                          Text("Description",style: TextStyle(
                            color: ColorConstant.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                          ),),
                          SizedBox(
                            height: height*0.015,
                          ),
                          Text("This part contain the information about the Product , Which is uploaded by the main artist . Please read through it before proceeding . you can customize it as you need ",
                          style: TextStyle(color: ColorConstant.primaryColor.withOpacity(0.5),
                          ),),
                          Divider(
                            height: 20,
                            color: ColorConstant.primaryColor,
                          ),
                          Text("Rating & Reviews",style: TextStyle(
                            color: ColorConstant.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                          ),),
                          SizedBox(
                            height: height*0.015,
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ Text("4.3",style: TextStyle(fontWeight: FontWeight.bold
                                ,fontSize: 30,
                                color: ColorConstant.primaryColor),),
                              Container(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                  RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                      itemBuilder: (context,_)=> Icon(Icons.star,
                                        color: ColorConstant.primaryColor,),
                                      onRatingUpdate: (rating){
                                        print(rating);
                                      }),
                                  RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemCount: 4,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                      itemBuilder: (context,_)=> Icon(Icons.star,
                                        color: ColorConstant.primaryColor,),
                                      onRatingUpdate: (rating){
                                        print(rating);
                                      }),
                                  RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemCount: 3,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                      itemBuilder: (context,_)=> Icon(Icons.star,
                                        color: ColorConstant.primaryColor,),
                                      onRatingUpdate: (rating){
                                        print(rating);
                                      }),
                                  RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemCount: 2,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                      itemBuilder: (context,_)=> Icon(Icons.star,
                                        color: ColorConstant.primaryColor,),
                                      onRatingUpdate: (rating){
                                        print(rating);
                                      }),
                                  RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemCount: 1,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                      itemBuilder: (context,_)=> Icon(Icons.star,
                                        color: ColorConstant.primaryColor,),
                                      onRatingUpdate: (rating){
                                        print(rating);
                                      }),
                                ]

                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text("12",style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstant.primaryColor,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text("5",style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text("4",style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text("2",style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text("0",style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),

                                  ],
                                ),
                              ),


                            ],
                          ),
                          Text("23 ratings", style: TextStyle(
                              color: ColorConstant.primaryColor.withOpacity(0.5)
                          ),),
                        ],
                      ),
                    ),
                  ),
                );
          })
        ],
      ),
      bottomNavigationBar: Container(
        height: height*0.06,
        color: ColorConstant.secondaryColor,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          count--;
                        });
                      },
                    child: Container(
                      height: height*0.05,
                      width: width*0.1,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded,color: ColorConstant.secondaryColor,)),
                      // child: Container(child: Text("-",
                      //   style: TextStyle(
                      //       fontSize: width*0.1
                      //   ),
                      // ))
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    child: Text(count>0?"$count":"0",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          count++;
                        });
                      },
                      child: Container(
                        height: height*0.05,
                          width: width*0.1,
                          decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: Icon(Icons.arrow_forward_ios_rounded,color: ColorConstant.secondaryColor,))
                  )
                ],
              ),
            ),
            SizedBox(width: width*0.158,),
            Container(
              height: height*0.05,
              width: width*0.5,
              decoration: BoxDecoration(
                color: ColorConstant.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(width*0.03))
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[ Text("Add To Cart  ",style: TextStyle(
                    color: ColorConstant.secondaryColor,
                    fontWeight: FontWeight.bold
                  ),),
                    Icon(Icons.shopping_cart_outlined,color: ColorConstant.secondaryColor,)
                  ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
