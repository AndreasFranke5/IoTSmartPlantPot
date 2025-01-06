import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/datasources/datasources.dart';
import 'package:smart_plant_pot/models/models.dart';

part 'plant_details_state.dart';

part 'plant_details_cubit.freezed.dart';

@injectable
class PlantDetailsCubit extends Cubit<PlantDetailsState> {
  PlantDetailsCubit(this._plantDataSource) : super(const PlantDetailsState.initial());

  final PlantDataSource _plantDataSource;

  Future<void> getPlantSlotDetails(String slotId) async {
    emit(const PlantDetailsLoading());
    final res = await _plantDataSource.getPlantSlotDetails(slotId);
    res.fold(
      (error) => emit(PlantDetailsError(error)),
      (data) => emit(PlantDetailsSuccess(data)),
    );
  }
}
