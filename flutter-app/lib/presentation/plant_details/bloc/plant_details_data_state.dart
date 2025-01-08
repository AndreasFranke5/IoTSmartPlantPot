part of 'plant_details_data_cubit.dart';

@freezed
class PlantDetailsDataState with _$PlantDetailsDataState {
  const factory PlantDetailsDataState({
    @Default(false) bool isLoading,
    double? temperature,
    int? moisture,
    double? uv,
    double? lux,
  }) = _PlantDetailsDataState;

  factory PlantDetailsDataState.initial() => const PlantDetailsDataState();
}
