part of 'add_plant_cubit.dart';

@freezed
class AddPlantState with _$AddPlantState {
  const factory AddPlantState.initial() = _Initial;

  const factory AddPlantState.loading() = AddPlantLoading;

  const factory AddPlantState.success() = AddPlantSuccess;

  const factory AddPlantState.error(String error) = AddPlantError;
}
