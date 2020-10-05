import 'package:classapp/services/auth_service.dart';
import 'package:classapp/wrapper.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final themeData = ThemeData(
    primaryColor: Color.fromARGB(255, 120, 116, 204),
    accentColor: Color.fromARGB(255, 203, 214, 240),
    buttonColor: Color.fromARGB(100, 176, 189, 255),
    dividerColor: Color.fromARGB(255, 120, 116, 204),
    fontFamily: "shanti",
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            title: "as",
            theme: themeData,
            home: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Widget startScreen=Login();
          // FirebaseAuth.instance.authStateChanges().listen((User user) {
          //   if (user == null) {
          //     startScreen = Login();
          //   } else {
          //     startScreen = Home();
          //   }
          // });
          return StreamProvider<User>.value(
            value: AuthService().authStateChanges,
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: themeData,
               home: Wrapper(),
            ),
          );
        }

        return MaterialApp(
          title: "as",
          theme: themeData,
          home: Text("Loadin       xcvg"),
        );
      },
    );
  }
}
