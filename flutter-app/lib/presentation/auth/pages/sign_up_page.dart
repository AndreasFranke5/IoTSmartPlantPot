import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/presentation/common/common.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.toLoginPage, required this.footer});

  final VoidCallback toLoginPage;
  final Widget footer;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController emailTec;
  late final TextEditingController passwordTec;
  late final TextEditingController nameTec;
  late final FocusNode emailFocus;
  late final FocusNode passwordFocus;
  late final FocusNode nameFocus;

  @override
  void initState() {
    super.initState();
    emailTec = TextEditingController();
    passwordTec = TextEditingController();
    nameTec = TextEditingController();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    nameFocus = FocusNode();
  }

  @override
  void dispose() {
    emailTec.dispose();
    passwordTec.dispose();
    nameTec.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    nameFocus.dispose();
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
                onSubmitted: (_) => nameFocus.requestFocus(),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameTec,
                focusNode: nameFocus,
                onSubmitted: (_) {
                  if (emailTec.text.isNotEmpty &&
                      passwordTec.text.isNotEmpty &&
                      nameTec.text.isNotEmpty) {
                    context.read<AuthCubit>().signUp(emailTec.text, passwordTec.text, nameTec.text);
                    return;
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (emailTec.text.isNotEmpty &&
                      passwordTec.text.isNotEmpty &&
                      nameTec.text.isNotEmpty) {
                    context.read<AuthCubit>().signUp(emailTec.text, passwordTec.text, nameTec.text);
                    return;
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: widget.toLoginPage,
                child: const Text('Go to Login'),
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
                'Register',
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
