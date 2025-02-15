import 'package:classapp/screens/home.dart';
import 'package:classapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context); 

    if (user == null) {
      return Login();
    }
    else{
      return Home();
    }
  }
}
