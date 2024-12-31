import 'package:elegantia_art/users_module/login_signup/signup.dart';
import 'package:flutter/cupertino.dart';

import '../users_module/login_signup/login.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggling(){
    setState(() {
      showLoginPage =!showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(showRegisterPage: toggling);
    }else{
      return SignUp(showLoginPage: toggling);
    }
  }
}
