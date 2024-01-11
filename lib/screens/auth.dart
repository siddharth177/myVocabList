import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_dictionary/utils/firebase.dart';
import 'package:rive/rive.dart';

import '../widgets/forgot_password_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        final userCredentials =
            await firebaseAuthInstance.signInWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials =
            await firebaseAuthInstance.createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              error.message ?? 'Authentication Failed. Please Try Again!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset('assets/animations/rive/spin.riv'),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            child: const SizedBox(),
          )),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Welcome to Your Vocab List',
                      style: TextStyle(
                        fontSize: 55,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _isLogin
                          ? 'Login to Enjoy using the App'
                          : 'Sign up to Proceed',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontFamily: GoogleFonts.openSans().fontFamily,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 40,
                          color: Colors.white.withOpacity(0.65),
                          margin: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Email Address'),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length <= 4 ||
                                            !value.contains('@')) {
                                          return 'Email Address is invalid';
                                        }

                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredEmail = value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Password'),
                                      obscureText: true,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length <= 6) {
                                          return 'Password must be atleast 6 character long.';
                                        }

                                        if (value.trim().length > 8) {
                                          return 'Password must be less than 9 characters.';
                                        }

                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredPassword = value!;
                                      },
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    ForgotPasswordButton(isLogin: _isLogin),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                      child:
                                          Text(_isLogin ? 'Login' : 'Signup'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLogin = !_isLogin;
                                        });
                                      },
                                      child: Text(_isLogin
                                          ? 'Create an account'
                                          : 'I already have an account'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
