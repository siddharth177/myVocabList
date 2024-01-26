import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/screens/auth.dart';
import 'package:personal_dictionary/screens/email_verification.dart';
import 'package:personal_dictionary/utils/colors_and_theme.dart';
import 'package:personal_dictionary/utils/firebase.dart';
import 'package:personal_dictionary/widgets/loading.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kLightThemeData,
      darkTheme: kDarkThemeData,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: firebaseAuthInstance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return const EmailVerificationScreen();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
