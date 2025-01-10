import 'package:elegantia_art/users_module/modules/customer/home_customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> SigninWithGoogle(BuildContext context) async {
  try {
    // Start the Google sign-in process
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

    if (googleSignInAccount == null) {
      // User canceled the sign-in process
      print("Google sign-in was canceled.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in was canceled.")),
      );
      return;
    }

    // Fetch authentication details
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    // Check if the authentication details are available
    if (googleSignInAuthentication.accessToken == null || googleSignInAuthentication.idToken == null) {
      throw Exception("Missing authentication tokens");
    }

    // Create credential using the authentication details
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // Sign in with the credentials
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      print("User signed in: ${userCredential.user!.displayName}");
      print("User UID: ${userCredential.user!.uid}");
      print("User Email: ${userCredential.user!.email}");

      // Navigate to HomePage after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase Auth errors
    String errorMessage = "Failed to sign in with Google. Please try again.";

    switch (e.code) {
      case 'account-exists-with-different-credential':
        errorMessage = "An account already exists with a different sign-in method.";
        break;
      case 'invalid-credential':
        errorMessage = "The credential is malformed or has expired.";
        break;
      case 'user-disabled':
        errorMessage = "The user account has been disabled.";
        break;
      case 'user-not-found':
        errorMessage = "No user corresponding to the given credential was found.";
        break;
      case 'wrong-password':
        errorMessage = "The password is incorrect.";
        break;
      case 'network-request-failed':
        errorMessage = "Network error, please check your connection.";
        break;
      case 'operation-not-allowed':
        errorMessage = "The operation is not allowed. Please check your Firebase configuration.";
        break;
      case 'too-many-requests':
        errorMessage = "Too many requests, please try again later.";
        break;
      case 'timeout':
        errorMessage = "The request timed out, please try again.";
        break;
      default:
        errorMessage = "An unexpected error occurred: ${e.message}";
        break;
    }

    print("Firebase Auth Error: ${e.code} - ${e.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    print("General Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An unknown error occurred. Please try again.")),
    );
  }
}
