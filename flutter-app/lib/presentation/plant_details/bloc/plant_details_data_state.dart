part of 'plant_details_data_cubit.dart';

@freezed
class PlantDetailsDataState with _$PlantDetailsDataState {
  const factory PlantDetailsDataState({
    @Default(false) bool isLoading,
    String? sunlight,
    double? temperature,
    double? moisture,
  }) = _PlantDetailsDataState;

  factory PlantDetailsDataState.initial() => const PlantDetailsDataState();
}
