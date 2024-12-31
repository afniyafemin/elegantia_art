import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/services/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<UserModel?> signUp(
    String email, String password, String username,  String phone
    ) async {
  try{
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    String uid = userCredential.user!.uid;
    UserModel userModel= UserModel(
        uid: userCredential.user!.uid,
        username: username,
        email: email,
        phone: phone,
    );

    await FirebaseFirestore.instance.collection('users').doc(userModel.uid).set(userModel.toMap());
    return userModel;

  }catch(e){
    print(e);
    return null;
  }
}