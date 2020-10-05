
import 'package:classapp/components/button.dart';
import 'package:classapp/screens/home.dart';
import 'package:classapp/screens/sign_in.dart';
import 'package:classapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key key}) : super(key: key);

  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  final _logInFormKey = new GlobalKey<FormState>();

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

  submitForm(context) async {
    if (_logInFormKey.currentState.validate()) {
      AuthService _auth = new AuthService();

      dynamic user = await _auth.signInUsingEmail(
          emailController.value.text, passwordController.value.text);

      if (user == null) {
        debugPrint("NOT sIGNED INT");
      } else {
        debugPrint("Signed in");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    }
  }

  navigateToSignIn(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _logInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: textInputDecration(hint: "Email"),
              controller: emailController,
            ),
            TextFormField(
              decoration: textInputDecration(hint: "Email"),
              controller: passwordController,
              obscureText: true,
            ),
            FlatButton(
              child: Text("data"),
              onPressed: () => submitForm(context),
            ),
            Button(
              text: "Log in",
              action: submitForm,
            ),
            InkWell(
              onTap: () => navigateToSignIn(context),
              child: Text("Or Sign in"),
            )
          ],
        ),
      ),
    );
  }
}
