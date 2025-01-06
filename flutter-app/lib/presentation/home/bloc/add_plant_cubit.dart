import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/datasources/datasources.dart';
import 'package:smart_plant_pot/dtos/dtos.dart';
import 'package:smart_plant_pot/models/models.dart';

part 'add_plant_state.dart';

part 'add_plant_cubit.freezed.dart';

@injectable
class AddPlantCubit extends Cubit<AddPlantState> {
  AddPlantCubit(this._userDataSource) : super(const AddPlantState.initial());

  final UserDataSource _userDataSource;

  void addPlant(AddPlantDto plant) async {
    emit(const AddPlantState.loading());
    final result = await _userDataSource.addPlant(plant);
    result.fold(
      (error) => emit(AddPlantState.error(error)),
      (_) => emit(const AddPlantState.success()),
    );
  }
}
