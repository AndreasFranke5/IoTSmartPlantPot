import 'package:flutter/material.dart';
import 'package:smart_plant_pot/injection.dart';
import 'package:smart_plant_pot/presentation/auth/pages/auth_page.dart';
import 'package:smart_plant_pot/presentation/common/auth/bloc/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: MaterialApp(
        title: 'Smart Plant Pot',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green).copyWith(
            primary: const Color.fromRGBO(111, 154, 97, 1),
            secondary: const Color.fromRGBO(230, 228, 215, 1),
            tertiary: const Color.fromRGBO(234, 233, 223, 1),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(111, 154, 97, 1),
          ),
          useMaterial3: true,
        ),
        home: const AuthPage(),
      ),
    );
  }
}
