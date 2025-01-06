import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_stat.freezed.dart';

part 'plant_stat.g.dart';

@freezed
class PlantStat with _$PlantStat {
  const factory PlantStat({
    @JsonKey(name: 'plantId') required String slotId,
    required String deviceId,
    double? temperature,
    String? sunlight,
    double? moisture,
  }) = _PlantStat;

  factory PlantStat.fromJson(Map<String, dynamic> json) => _$PlantStatFromJson(json);
}
