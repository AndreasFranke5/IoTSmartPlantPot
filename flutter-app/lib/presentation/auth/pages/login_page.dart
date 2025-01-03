import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.toSignUpPage});

  final VoidCallback toSignUpPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Login Page'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: toSignUpPage,
          child: const Text('To Sign Up'),
        ),
      ],
    );
  }
}
