import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/presentation/auth/pages/login_page.dart';
import 'package:smart_plant_pot/presentation/auth/pages/sign_up_page.dart';
import 'package:smart_plant_pot/presentation/common/common.dart';
import 'package:smart_plant_pot/presentation/common/widgets/widgets.dart';
import 'package:smart_plant_pot/presentation/home/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _overlay = LoadingOverlay();
  bool isOnLogin = true;

  Widget _googleLogin(BuildContext context) {
    return InkWell(
      onTap: context.read<AuthCubit>().loginWithGoogle,
      child: SvgPicture.asset(
        'assets/google_auth.svg',
        semanticsLabel: 'login with google',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthProcessing) {
          _overlay.show(context);
        } else {
          _overlay.hide();
        }

        if (state is Authenticated) {
          // activate notifications
          context.read<AuthCubit>().activateNotificationToken();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (state is AuthFailure) {
          logger.e(state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Smart Plant Pot',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roadRage(
                            textStyle: const TextStyle(
                              fontSize: 80,
                              color: Color.fromRGBO(61, 147, 105, 1.0),
                              fontWeight: FontWeight.w600,
                              height: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/logo.png', height: 200),
                const SizedBox(height: 20),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  firstChild: LoginPage(
                    toSignUpPage: () => setState(() => isOnLogin = false),
                    footer: _googleLogin(context),
                  ),
                  secondChild: SignUpPage(
                    toLoginPage: () => setState(() => isOnLogin = true),
                    footer: _googleLogin(context),
                  ),
                  crossFadeState: isOnLogin ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
