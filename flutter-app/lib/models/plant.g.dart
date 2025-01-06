// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantDataImpl _$$PlantDataImplFromJson(Map<String, dynamic> json) =>
    _$PlantDataImpl(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      plantId: (json['plantId'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String?,
      $type: json['status'] as String?,
    );

Map<String, dynamic> _$$PlantDataImplToJson(_$PlantDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'plantId': instance.plantId,
      'name': instance.name,
      'image': instance.image,
      'status': instance.$type,
    };

_$PlantEmptyImpl _$$PlantEmptyImplFromJson(Map<String, dynamic> json) =>
    _$PlantEmptyImpl(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      $type: json['status'] as String?,
    );

Map<String, dynamic> _$$PlantEmptyImplToJson(_$PlantEmptyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'status': instance.$type,
    };
