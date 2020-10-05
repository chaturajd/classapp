import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService {

    Stream<User> get authStateChanges{
      return FirebaseAuth.instance.authStateChanges();
    }
  
  
    Future signInUsingEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email,
              password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('User Not Found');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password');
      }
    } catch (e) {
      debugPrint(e);
    }
  }
}
