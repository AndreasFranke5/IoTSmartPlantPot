import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationsDataSource {
  Future<void> notificationListener();

  Future<Either<String, Unit>> activateNotificationToken();
}

@Singleton(as: NotificationsDataSource)
class NotificationsDataSourceImpl implements NotificationsDataSource {
  const NotificationsDataSourceImpl(this._httpClient, this._prefs);

  final Dio _httpClient;
  final SharedPreferences _prefs;

  @override
  Future<Either<String, Unit>> activateNotificationToken() async {
    // StreamController<Either<String, Unit>> controller = StreamController();

    try {
      await FirebaseMessaging.instance.requestPermission(
        provisional: true,
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        sound: true,
      );
      final token = await FirebaseMessaging.instance.getToken();
      final idToken = _prefs.getString('idToken');
      await _httpClient.post(
        '/assignNotificationToken',
        options: Options(headers: {'authorization': 'Bearer $idToken'}),
        data: {'token': token},
      );
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<void> notificationListener() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('Got a message whilst in the foreground!');
      logger.d('Message data: ${message.data}');

      if (message.notification != null) {
        logger.d('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
