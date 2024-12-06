


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
                      //realpart ,product details
                      child: Column(
                        children: [

                        ],
                      )
                    ),
                  ),
                );
          })
        ],
      ),
    );
  }
}
