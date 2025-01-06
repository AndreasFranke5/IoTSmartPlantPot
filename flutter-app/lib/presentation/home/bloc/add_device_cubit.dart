import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/datasources/datasources.dart';
import 'package:smart_plant_pot/dtos/dtos.dart';
import 'package:smart_plant_pot/models/models.dart';

part 'add_device_state.dart';

part 'add_device_cubit.freezed.dart';

@injectable
class AddDeviceCubit extends Cubit<AddDeviceState> {
  AddDeviceCubit(this._userDataSource) : super(const AddDeviceState.initial());

  final UserDataSource _userDataSource;

  void addDevice(AddDeviceDto device) async {
    emit(const AddDeviceState.loading());
    final result = await _userDataSource.addDevice(device);
    result.fold(
      (error) => emit(AddDeviceState.error(error)),
      (_) => emit(const AddDeviceState.success()),
    );
  }
}
