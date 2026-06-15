// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collectivite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Collectivite _$CollectiviteFromJson(Map<String, dynamic> json) {
  return _Collectivite.fromJson(json);
}

/// @nodoc
mixin _$Collectivite {
  int get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  bool get actif => throw _privateConstructorUsedError;

  /// Serializes this Collectivite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Collectivite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollectiviteCopyWith<Collectivite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectiviteCopyWith<$Res> {
  factory $CollectiviteCopyWith(
    Collectivite value,
    $Res Function(Collectivite) then,
  ) = _$CollectiviteCopyWithImpl<$Res, Collectivite>;
  @useResult
  $Res call({
    int id,
    String code,
    String nom,
    String? type,
    String? region,
    bool actif,
  });
}

/// @nodoc
class _$CollectiviteCopyWithImpl<$Res, $Val extends Collectivite>
    implements $CollectiviteCopyWith<$Res> {
  _$CollectiviteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Collectivite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? nom = null,
    Object? type = freezed,
    Object? region = freezed,
    Object? actif = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            nom: null == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            region: freezed == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as String?,
            actif: null == actif
                ? _value.actif
                : actif // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CollectiviteImplCopyWith<$Res>
    implements $CollectiviteCopyWith<$Res> {
  factory _$$CollectiviteImplCopyWith(
    _$CollectiviteImpl value,
    $Res Function(_$CollectiviteImpl) then,
  ) = __$$CollectiviteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String code,
    String nom,
    String? type,
    String? region,
    bool actif,
  });
}

/// @nodoc
class __$$CollectiviteImplCopyWithImpl<$Res>
    extends _$CollectiviteCopyWithImpl<$Res, _$CollectiviteImpl>
    implements _$$CollectiviteImplCopyWith<$Res> {
  __$$CollectiviteImplCopyWithImpl(
    _$CollectiviteImpl _value,
    $Res Function(_$CollectiviteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Collectivite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? nom = null,
    Object? type = freezed,
    Object? region = freezed,
    Object? actif = null,
  }) {
    return _then(
      _$CollectiviteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        region: freezed == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as String?,
        actif: null == actif
            ? _value.actif
            : actif // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectiviteImpl implements _Collectivite {
  const _$CollectiviteImpl({
    required this.id,
    required this.code,
    required this.nom,
    this.type,
    this.region,
    this.actif = true,
  });

  factory _$CollectiviteImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectiviteImplFromJson(json);

  @override
  final int id;
  @override
  final String code;
  @override
  final String nom;
  @override
  final String? type;
  @override
  final String? region;
  @override
  @JsonKey()
  final bool actif;

  @override
  String toString() {
    return 'Collectivite(id: $id, code: $code, nom: $nom, type: $type, region: $region, actif: $actif)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectiviteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.actif, actif) || other.actif == actif));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, code, nom, type, region, actif);

  /// Create a copy of Collectivite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectiviteImplCopyWith<_$CollectiviteImpl> get copyWith =>
      __$$CollectiviteImplCopyWithImpl<_$CollectiviteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectiviteImplToJson(this);
  }
}

abstract class _Collectivite implements Collectivite {
  const factory _Collectivite({
    required final int id,
    required final String code,
    required final String nom,
    final String? type,
    final String? region,
    final bool actif,
  }) = _$CollectiviteImpl;

  factory _Collectivite.fromJson(Map<String, dynamic> json) =
      _$CollectiviteImpl.fromJson;

  @override
  int get id;
  @override
  String get code;
  @override
  String get nom;
  @override
  String? get type;
  @override
  String? get region;
  @override
  bool get actif;

  /// Create a copy of Collectivite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectiviteImplCopyWith<_$CollectiviteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
