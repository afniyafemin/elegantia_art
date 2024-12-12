
import 'package:elegantia_art/features/modules/module.dart';
import 'package:flutter/material.dart';

import 'features/splash/splash.dart';

void main() {
  runApp(const MyApp());
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
      home: ModuleDivision(),
    );
  }
}


