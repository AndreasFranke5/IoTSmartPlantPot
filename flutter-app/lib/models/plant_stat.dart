import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_stat.freezed.dart';

part 'plant_stat.g.dart';

@freezed
class PlantStat with _$PlantStat {
  const factory PlantStat({
    required String deviceId,
    required String slotId,
    double? temperature,
    int? moisture,
    double? uv,
    double? lux,
  }) = _PlantStat;

  factory PlantStat.fromJson(Map<String, dynamic> json) => _$PlantStatFromJson(json);
}
