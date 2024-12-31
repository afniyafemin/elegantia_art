import 'package:elegantia_art/services/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

Future<UserModel?> signIn (
    String email, String password
    ) async {
  try{
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );

  }catch(e){
    print(e);
    return null;
  }
}