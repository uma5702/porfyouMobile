import 'package:flutter/material.dart';

class SignUpConfirmScreen extends StatelessWidget {
  const SignUpConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Confirm'),
      ),
      body: const Center(
        child: Text('Sign Up Confirm Screen'),
      ),
    );
  }
}
