import 'package:elegantia_art/firebase_options.dart';
import 'package:elegantia_art/users_module/modules/customer/customer_navbar.dart';
import 'package:elegantia_art/users_module/modules/customer/home_customer.dart';
import 'package:elegantia_art/users_module/modules/customer/testimonials.dart';
import 'package:elegantia_art/users_module/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}
var height;
var width;
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash()
    );
  }
}


