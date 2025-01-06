import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_plant_pot/injection.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async => await getIt.init();

@module
abstract class ExternalLibraryInjectableModule {
  @lazySingleton
  Dio get dio {
    return Dio(
      BaseOptions(
        // baseUrl: 'http://127.0.0.1:5001/smart-plant-pot-iot/us-central1',
        baseUrl: 'https://us-central1-smart-plant-pot-iot.cloudfunctions.net',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(scopes: <String>['email', 'profile']);

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
