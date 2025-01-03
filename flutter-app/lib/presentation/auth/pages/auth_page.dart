import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/presentation/auth/pages/login_page.dart';
import 'package:smart_plant_pot/presentation/auth/pages/sign_up_page.dart';
import 'package:smart_plant_pot/presentation/common/common.dart';
import 'package:smart_plant_pot/presentation/home/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isOnLogin = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      // listenWhen: (previous, current) => previous != current && current is Authenticated,
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (state is AuthFailure) {
          logger.e(state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Smart Plant Pot'),
                  ],
                ),
                const SizedBox(height: 10),
                Image.asset('assets/logo.png', height: 200),
                const SizedBox(height: 100),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  firstChild: LoginPage(toSignUpPage: () => setState(() => isOnLogin = false)),
                  secondChild: SignUpPage(toLoginPage: () => setState(() => isOnLogin = true)),
                  crossFadeState: isOnLogin ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: context.read<AuthCubit>().loginWithGoogle,
                  child: SvgPicture.asset(
                    'assets/google_auth.svg',
                    semanticsLabel: 'login with google',
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
