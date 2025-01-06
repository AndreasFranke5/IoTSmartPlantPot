// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'predefined_plant.freezed.dart';

part 'predefined_plant.g.dart';

@freezed
class PredefinedPlant with _$PredefinedPlant {
  const factory PredefinedPlant({
    required int id,
    @JsonKey(name: 'display_name') required String name,
    @JsonKey(name: 'other_name') List<String>? otherNames,
    @JsonKey(name: 'scientific_name') @Default([]) List<String> scientificNames,
    @JsonKey(name: 'sunlight') List<String>? sunlightRequirements,
    @JsonKey(name: 'watering') String? wateringRequirements,
    String? image,
  }) = _PredefinedPlant;

  factory PredefinedPlant.fromJson(Map<String, dynamic> json) => _$PredefinedPlantFromJson(json);
}
