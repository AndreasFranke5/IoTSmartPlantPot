import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_slot.freezed.dart';

part 'plant_slot.g.dart';

@freezed
class PlantSlot with _$PlantSlot {
  const factory PlantSlot({
    required String deviceId,
    required String plantId,
  }) = _PlantSlot;

  factory PlantSlot.fromJson(Map<String, dynamic> json) => _$PlantSlotFromJson(json);
}
