// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'type_demarche.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TypeDemarche _$TypeDemarcheFromJson(Map<String, dynamic> json) {
  return _TypeDemarche.fromJson(json);
}

/// @nodoc
mixin _$TypeDemarche {
  int get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get categorie => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get delaiJours => throw _privateConstructorUsedError;

  /// Serializes this TypeDemarche to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TypeDemarche
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TypeDemarcheCopyWith<TypeDemarche> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypeDemarcheCopyWith<$Res> {
  factory $TypeDemarcheCopyWith(
    TypeDemarche value,
    $Res Function(TypeDemarche) then,
  ) = _$TypeDemarcheCopyWithImpl<$Res, TypeDemarche>;
  @useResult
  $Res call({
    int id,
    String code,
    String nom,
    String categorie,
    String? description,
    int delaiJours,
  });
}

/// @nodoc
class _$TypeDemarcheCopyWithImpl<$Res, $Val extends TypeDemarche>
    implements $TypeDemarcheCopyWith<$Res> {
  _$TypeDemarcheCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TypeDemarche
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? nom = null,
    Object? categorie = null,
    Object? description = freezed,
    Object? delaiJours = null,
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
            categorie: null == categorie
                ? _value.categorie
                : categorie // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            delaiJours: null == delaiJours
                ? _value.delaiJours
                : delaiJours // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TypeDemarcheImplCopyWith<$Res>
    implements $TypeDemarcheCopyWith<$Res> {
  factory _$$TypeDemarcheImplCopyWith(
    _$TypeDemarcheImpl value,
    $Res Function(_$TypeDemarcheImpl) then,
  ) = __$$TypeDemarcheImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String code,
    String nom,
    String categorie,
    String? description,
    int delaiJours,
  });
}

/// @nodoc
class __$$TypeDemarcheImplCopyWithImpl<$Res>
    extends _$TypeDemarcheCopyWithImpl<$Res, _$TypeDemarcheImpl>
    implements _$$TypeDemarcheImplCopyWith<$Res> {
  __$$TypeDemarcheImplCopyWithImpl(
    _$TypeDemarcheImpl _value,
    $Res Function(_$TypeDemarcheImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TypeDemarche
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? nom = null,
    Object? categorie = null,
    Object? description = freezed,
    Object? delaiJours = null,
  }) {
    return _then(
      _$TypeDemarcheImpl(
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
        categorie: null == categorie
            ? _value.categorie
            : categorie // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        delaiJours: null == delaiJours
            ? _value.delaiJours
            : delaiJours // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TypeDemarcheImpl implements _TypeDemarche {
  const _$TypeDemarcheImpl({
    required this.id,
    required this.code,
    required this.nom,
    required this.categorie,
    this.description,
    this.delaiJours = 0,
  });

  factory _$TypeDemarcheImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypeDemarcheImplFromJson(json);

  @override
  final int id;
  @override
  final String code;
  @override
  final String nom;
  @override
  final String categorie;
  @override
  final String? description;
  @override
  @JsonKey()
  final int delaiJours;

  @override
  String toString() {
    return 'TypeDemarche(id: $id, code: $code, nom: $nom, categorie: $categorie, description: $description, delaiJours: $delaiJours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypeDemarcheImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.categorie, categorie) ||
                other.categorie == categorie) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.delaiJours, delaiJours) ||
                other.delaiJours == delaiJours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    nom,
    categorie,
    description,
    delaiJours,
  );

  /// Create a copy of TypeDemarche
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TypeDemarcheImplCopyWith<_$TypeDemarcheImpl> get copyWith =>
      __$$TypeDemarcheImplCopyWithImpl<_$TypeDemarcheImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypeDemarcheImplToJson(this);
  }
}

abstract class _TypeDemarche implements TypeDemarche {
  const factory _TypeDemarche({
    required final int id,
    required final String code,
    required final String nom,
    required final String categorie,
    final String? description,
    final int delaiJours,
  }) = _$TypeDemarcheImpl;

  factory _TypeDemarche.fromJson(Map<String, dynamic> json) =
      _$TypeDemarcheImpl.fromJson;

  @override
  int get id;
  @override
  String get code;
  @override
  String get nom;
  @override
  String get categorie;
  @override
  String? get description;
  @override
  int get delaiJours;

  /// Create a copy of TypeDemarche
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TypeDemarcheImplCopyWith<_$TypeDemarcheImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
