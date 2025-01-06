part of 'plant_details_cubit.dart';

@freezed
class PlantDetailsState with _$PlantDetailsState {
  const factory PlantDetailsState.initial() = _Initial;

  const factory PlantDetailsState.loading() = PlantDetailsLoading;

  const factory PlantDetailsState.success(PlantSlotDetails plant) = PlantDetailsSuccess;

  const factory PlantDetailsState.error(String error) = PlantDetailsError;
}
