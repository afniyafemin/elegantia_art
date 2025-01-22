import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/color_constants/color_constant.dart';
import 'package:elegantia_art/main.dart';
import 'package:elegantia_art/users_module/modules/customer/categories.dart';
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
          orders = orderSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'docId': doc.id, // Firestore document ID
              'orderId': data['orderId'],
              'productName': data['productName'],
              'price': data['price'],
              'orderDate': data['orderDate'],
              'status': data['status'],
            };
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

  Future<void> cancelOrder(String docId) async {
    try {
      await _firestore.collection('orders').doc(docId).delete();
      // Remove the order from the local list
      setState(() {
        orders.removeWhere((order) => order['docId'] == docId);
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
          ? Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No orders',
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w600,
                color: ColorConstant.primaryColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryList()));
              },
                child: Container(
                  height: height*0.05,
                  width: width*0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width*0.02),
                    color: ColorConstant.primaryColor
                  ),
                  child: Center(
                    child: Text("ShopNow",style: TextStyle(
                      color: ColorConstant.secondaryColor
                    ),),
                  ),))
          ],
        ),
      ) // Show "No orders" message if the list is empty
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: ColorConstant.primaryColor.withOpacity(0.75),
            margin: EdgeInsets.only(top: width * 0.03, left: width * 0.03, right: width * 0.03),
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
              trailing: ElevatedButton(
                onPressed: () {
                  // Show confirmation dialog before canceling
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: ColorConstant.secondaryColor,
                        title: Text("Cancel Order?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: width * 0.05
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              cancelOrder(order['docId']); // Use the document ID to cancel the order
                              Navigator.pop(context);
                            },
                            child: Text("Yes",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900,
                                  fontSize: width * 0.03
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("No",
                              style: TextStyle(
                                  color: ColorConstant.primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: width * 0.03
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorConstant.primaryColor, backgroundColor: ColorConstant.secondaryColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}