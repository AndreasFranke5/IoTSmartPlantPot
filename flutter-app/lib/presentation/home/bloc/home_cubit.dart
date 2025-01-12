import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/datasources/datasources.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';

part 'home_state.dart';

part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._userDataSource, this._plantDataSource) : super(HomeState.initial()) {
    getPredefinedPlants();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      getDevices();
      getPlants();
      getPlantsStats();
    });
  }

  late Timer _timer;

  final UserDataSource _userDataSource;
  final PlantDataSource _plantDataSource;

  Future<List<PredefinedPlant>> getPredefinedPlants({String? search}) async {
    emit(state.copyWith(isLoadingPredefinedPlants: true));
    final res = await _plantDataSource.getPredefinedPlants(search);
    return res.fold(
      (error) {
        addError(error);
        emit(state.copyWith(predefinedPlants: [], isLoadingPredefinedPlants: false));
        logger.e(error);
        return [];
      },
      (data) {
        emit(state.copyWith(predefinedPlants: List.of(data), isLoadingPredefinedPlants: false));
        return data;
      },
    );
  }

  Future<void> getDevices() async {
    final res = await _userDataSource.getUserDevices();
    res.fold(
      (error) {
        addError(error);
        emit(state.copyWith(devices: []));
        logger.e(error);
      },
      (devices) => emit(state.copyWith(devices: devices)),
    );
  }

  Future<void> getPlants() async {
    final res = await _userDataSource.getUserPlantSlots();
    res.fold(
      (error) {
        addError(error);
        emit(state.copyWith(plants: []));
        logger.e(error);
      },
      (plants) => emit(state.copyWith(plants: plants)),
    );
  }

  Future<void> getPlantsStats() async {
    emit(state.copyWith(isLoadingPlantStats: true));
    final res = await _userDataSource.getUserPlantStats();
    res.fold(
      (error) {
        addError(error);
        emit(state.copyWith(plantsStats: [], isLoadingPlantStats: false));
        logger.e(error);
      },
      (stats) async {
        emit(state.copyWith(isPlantStatsRefreshed: true));
        emit(state.copyWith(plantsStats: stats, isLoadingPlantStats: false));
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isPlantStatsRefreshed: false));
      },
    );
  }

  dispose() {
    _timer.cancel();
    super.close();
  }
}
