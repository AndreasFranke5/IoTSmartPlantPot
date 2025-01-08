import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_plant_pot/injection.config.dart';
import 'package:smart_plant_pot/logger.dart';

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

  @Singleton(order: -1)
  MqttServerClient get secureStorage {
    const url = String.fromEnvironment('BASE_URL', defaultValue: "broker.emqx.io");
    const isSecure = bool.fromEnvironment('SSL', defaultValue: false);
    String identifier = 'Flutter_iOS';
    if (Platform.isAndroid) identifier = 'Flutter_Android';

    /// connection message
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(identifier)
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);

    final client = MqttServerClient(url, identifier)
      ..port = 1883
      ..keepAlivePeriod = 20
      ..secure = isSecure
      ..logging(on: kDebugMode)
      ..connectionMessage = connMess;
    return client;
  }
}
