import 'package:flutter/material.dart';

import '../screens/forgot_password.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({this.isLogin, super.key});

  final isLogin;

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen()));
          },
          child: const Text('Forgot Password?'));
    }

    return const SizedBox(
      height: 0,
    );
  }
}
