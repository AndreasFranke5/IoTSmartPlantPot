import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';

abstract class PlantDataSource {
  Future<Either<String, List<PredefinedPlant>>> getPredefinedPlants(String? search);

  Future<Either<String, PlantSlotDetails>> getPlantSlotDetails(String plantId);
}

@Singleton(as: PlantDataSource)
class PlantDataSourceImpl implements PlantDataSource {
  const PlantDataSourceImpl(this._httpClient, this._prefs);

  final Dio _httpClient;
  final SharedPreferences _prefs;

  @override
  Future<Either<String, List<PredefinedPlant>>> getPredefinedPlants(String? search) async {
    try {
      final idToken = _prefs.getString('idToken');
      final response = await _httpClient.get(
        '/getPredefinedPlants',
        options: Options(
          headers: {'authorization': 'Bearer $idToken'},
        ),
        queryParameters: {'search': search},
      );
      final plantsJsonList = List<dynamic>.from(response.data);
      if (plantsJsonList.isEmpty) return right([]);

      final plantsJsonMapList = List<Map<String, dynamic>>.from(plantsJsonList);
      final plants = plantsJsonMapList.map((d) => PredefinedPlant.fromJson(d)).toList();
      return right(plants);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, PlantSlotDetails>> getPlantSlotDetails(String slotId) async {
    try {
      final idToken = _prefs.getString('idToken');
      final response = await _httpClient.get(
        '/getPlantSlotDetails',
        options: Options(
          headers: {'authorization': 'Bearer $idToken'},
        ),
        queryParameters: {'slotId': slotId},
      );
      final slot = PlantSlotDetails.fromJson(response.data);
      return right(slot);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }
}
