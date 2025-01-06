import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'plant_details_data_state.dart';
part 'plant_details_data_cubit.freezed.dart';

@injectable
class PlantDetailsDataCubit extends Cubit<PlantDetailsDataState> {
  PlantDetailsDataCubit() : super( PlantDetailsDataState.initial());

  void detailsListener() {
    emit( state.copyWith(isLoading: true));
    // TODO: mqtt listener
    emit( state.copyWith(isLoading: false));
  }
}
