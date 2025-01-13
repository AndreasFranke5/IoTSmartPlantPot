import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:smart_plant_pot/injection.dart';
import 'package:smart_plant_pot/presentation/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);

  unawaited(SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));

  // injectable initialization
  await configureDependencies();
  runApp(const App());
}
