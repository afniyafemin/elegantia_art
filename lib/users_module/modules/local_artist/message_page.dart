
import 'package:flutter/material.dart';

import '../../../constants/color_constants/color_constant.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        title: Text('Messages'),
      ),
      backgroundColor: ColorConstant.secondaryColor,
      body: Column(),
    );
  }
}