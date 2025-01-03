import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_plant_pot/models/device.dart';
import 'package:smart_plant_pot/models/plant.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required List<Device> devices,
    required List<Plant> plants,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
