import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';

part 'plant.g.dart';

@Freezed(unionKey: 'status', unionValueCase: FreezedUnionCase.none)
class Plant with _$Plant {
  const factory Plant.data({
    required String id,
    required String deviceId,
    required int plantId,
    required String name,
    // required DateTime addedOn,
    String? image,
  }) = PlantData;

  const factory Plant.empty({
    required String id,
    required String deviceId,
  }) = PlantEmpty;

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);
}
