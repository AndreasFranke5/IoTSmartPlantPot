import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/presentation/common/auth/bloc/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.toSignUpPage, required this.footer});

  final VoidCallback toSignUpPage;
  final Widget footer;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailTec;
  late final TextEditingController passwordTec;
  late final FocusNode emailFocus;
  late final FocusNode passwordFocus;

  @override
  void initState() {
    super.initState();
    emailTec = TextEditingController();
    passwordTec = TextEditingController();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    emailTec.dispose();
    passwordTec.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: emailTec,
                focusNode: emailFocus,
                onSubmitted: (_) => passwordFocus.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordTec,
                focusNode: passwordFocus,
                onSubmitted: (_) {
                  if (emailTec.text.isNotEmpty && passwordTec.text.isNotEmpty) {
                    context.read<AuthCubit>().login(emailTec.text, passwordTec.text);
                    return;
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (emailTec.text.isNotEmpty && passwordTec.text.isNotEmpty) {
                    context.read<AuthCubit>().login(emailTec.text, passwordTec.text);
                    return;
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: widget.toSignUpPage,
                child: const Text('Goto Sign Up'),
              ),
              widget.footer,
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(126, 189, 70, 1),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
