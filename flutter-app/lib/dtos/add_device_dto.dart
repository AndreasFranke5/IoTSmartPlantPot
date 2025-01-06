import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_device_dto.freezed.dart';

part 'add_device_dto.g.dart';

@freezed
class AddDeviceDto with _$AddDeviceDto {
  const factory AddDeviceDto({
    required String name,
    required String deviceId,
  }) = _AddDeviceDto;

  factory AddDeviceDto.fromJson(Map<String, dynamic> json) => _$AddDeviceDtoFromJson(json);
}
