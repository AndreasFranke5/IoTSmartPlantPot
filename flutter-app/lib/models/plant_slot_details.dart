// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_slot_details.freezed.dart';

part 'plant_slot_details.g.dart';

@freezed
class PlantSlotDetails with _$PlantSlotDetails {
  const factory PlantSlotDetails({
    required String id,
    required String deviceId,
    required String name,
    required int plantId,
    @JsonKey(name: 'display_name') required String plantName,
    @JsonKey(name: 'other_name') List<String>? otherNames,
    @JsonKey(name: 'scientific_name') @Default([]) List<String> scientificNames,
    @JsonKey(name: 'sunlight') List<String>? sunlightRequirements,
    @JsonKey(name: 'watering') String? wateringRequirements,
    String? image,
  }) = _PlantSlotDetails;

  factory PlantSlotDetails.fromJson(Map<String, dynamic> json) => _$PlantSlotDetailsFromJson(json);
}
