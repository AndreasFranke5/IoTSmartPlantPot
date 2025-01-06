import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_plant_pot/models/models.dart';

part 'device.freezed.dart';

part 'device.g.dart';

@freezed
class Device with _$Device {
  const factory Device({
    required String deviceId,
    required String name,
  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}
