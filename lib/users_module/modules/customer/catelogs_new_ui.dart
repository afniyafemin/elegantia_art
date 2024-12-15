import 'package:elegantia_art/core/color_constants/color_constant.dart';
import 'package:elegantia_art/features/modules/customer/categories.dart';
import 'package:elegantia_art/features/modules/customer/product_details.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';

class CatelogsNewUi extends StatefulWidget {
  const CatelogsNewUi({super.key});

  @override
  State<CatelogsNewUi> createState() => _CatelogsNewUiState();
}

bool lg = true;
List p_names = ["Ring album", "Journals", "Resin", "Charm", "Stamps"];
List<Map> products = [
  {"name": "product 1", "price": "Rs"},
  {"name": "product 2", "price": "Rs"},
  {"name": "product 3", "price": "Rs"},
  {"name": "product 4", "price": "Rs"},
  {"name": "product 5", "price": "Rs"},
  {"name": "product 6", "price": "Rs"},
  {"name": "product 7", "price": "Rs"},
  {"name": "product 8", "price": "Rs"},
  {"name": "product 9", "price": "Rs"},
  {"name": "product 10", "price": "Rs"},
  {"name": "product 11", "price": "Rs"},
  {"name": "product 12", "price": "Rs"},
  {"name": "product 13", "price": "Rs"},
  {"name": "product 14", "price": "Rs"},
  {"name": "product 15", "price": "Rs"},
];
List sort = [
  "Popular",
  "Newest",
  "Customer Review",
  "Price: Low to High",
  "Price: High to Low"
];

class _CatelogsNewUiState extends State<CatelogsNewUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                  height: height * 0.35,
                  width: width * 1,
                  decoration: BoxDecoration(
                    //image: DecorationImage(image: AssetImage("asset/images/Product_1.jpg")),
                       color: ColorConstant.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(width * 0.35),
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text("$c",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: height*0.04
                        ),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: width * 0.1,
                            left: width * 0.03,
                            right: width * 0.07),
                        child: Container(
                          height: height * 0.03,
                          color: ColorConstant.primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: height * 0.45,
                                          width: width * 1,
                                          decoration: BoxDecoration(
                                              color:
                                                  ColorConstant.secondaryColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      width * 0.05),
                                                  topRight: Radius.circular(
                                                      width * 0.05))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                height: height * 0.015,
                                              ),
                                              Container(
                                                height: height * 0.01,
                                                width: width * 0.25,
                                                decoration: BoxDecoration(
                                                    color: ColorConstant
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * 0.1)),
                                              ),
                                              SizedBox(
                                                height: height * 0.015,
                                              ),
                                              Text(
                                                "Sort By",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: width * 0.05),
                                              ),
                                              SizedBox(
                                                height: height * 0.015,
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: 5,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Card(
                                                      color: ColorConstant
                                                          .primaryColor,
                                                      child: ListTile(
                                                        leading: Text(
                                                          sort[index],
                                                          style: TextStyle(
                                                              color: ColorConstant
                                                                  .secondaryColor),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: width * 0.02),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.sort_outlined,
                                        color: ColorConstant.secondaryColor,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text(
                                        "Sort By",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                ColorConstant.secondaryColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    lg = !lg;
                                  });
                                },
                                child: Icon(
                                  lg ? Icons.grid_view_sharp : Icons.list,
                                  color: ColorConstant.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.25),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductInfo()));
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.primaryColor.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 200,
                            offset: Offset(-5, 5),
                          )
                        ],
                      ),
                      height: height * 0.725,
                      width: width * 0.9,
                      child: Column(
                        children: [
                          Expanded(
                              child:lg? ListView.separated(
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: height * 0.15,
                                      width: width * 0.75,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                              width * 0.05)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: height*0.02,left: width*0.02),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    products[index]["name"],
                                                    style: TextStyle(
                                                      color: ColorConstant.primaryColor,
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: height * 0.025),
                                                  ),
                                                  Text(products[index]["price"])
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.15,
                                            width: width * 0.3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.only(
                                                        bottomRight: Radius.circular(width * 0.05),
                                                    topRight: Radius.circular(width * 0.05)
                                                    ),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "asset/images/Product_1.jpg"),
                                                  fit: BoxFit.fill,
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: height * 0.03,
                                    );
                                  },
                                  itemCount: 10):
                              GridView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7
                                  //mainAxisSpacing: width*0.03,crossAxisSpacing: width*0.03
                                ),
                                itemCount: products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: ColorConstant.secondaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorConstant.primaryColor.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 200,
                                            offset: Offset(5, 5),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          AspectRatio(aspectRatio: 1,
                                          child: Padding(
                                            padding: EdgeInsets.all(width*0.04),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "asset/images/Product_1.jpg"
                                                    ),
                                                  fit: BoxFit.cover
                                                ),
                                                borderRadius: BorderRadius.circular(12)
                                              ),
                                            ),
                                          ),),
                                          Text(
                                            products[index]["name"],
                                            style: TextStyle(
                                                color: ColorConstant.primaryColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: height * 0.025),
                                          ),
                                          Text(products[index]["price"])
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                          )
                        ],
                      ),
                      // color: Colors.white,
                    ),
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
