import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.toLoginPage});

  final VoidCallback toLoginPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Sign Up Page'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: toLoginPage,
          child: const Text('To Login'),
        ),
      ],
    );
  }
}
