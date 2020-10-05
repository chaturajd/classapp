import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  SignIn({Key key}) : super(key: key);

  final _formKey = new GlobalKey<FormState>();

  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();

  submitSignIn() async {
    if (_formKey.currentState.validate()) {
      try {
       await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.value.text,
                password: passwordController.value.text);

        FirebaseFirestore.instance.collection("users").add({
          "name": nameController.value.text,
        });
        
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  InputDecoration textInputDecration({hint}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      hintText: hint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: textInputDecration(hint: "Email"),
                  controller: passwordController,
                  obscureText: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
