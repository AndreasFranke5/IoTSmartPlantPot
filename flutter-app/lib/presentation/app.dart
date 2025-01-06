import 'package:flutter/material.dart';
import 'package:smart_plant_pot/injection.dart';
import 'package:smart_plant_pot/presentation/auth/pages/auth_page.dart';
import 'package:smart_plant_pot/presentation/common/auth/bloc/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _inputDecTheme = InputDecorationTheme(
  filled: false,
  // labelStyle: const TextStyle(
  //   // color: kInputLabel,
  //   // fontSize: 50.sp,
  //   fontWeight: FontWeight.w400,
  // ),
  // prefixStyle: GoogleFonts.poppins(
  //   textStyle: TextStyle(
  //     color: kInputText,
  //     fontSize: 52.sp,
  //     fontWeight: FontWeight.w500,
  //   ),
  // ),
  hintStyle: const TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w400,
    // fontFamily: 'Poppins',
  ),
  errorMaxLines: 3,
  alignLabelWithHint: true,
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: MaterialApp(
        title: 'Smart Plant Pot',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green).copyWith(
            primary: const Color.fromRGBO(111, 154, 97, 1),
            secondary: const Color.fromRGBO(230, 228, 215, 1),
            tertiary: const Color.fromRGBO(234, 233, 223, 1),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(111, 154, 97, 1),
          ),
          inputDecorationTheme: _inputDecTheme,
          dropdownMenuTheme: DropdownMenuThemeData(inputDecorationTheme: _inputDecTheme),
          // scaffoldBackgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        ),
        home: const AuthPage(),
      ),
    );
  }
}
