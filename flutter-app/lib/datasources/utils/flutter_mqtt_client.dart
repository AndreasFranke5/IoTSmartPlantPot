import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_plant_pot/logger.dart';

@singleton
class FlutterMqttServerClient {
  final MqttServerClient _mqttServerClient;

  FlutterMqttServerClient(this._mqttServerClient);

  /// Connect to the server
  void connect(String topic) async {
    try {
      logger.i('[MQTT_CLIENT] Client connecting to server....');

      /// attached on connected method to trigger subscription
      _mqttServerClient.onConnected = () => onConnected(topic);
      _mqttServerClient.onSubscribed = onSubscribed;
      _mqttServerClient.onDisconnected = onDisconnected;

      await _mqttServerClient.connect();
    } on Exception catch (e) {
      logger.e('[MQTT_CLIENT] client connection exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    _mqttServerClient.disconnect();
    logger.i('[MQTT_CLIENT] Disconnected.');
  }

  Future<bool> connecting() async {
    bool flag = true;
    while (flag) {
      logger.i('[MQTT_CLIENT] connecting...');
      await Future.delayed(const Duration(seconds: 5));
      if (_mqttServerClient.connectionStatus?.state == MqttConnectionState.connected ||
          _mqttServerClient.connectionStatus?.state == MqttConnectionState.disconnected ||
          _mqttServerClient.connectionStatus?.state == MqttConnectionState.faulted) {
        logger.i('[MQTT_CLIENT] connected');
        flag = false;
      }
    }
    logger.i('Done');
    return _mqttServerClient.connectionStatus?.state == MqttConnectionState.connected;
  }

  void onConnected(String topic) {
    _mqttServerClient.subscribe(topic, MqttQos.atLeastOnce);
  }

  Stream<String> get listener async* {
    final controller = StreamController<String>();

    // logger.i('[MQTT_CLIENT] listener');

    _mqttServerClient.updates?.listen(
      (List<MqttReceivedMessage<MqttMessage>> c) {
        // logger.i('lll=========> ${c.length}');
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;

        final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        // final received = jsonDecode(pt);
        controller.add(pt);
        // logger.i('Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      },
      onError: (e) {
        controller.addError(e);
        logger.e(e);
      },
      cancelOnError: false,
    );
    yield* controller.stream;
  }

  Future<void> publish(String topic, String message) async {
    final builder = MqttClientPayloadBuilder()..addString(message);
    _mqttServerClient.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void onSubscribed(String topic) {
    logger.i('[MQTT_CLIENT] subscribed....');
  }

  void onDisconnected() {
    logger.i('[MQTT_CLIENT] disconnected....');
  }
}
