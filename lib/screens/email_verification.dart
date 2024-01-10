import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/screens/words_list.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EmailVerificationScreenState();
  }
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool canResentEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          Duration(seconds: 1), (_) => checkEmailVerificationStatus());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResentEmail = false;
      });
      await Future.delayed(Duration(seconds: 10));
      setState(() {
        canResentEmail = true;
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')));
    }
  }

  Future checkEmailVerificationStatus() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    isEmailVerified ? timer?.cancel() : null;
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return WordsListScreen();
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Center(
                child: Text('Email verfication mail has been sent'),
              ),
              //cancel button
              ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text('Signout')),
              ElevatedButton(
                  onPressed: () {
                    if (canResentEmail) {
                      sendVerificationEmail();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Email has already been sent')));
                    }
                  },
                  child: Text('resend')),
            ],
          ),
        ),
      ),
    );
  }
}
