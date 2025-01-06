part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    List<Device>? devices,
    List<Plant>? plants,
    @Default([]) List<PlantStat> plantsStats,
    @Default(false) bool isLoadingPlantStats,
    @Default([]) List<PredefinedPlant> predefinedPlants,
    @Default(false) bool isLoadingPredefinedPlants,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState();
}
