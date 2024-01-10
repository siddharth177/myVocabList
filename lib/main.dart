import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/screens/auth.dart';
import 'package:personal_dictionary/screens/email_verification.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

var kColorScheme =
// ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 206, 235, 199));
    ColorScheme.fromSeed(seedColor: Colors.green);
var kDarkColorScheme = kColorScheme;
var kThemeData = ThemeData().copyWith(
  colorScheme: kColorScheme,
);
var kDartThemeData = kThemeData;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kThemeData,
      darkTheme: kDartThemeData,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return EmailVerificationScreen();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return AuthScreen();
        },
      ),
    );
  }
}
