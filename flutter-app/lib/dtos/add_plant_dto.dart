import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_plant_dto.freezed.dart';

part 'add_plant_dto.g.dart';

@freezed
class AddPlantDto with _$AddPlantDto {
  const factory AddPlantDto({
    required String deviceId,
    required String slotId,
    required int plantId,
    required String name,
  }) = _AddPlantDto;

  factory AddPlantDto.fromJson(Map<String, dynamic> json) => _$AddPlantDtoFromJson(json);
}
