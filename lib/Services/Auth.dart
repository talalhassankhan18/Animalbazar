
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_store/mainScreen.dart';

class MyFireBaseAuth {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        print("User signed in: ${currentUser.displayName} (${currentUser.email})");

        return;
      }

      // Initialize GoogleSignIn
      final GoogleSignInAccount? googleSignInAccount =
      await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);

      final User user = userCredential.user!;

      Navigator.of(context, rootNavigator: true).pop();


    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      print("Error during Google sign in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during Google sign in: $e")),
      );
    }
  }
}
