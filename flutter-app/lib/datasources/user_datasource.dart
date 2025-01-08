import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_plant_pot/datasources/utils/flutter_mqtt_client.dart';
import 'package:smart_plant_pot/dtos/dtos.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';

abstract class UserDataSource {
  Future<Either<String, User>> getUser(String id);

  Future<Either<String, List<Device>>> getUserDevices();

  Future<Either<String, List<Plant>>> getUserPlantSlots();

  Future<Either<String, Unit>> addDevice(AddDeviceDto plant);

  Future<Either<String, Unit>> addPlant(AddPlantDto plant);

  Future<Either<String, List<PlantStat>>> getUserPlantStats();

  Stream<Either<String, PlantStat>> listenToPlantData(String slotId);

  Either<String, Unit> disconnectListener();
}

@Singleton(as: UserDataSource)
class UserDataSourceImpl implements UserDataSource {
  final Dio _httpClient;
  final SharedPreferences _prefs;
  final FlutterMqttServerClient _mqttClient;

  const UserDataSourceImpl(this._httpClient, this._prefs, this._mqttClient);

  @override
  Future<Either<String, User>> getUser(String id) async {
    try {
      final response = await _httpClient.get(
        '/getUser',
        options: Options(
          headers: {'authorization': 'Bearer $id'},
        ),
      );
      final user = User.fromJson(response.data);
      return right(user);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Device>>> getUserDevices() async {
    try {
      final response = await _httpClient.get(
        '/getUserDevices',
        options: Options(
          headers: {'authorization': 'Bearer ${_prefs.get('idToken')}'},
        ),
      );
      final devicesJsonList = List<dynamic>.from(response.data);
      if (devicesJsonList.isEmpty) {
        return right([]);
      }
      final devicesList = List<Map<String, dynamic>>.from(devicesJsonList);
      final devices = devicesList.map((d) => Device.fromJson(d)).toList();
      return right(devices);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Plant>>> getUserPlantSlots() async {
    try {
      final idToken = _prefs.getString('idToken');
      final response = await _httpClient.get(
        '/getUserPlants',
        options: Options(
          headers: {'authorization': 'Bearer $idToken'},
        ),
      );
      final plantsJsonList = List<dynamic>.from(response.data);
      if (plantsJsonList.isEmpty) {
        return right([]);
      }
      final plantsJsonMapList = List<Map<String, dynamic>>.from(plantsJsonList);
      final plants = plantsJsonMapList.map((d) => Plant.fromJson(d)).toList();
      return right(plants);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> addDevice(AddDeviceDto plant) async {
    try {
      final idToken = _prefs.getString('idToken');
      await _httpClient.post(
        '/addDevice',
        options: Options(
          headers: {'authorization': 'Bearer $idToken'},
        ),
        data: plant.toJson(),
      );
      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> addPlant(AddPlantDto plant) async {
    try {
      final idToken = _prefs.getString('idToken');
      await _httpClient.post(
        '/addNewPlant',
        options: Options(
          headers: {'authorization': 'Bearer $idToken'},
        ),
        data: plant.toJson(),
      );
      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<PlantStat>>> getUserPlantStats() async {
    try {
      final idToken = _prefs.getString('idToken');
      final response = await _httpClient.get(
        '/getUserPlantsStats',
        options: Options(
          headers: {'authorization': 'Bearer $idToken'},
        ),
      );
      final plantsJsonList = List<dynamic>.from(response.data);
      if (plantsJsonList.isEmpty) {
        return right([]);
      }
      final plantsJsonMapList = List<Map<String, dynamic>>.from(plantsJsonList);
      final plants = plantsJsonMapList.map((d) => PlantStat.fromJson(d)).toList();
      return right(plants);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  @override
  Stream<Either<String, PlantStat>> listenToPlantData(String slotId) async* {
    _mqttClient.connect('SMART-PLANT-POT-$slotId');
    final connected = await _mqttClient.connecting();
    if (connected) {
      final controller = StreamController<Either<String, PlantStat>>();
      _mqttClient.listener.listen(
        (data) {
          // logger.d(data);
          final stat = PlantStat.fromJson(jsonDecode(data));
          controller.add(Right(stat));
        },
        onError: (e) {
          controller.add(Left(e.toString()));
          logger.e(e);
        },
      );

      yield* controller.stream;
    }
  }

  @override
  Either<String, Unit> disconnectListener() {
    try {
      _mqttClient.disconnect();
      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }
}
