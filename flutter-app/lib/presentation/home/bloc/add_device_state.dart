part of 'add_device_cubit.dart';

@freezed
class AddDeviceState with _$AddDeviceState {
  const factory AddDeviceState.initial() = _Initial;

  const factory AddDeviceState.loading() = AddDeviceLoading;

  const factory AddDeviceState.success() = AddDeviceSuccess;

  const factory AddDeviceState.error(String error) = AddDeviceError;
}
