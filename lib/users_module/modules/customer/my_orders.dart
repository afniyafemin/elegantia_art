import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> orders = []; // To store fetched orders

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final user = _auth.currentUser ;
    if (user != null) {
      try {
        // Fetch orders for the current user
        QuerySnapshot orderSnapshot = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .get();

        // Map the fetched documents to a list of orders
        setState(() {
          orders = orderSnapshot.docs.map((doc) => {
            'orderId': doc['orderId'],
            'productName': doc['productName'],
            'price': doc['price'],
            'orderDate': doc['orderDate'],
            'status': doc['status'],
          }).toList();
        });
      } catch (e) {
        print('Error fetching orders: $e');
        // Handle error (e.g., show a message to the user)
      }
    } else {
      // Handle user not logged in
      print('User  not logged in');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      // Remove the order from the local list
      setState(() {
        orders.removeWhere((order) => order['orderId'] == orderId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order canceled successfully!')),
      );
    } catch (e) {
      print('Error canceling order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.secondaryColor.withOpacity(0.75)),
        backgroundColor: ColorConstant.primaryColor,
        title: Text(
          "My Orders",
          style: TextStyle(
            color: ColorConstant.secondaryColor,
            fontWeight: FontWeight.w900,
            fontSize: width * 0.05,
          ),
        ),
      ),
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator(color: ColorConstant.primaryColor,)) // Show loading indicator while fetching
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: ColorConstant.primaryColor.withOpacity(0.75),
            margin: EdgeInsets.only(top : width*0.03, left: width*0.03, right: width*0.03),
            child: ListTile(
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w900,
                color: ColorConstant.primaryColor
              ),
              subtitleTextStyle: TextStyle(
                color: ColorConstant.primaryColor.withOpacity(0.4)
              ),
              title: Text(order['productName']),
              subtitle: Text('Order ID: ${order['orderId']}\nPrice: ₹${order['price']}\nDate: ${order['orderDate']}\nStatus: ${order['status']}'),
              isThreeLine: true,
              tileColor: ColorConstant.secondaryColor.withOpacity(0.8),
              onLongPress: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    backgroundColor: ColorConstant.primaryColor,
                    title: Text("Cancel Order?",
                      style:
                      TextStyle(
                          color: ColorConstant.secondaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: width*0.05
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          cancelOrder(order['orderId']);
                          Navigator.pop(context);
                        },
                          child: Container(
                            height: height*0.03,
                            width: width*0.1,
                            decoration: BoxDecoration(
                                color: ColorConstant.secondaryColor,
                                borderRadius: BorderRadius.circular(width*0.025)
                            ),
                            child: Center(
                              child: Text("yes",
                                style:
                                TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900,
                                  fontSize: width*0.03
                                ),
                              ),
                            ),
                          )
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                          child: Container(
                            height: height*0.03,
                            width: width*0.1,
                            decoration: BoxDecoration(
                              color: ColorConstant.secondaryColor,
                              borderRadius: BorderRadius.circular(width*0.025)
                            ),
                            child: Center(
                              child: Text("No",
                                style:
                                TextStyle(
                                    color: ColorConstant.primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: width*0.03
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  );
                },);
              },
            ),
          );
        },
      ),
    );
  }
}