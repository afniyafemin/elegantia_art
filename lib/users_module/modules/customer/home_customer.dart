import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/components/custom_drawer.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/services/chatting/chat_page.dart';
import 'package:elegantia_art/services/search/search_products.dart';
import 'package:elegantia_art/users_module/modules/customer/categories.dart';
import 'package:elegantia_art/users_module/modules/customer/pins.dart';
import 'package:elegantia_art/users_module/modules/customer/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'catelogs_new_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int selectIndex = 0;

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserName = "";
  List<Map<String, dynamic>> products_ = [];
  // List<Map<String, dynamic>> MallProducts_ = [];
  List<Map<String, dynamic>> offerProducts_ = [];
  int userPoints = 0; // Variable to store user points

  List products = [
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
    ImageConstant.product2,
    ImageConstant.product1,
    ImageConstant.product2,
  ];

  List<String> description_for_category = [
    "description",
    "description",
    "description",
    "description",
    "description",
    "description",
    "description",
  ];

  bool isLoading = false;

  List<Map<String, dynamic>> categories = [];

  void signUserOut() {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserName();
    _fetchUserPointsAndOfferProducts(); // Fetch user points and offer products
    _fetchCategories();
    _fetchProducts(currentUserName);
  }

  Future<void> _fetchUserPointsAndOfferProducts() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      try {
        // Fetch user points
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          userPoints = userDoc['points'] ?? 0; // Assuming 'points' is the field name in Firestore
        }

        // Fetch offer products based on user points
        List<String> offerProductIds = [];
        if (userPoints == 0) {
          // Fetch products priced below 99 from the 'products' collection
          final productCollection = _firestore.collection('products');
          final snapshot = await productCollection.where('price', isLessThanOrEqualTo: 99).get();
          offerProducts_ = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        } else {
          // Fetch products from the 'offers' collection where pointsRequired equals userPoints
          final offerCollection = _firestore.collection('offers');
          final snapshot = await offerCollection.where('pointsRequired', isEqualTo: userPoints).get();
          offerProductIds = snapshot.docs.map((doc) => doc['productId'] as String).toList(); // Assuming 'productId' is the field name
        }

        // Fetch product details for each offer product ID
        for (String productId in offerProductIds) {
          DocumentSnapshot productDoc = await _firestore.collection('products').doc(productId).get();
          if (productDoc.exists) {
            offerProducts_.add(productDoc.data() as Map<String, dynamic>);
          }
        }

        // Update the state to reflect the fetched offer products
        setState(() {});
      } catch (error) {
        print("Error fetching user points or offer products: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $error')),
        );
      }
    }
  }
  // Future<void> _get99MallProducts() async {
  //   try {
  //     final productCollection = FirebaseFirestore.instance.collection('products');
  //     final snapshot = await productCollection.where('price', isLessThanOrEqualTo: 99).get();
  //
  //     if (snapshot.docs.isNotEmpty) {
  //       setState(() {
  //         MallProducts_ = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  //       });
  //     }
  //   } catch (e) {
  //     // Handle error (e.g., show a snackbar)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching products: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> _fetchCategories() async {
    try {
      final categoriesRef = _firestore.collection('categories');
      final querySnapshot = await categoriesRef.get();
      setState(() {
        categories = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (error) {
      print("Error fetching categories: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load categories. Please try again.")),
      );
    }
  }

  Future<void> _fetchProducts(String category) async {
    try {
      setState(() {
        isLoading = true;
      });
      final productsRef = _firestore.collection('products');
      Query<Map<String, dynamic>> query = productsRef;
      if (category.isNotEmpty) {
        query = query.orderBy('likeCount', descending: true);
      }
      final querySnapshot = await query.get();
      setState(() {
        products_ = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (error) {
      print("Error fetching products: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCurrentUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Default to "User" if no user is signed in
    setState(() {
      currentUserName = "User";
    });

    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            // If user document exists, set the username from the document, otherwise default to "User"
            currentUserName = userDoc['username'] ?? "User";
          });
        } else {
          print("User document does not exist.");
        }
      } catch (error) {
        print("Error fetching user name: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to load user name. Please try again.")),
        );
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayProducts =
        userPoints == 0 ? offerProducts_ : offerProducts_;
    return Scaffold(
      //this key is needed , when the userprofile is clicked th key will get
      //enabled and the drawer will come up
      key: _scaffoldKey,
      drawer: CustomDrawer(
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: ColorConstant.secondaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: ListView(children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  ImageConstant.aesthetic_userprofile),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Text(
                            currentUserName,
                            style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.primaryColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // InkWell(
                          //   onTap: () {
                          //     setState(() {
                          //       showSearch(context: context, delegate: CustomSearchDelegate());
                          //     });
                          //   },
                          //   child: CircleAvatar(
                          //     radius: width*0.04,
                          //     backgroundColor: ColorConstant.primaryColor,
                          //     child: Icon(Icons.search,color: ColorConstant.secondaryColor,),
                          //   ),
                          // ),
                          // SizedBox(width: width*0.03,),
                          // InkWell(
                          //   onTap: () {
                          //     setState(() {
                          //       Navigator.push(context, MaterialPageRoute(builder: (context) => CartCustomer(),));
                          //     });
                          //   },
                          //   child: CircleAvatar(
                          //     radius: width*0.04,
                          //     backgroundColor: ColorConstant.primaryColor,
                          //     child: Icon(Icons.add_shopping_cart,color: ColorConstant.secondaryColor,),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Pins()));
                            },
                            child: CircleAvatar(
                              radius: width * 0.04,
                              backgroundColor: ColorConstant.primaryColor,
                              child: Icon(
                                Icons.favorite,
                                color: ColorConstant.secondaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(),
                          ));
                    },
                    child: Column(
                      children: [
                        Text(
                          '''Interact with us ''',
                          style: TextStyle(
                              fontSize: width * 0.075,
                              fontWeight: FontWeight.w900,
                              color:
                                  ColorConstant.primaryColor.withOpacity(0.5)),
                        ),
                        Text(
                          ''' to know more about the crafts ''',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color:
                                  ColorConstant.primaryColor.withOpacity(0.25),
                              fontSize: width * 0.03),
                        ),
                        SizedBox(
                          height: height * 0.025,
                        )
                      ],
                    ),
                  ),
                  TextField(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    cursorColor: ColorConstant.primaryColor,
                    decoration: InputDecoration(
                      hintText: "Search for products",
                      hintStyle: TextStyle(
                          color: ColorConstant.primaryColor.withOpacity(0.3)),
                      prefixIcon:
                          Icon(Icons.search, color: ColorConstant.primaryColor),
                      filled: true,
                      fillColor: ColorConstant.secondaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        borderSide:
                            BorderSide(color: ColorConstant.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        borderSide:
                            BorderSide(color: ColorConstant.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        borderSide:
                            BorderSide(color: ColorConstant.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorConstant.secondaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: offerProducts_.isEmpty
                              ? Center(child: Text('No offer products available.'))
                              : CarouselSlider.builder(
                            itemCount: offerProducts_.length,
                            itemBuilder: (BuildContext context, int index, int realIndex) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(product: offerProducts_[index]),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: ColorConstant.primaryColor,
                                          image: DecorationImage(
                                            image: AssetImage(ImageConstant.gift_hamper), // Assuming 'image' is the field name
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 100.0, left: 16.0),
                                        child: Text(
                                          offerProducts_[index]['name'],
                                          style: TextStyle(
                                            fontSize: 24.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              viewportFraction: 1,
                              autoPlay: true,
                              height: 200.0,
                              autoPlayAnimationDuration: Duration(seconds: 4),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  selectIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Categories"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryList(),
                              ));
                          setState(() {});
                        },
                        child: Text(
                          "See all",
                          style: TextStyle(fontSize: width * 0.03),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: height * 0.2,
                    width: width * 0.95,
                    decoration: BoxDecoration(
                      color: ColorConstant.secondaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CatelogsNewUi(
                                      selectedCategory: categories[index]
                                          ['name'],
                                      description:
                                          description_for_category[index],
                                    ),
                                  ));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.015, right: width * 0.015),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                      radius: width * 0.1,
                                      backgroundImage:
                                          AssetImage(products[index])),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.015),
                                    child: Text(
                                      categories[index]['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.0175,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: categories.length),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Trending"),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    height: height * 0.2,
                    width: width * 0.95,
                    decoration: BoxDecoration(
                      color: ColorConstant.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      product: products_[index],
                                    ),
                                  ));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.015),
                              child: Container(
                                height: height * 1,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  color: ColorConstant.secondaryColor,
                                  borderRadius:
                                      BorderRadius.circular(width * 0.02),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Container(
                                      height: height * 0.13,
                                      width: width * 0.175,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.015),
                                          color: ColorConstant.primaryColor,
                                          image: DecorationImage(
                                              image:
                                                  AssetImage(products[index]),
                                              fit: BoxFit.cover)),
                                    ),
                                    SizedBox(
                                      height: width * 0.015,
                                    ),
                                    Center(
                                      child: Text(
                                        '''${products_[index]['name']}''',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: width * 0.02),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: products.length),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  CustomText(text: "New Arrivals"),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    padding: EdgeInsets.all(width * 0.005),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.5,
                          mainAxisSpacing: width * 0.03,
                          crossAxisSpacing: width * 0.03),
                      itemCount: products_.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(product: products_[index]),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.all(width * 0.005),
                            decoration: BoxDecoration(
                              color: ColorConstant.secondaryColor,
                              borderRadius: BorderRadius.circular(width * 0.02),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: height * 0.2,
                                      width: width * 0.4,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.03),
                                          image: DecorationImage(
                                              image:
                                                  AssetImage(products[index]),
                                              fit: BoxFit.cover)),
                                    ),

                                    // Padding(
                                    //   padding:  EdgeInsets.only(
                                    //       left: width*0.253,
                                    //       top: width*0.275
                                    //   ),
                                    //   child: Container(
                                    //     height: height*0.045,
                                    //     width: width*0.09,
                                    //     decoration: BoxDecoration(
                                    //       boxShadow: [
                                    //         BoxShadow(
                                    //             color: ColorConstant.primaryColor,
                                    //             blurRadius: width*0.01,
                                    //             spreadRadius: width*0.001
                                    //         )
                                    //       ],
                                    //       borderRadius: BorderRadius.circular(width*0.1),
                                    //       color: Colors.white,
                                    //     ),
                                    //     child: Icon(Icons.favorite_outline,color: ColorConstant.primaryColor,),
                                    //   ),
                                    // )
                                  ],
                                ),
                                Text(
                                  products_[index]['name'],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;

  CustomText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          color: ColorConstant.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: width * 0.035,
          shadows: [
            Shadow(
              color: ColorConstant.primaryColor.withOpacity(0.5),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}
