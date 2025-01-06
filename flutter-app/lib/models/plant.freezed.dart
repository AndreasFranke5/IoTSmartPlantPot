// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Plant _$PlantFromJson(Map<String, dynamic> json) {
  switch (json['status']) {
    case 'data':
      return PlantData.fromJson(json);
    case 'empty':
      return PlantEmpty.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'status', 'Plant', 'Invalid union type "${json['status']}"!');
  }
}

/// @nodoc
mixin _$Plant {
  String get id => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id, String deviceId, int plantId, String name, String? image)
        data,
    required TResult Function(String id, String deviceId) empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String deviceId, int plantId, String name,
            String? image)?
        data,
    TResult? Function(String id, String deviceId)? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String deviceId, int plantId, String name,
            String? image)?
        data,
    TResult Function(String id, String deviceId)? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantData value) data,
    required TResult Function(PlantEmpty value) empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantData value)? data,
    TResult? Function(PlantEmpty value)? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantData value)? data,
    TResult Function(PlantEmpty value)? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Plant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlantCopyWith<Plant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantCopyWith<$Res> {
  factory $PlantCopyWith(Plant value, $Res Function(Plant) then) =
      _$PlantCopyWithImpl<$Res, Plant>;
  @useResult
  $Res call({String id, String deviceId});
}

/// @nodoc
class _$PlantCopyWithImpl<$Res, $Val extends Plant>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantDataImplCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$$PlantDataImplCopyWith(
          _$PlantDataImpl value, $Res Function(_$PlantDataImpl) then) =
      __$$PlantDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String deviceId, int plantId, String name, String? image});
}

/// @nodoc
class __$$PlantDataImplCopyWithImpl<$Res>
    extends _$PlantCopyWithImpl<$Res, _$PlantDataImpl>
    implements _$$PlantDataImplCopyWith<$Res> {
  __$$PlantDataImplCopyWithImpl(
      _$PlantDataImpl _value, $Res Function(_$PlantDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? plantId = null,
    Object? name = null,
    Object? image = freezed,
  }) {
    return _then(_$PlantDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantDataImpl implements PlantData {
  const _$PlantDataImpl(
      {required this.id,
      required this.deviceId,
      required this.plantId,
      required this.name,
      this.image,
      final String? $type})
      : $type = $type ?? 'data';

  factory _$PlantDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantDataImplFromJson(json);

  @override
  final String id;
  @override
  final String deviceId;
  @override
  final int plantId;
  @override
  final String name;
// required DateTime addedOn,
  @override
  final String? image;

  @JsonKey(name: 'status')
  final String $type;

  @override
  String toString() {
    return 'Plant.data(id: $id, deviceId: $deviceId, plantId: $plantId, name: $name, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, deviceId, plantId, name, image);

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantDataImplCopyWith<_$PlantDataImpl> get copyWith =>
      __$$PlantDataImplCopyWithImpl<_$PlantDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id, String deviceId, int plantId, String name, String? image)
        data,
    required TResult Function(String id, String deviceId) empty,
  }) {
    return data(id, deviceId, plantId, name, image);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String deviceId, int plantId, String name,
            String? image)?
        data,
    TResult? Function(String id, String deviceId)? empty,
  }) {
    return data?.call(id, deviceId, plantId, name, image);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String deviceId, int plantId, String name,
            String? image)?
        data,
    TResult Function(String id, String deviceId)? empty,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(id, deviceId, plantId, name, image);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantData value) data,
    required TResult Function(PlantEmpty value) empty,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantData value)? data,
    TResult? Function(PlantEmpty value)? empty,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantData value)? data,
    TResult Function(PlantEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantDataImplToJson(
      this,
    );
  }
}

abstract class PlantData implements Plant {
  const factory PlantData(
      {required final String id,
      required final String deviceId,
      required final int plantId,
      required final String name,
      final String? image}) = _$PlantDataImpl;

  factory PlantData.fromJson(Map<String, dynamic> json) =
      _$PlantDataImpl.fromJson;

  @override
  String get id;
  @override
  String get deviceId;
  int get plantId;
  String get name; // required DateTime addedOn,
  String? get image;

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlantDataImplCopyWith<_$PlantDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlantEmptyImplCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$$PlantEmptyImplCopyWith(
          _$PlantEmptyImpl value, $Res Function(_$PlantEmptyImpl) then) =
      __$$PlantEmptyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String deviceId});
}

/// @nodoc
class __$$PlantEmptyImplCopyWithImpl<$Res>
    extends _$PlantCopyWithImpl<$Res, _$PlantEmptyImpl>
    implements _$$PlantEmptyImplCopyWith<$Res> {
  __$$PlantEmptyImplCopyWithImpl(
      _$PlantEmptyImpl _value, $Res Function(_$PlantEmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
  }) {
    return _then(_$PlantEmptyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantEmptyImpl implements PlantEmpty {
  const _$PlantEmptyImpl(
      {required this.id, required this.deviceId, final String? $type})
      : $type = $type ?? 'empty';

  factory _$PlantEmptyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantEmptyImplFromJson(json);

  @override
  final String id;
  @override
  final String deviceId;

  @JsonKey(name: 'status')
  final String $type;

  @override
  String toString() {
    return 'Plant.empty(id: $id, deviceId: $deviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantEmptyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, deviceId);

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantEmptyImplCopyWith<_$PlantEmptyImpl> get copyWith =>
      __$$PlantEmptyImplCopyWithImpl<_$PlantEmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id, String deviceId, int plantId, String name, String? image)
        data,
    required TResult Function(String id, String deviceId) empty,
  }) {
    return empty(id, deviceId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String deviceId, int plantId, String name,
            String? image)?
        data,
    TResult? Function(String id, String deviceId)? empty,
  }) {
    return empty?.call(id, deviceId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String deviceId, int plantId, String name,
            String? image)?
        data,
    TResult Function(String id, String deviceId)? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(id, deviceId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantData value) data,
    required TResult Function(PlantEmpty value) empty,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantData value)? data,
    TResult? Function(PlantEmpty value)? empty,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantData value)? data,
    TResult Function(PlantEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantEmptyImplToJson(
      this,
    );
  }
}

abstract class PlantEmpty implements Plant {
  const factory PlantEmpty(
      {required final String id,
      required final String deviceId}) = _$PlantEmptyImpl;

  factory PlantEmpty.fromJson(Map<String, dynamic> json) =
      _$PlantEmptyImpl.fromJson;

  @override
  String get id;
  @override
  String get deviceId;

  /// Create a copy of Plant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlantEmptyImplCopyWith<_$PlantEmptyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
