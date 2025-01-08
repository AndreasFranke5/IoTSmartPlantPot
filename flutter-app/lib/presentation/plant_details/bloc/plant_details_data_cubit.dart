import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/datasources/datasources.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';

part 'plant_details_data_state.dart';

part 'plant_details_data_cubit.freezed.dart';

@injectable
class PlantDetailsDataCubit extends Cubit<PlantDetailsDataState> {
  PlantDetailsDataCubit(this._userDataSource) : super(PlantDetailsDataState.initial());
  final UserDataSource _userDataSource;
  bool _isOpen = true;

  StreamSubscription<Either<String, PlantStat>>? _stream;

  void init(String slotId) async {
    emit(state.copyWith(isLoading: true));

    if (_stream != null) _stream?.cancel();

    _stream = _userDataSource.listenToPlantData(slotId).listen(
      (either) {
        either.fold(
          (e) => logger.e(e),
          (x) {
            if (_isOpen) {
              emit(state.copyWith(
                isLoading: state.isLoading ? false : state.isLoading,
                moisture: x.moisture,
                temperature: x.temperature,
                uv: x.uv,
                lux: x.lux,
              ));
            }
          },
        );

        // if (either.isLeft()) return emit(OnNewMessageFailure(either.asLeft.getMessage));
        // emit(OnNewMessage(either.asRight));
      },
    )..onDone(() => _stream?.cancel());
  }

  @override
  Future<void> close() {
    _isOpen = false;
    _userDataSource.disconnectListener();
    _stream?.cancel();
    return super.close();
  }
}
