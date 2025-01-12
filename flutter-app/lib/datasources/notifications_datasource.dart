import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        message.data['title'] ?? 'Smart Plant Pot',
        message.data['title'] ?? 'Smart Plant Pot',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
      );
      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      logger.d('Message data: ${message.data}');
      final int notificationId = int.tryParse(message.data['intId']) != null
          ? int.parse(message.data['intId'])
          : DateTime.now().millisecondsSinceEpoch ~/ 1000;
      logger.d('Notification ID: $notificationId');
      await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.data['title'] ?? 'Smart Plant Pot',
        message.data['body'] ?? 'Failed to retrieve message',
        notificationDetails,
        payload: 'item x',
      );
    });
  }
}
