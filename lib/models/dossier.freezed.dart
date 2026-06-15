// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dossier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Dossier _$DossierFromJson(Map<String, dynamic> json) {
  return _Dossier.fromJson(json);
}

/// @nodoc
mixin _$Dossier {
  int get id => throw _privateConstructorUsedError;
  String get numero => throw _privateConstructorUsedError;
  StatutDossier get statut => throw _privateConstructorUsedError;
  PrioriteDossier get priorite => throw _privateConstructorUsedError;
  int get typeDemarcheId => throw _privateConstructorUsedError;
  int? get citoyenId => throw _privateConstructorUsedError;
  int? get agentId => throw _privateConstructorUsedError;
  int? get collectiviteId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get dateSoumission => throw _privateConstructorUsedError;
  DateTime? get dateEcheance => throw _privateConstructorUsedError;

  /// Serializes this Dossier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dossier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DossierCopyWith<Dossier> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DossierCopyWith<$Res> {
  factory $DossierCopyWith(Dossier value, $Res Function(Dossier) then) =
      _$DossierCopyWithImpl<$Res, Dossier>;
  @useResult
  $Res call({
    int id,
    String numero,
    StatutDossier statut,
    PrioriteDossier priorite,
    int typeDemarcheId,
    int? citoyenId,
    int? agentId,
    int? collectiviteId,
    String? description,
    DateTime? dateSoumission,
    DateTime? dateEcheance,
  });
}

/// @nodoc
class _$DossierCopyWithImpl<$Res, $Val extends Dossier>
    implements $DossierCopyWith<$Res> {
  _$DossierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dossier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numero = null,
    Object? statut = null,
    Object? priorite = null,
    Object? typeDemarcheId = null,
    Object? citoyenId = freezed,
    Object? agentId = freezed,
    Object? collectiviteId = freezed,
    Object? description = freezed,
    Object? dateSoumission = freezed,
    Object? dateEcheance = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            numero: null == numero
                ? _value.numero
                : numero // ignore: cast_nullable_to_non_nullable
                      as String,
            statut: null == statut
                ? _value.statut
                : statut // ignore: cast_nullable_to_non_nullable
                      as StatutDossier,
            priorite: null == priorite
                ? _value.priorite
                : priorite // ignore: cast_nullable_to_non_nullable
                      as PrioriteDossier,
            typeDemarcheId: null == typeDemarcheId
                ? _value.typeDemarcheId
                : typeDemarcheId // ignore: cast_nullable_to_non_nullable
                      as int,
            citoyenId: freezed == citoyenId
                ? _value.citoyenId
                : citoyenId // ignore: cast_nullable_to_non_nullable
                      as int?,
            agentId: freezed == agentId
                ? _value.agentId
                : agentId // ignore: cast_nullable_to_non_nullable
                      as int?,
            collectiviteId: freezed == collectiviteId
                ? _value.collectiviteId
                : collectiviteId // ignore: cast_nullable_to_non_nullable
                      as int?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateSoumission: freezed == dateSoumission
                ? _value.dateSoumission
                : dateSoumission // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dateEcheance: freezed == dateEcheance
                ? _value.dateEcheance
                : dateEcheance // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DossierImplCopyWith<$Res> implements $DossierCopyWith<$Res> {
  factory _$$DossierImplCopyWith(
    _$DossierImpl value,
    $Res Function(_$DossierImpl) then,
  ) = __$$DossierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String numero,
    StatutDossier statut,
    PrioriteDossier priorite,
    int typeDemarcheId,
    int? citoyenId,
    int? agentId,
    int? collectiviteId,
    String? description,
    DateTime? dateSoumission,
    DateTime? dateEcheance,
  });
}

/// @nodoc
class __$$DossierImplCopyWithImpl<$Res>
    extends _$DossierCopyWithImpl<$Res, _$DossierImpl>
    implements _$$DossierImplCopyWith<$Res> {
  __$$DossierImplCopyWithImpl(
    _$DossierImpl _value,
    $Res Function(_$DossierImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Dossier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numero = null,
    Object? statut = null,
    Object? priorite = null,
    Object? typeDemarcheId = null,
    Object? citoyenId = freezed,
    Object? agentId = freezed,
    Object? collectiviteId = freezed,
    Object? description = freezed,
    Object? dateSoumission = freezed,
    Object? dateEcheance = freezed,
  }) {
    return _then(
      _$DossierImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        numero: null == numero
            ? _value.numero
            : numero // ignore: cast_nullable_to_non_nullable
                  as String,
        statut: null == statut
            ? _value.statut
            : statut // ignore: cast_nullable_to_non_nullable
                  as StatutDossier,
        priorite: null == priorite
            ? _value.priorite
            : priorite // ignore: cast_nullable_to_non_nullable
                  as PrioriteDossier,
        typeDemarcheId: null == typeDemarcheId
            ? _value.typeDemarcheId
            : typeDemarcheId // ignore: cast_nullable_to_non_nullable
                  as int,
        citoyenId: freezed == citoyenId
            ? _value.citoyenId
            : citoyenId // ignore: cast_nullable_to_non_nullable
                  as int?,
        agentId: freezed == agentId
            ? _value.agentId
            : agentId // ignore: cast_nullable_to_non_nullable
                  as int?,
        collectiviteId: freezed == collectiviteId
            ? _value.collectiviteId
            : collectiviteId // ignore: cast_nullable_to_non_nullable
                  as int?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateSoumission: freezed == dateSoumission
            ? _value.dateSoumission
            : dateSoumission // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dateEcheance: freezed == dateEcheance
            ? _value.dateEcheance
            : dateEcheance // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DossierImpl implements _Dossier {
  const _$DossierImpl({
    required this.id,
    required this.numero,
    required this.statut,
    required this.priorite,
    required this.typeDemarcheId,
    this.citoyenId,
    this.agentId,
    this.collectiviteId,
    this.description,
    this.dateSoumission,
    this.dateEcheance,
  });

  factory _$DossierImpl.fromJson(Map<String, dynamic> json) =>
      _$$DossierImplFromJson(json);

  @override
  final int id;
  @override
  final String numero;
  @override
  final StatutDossier statut;
  @override
  final PrioriteDossier priorite;
  @override
  final int typeDemarcheId;
  @override
  final int? citoyenId;
  @override
  final int? agentId;
  @override
  final int? collectiviteId;
  @override
  final String? description;
  @override
  final DateTime? dateSoumission;
  @override
  final DateTime? dateEcheance;

  @override
  String toString() {
    return 'Dossier(id: $id, numero: $numero, statut: $statut, priorite: $priorite, typeDemarcheId: $typeDemarcheId, citoyenId: $citoyenId, agentId: $agentId, collectiviteId: $collectiviteId, description: $description, dateSoumission: $dateSoumission, dateEcheance: $dateEcheance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DossierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.numero, numero) || other.numero == numero) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.priorite, priorite) ||
                other.priorite == priorite) &&
            (identical(other.typeDemarcheId, typeDemarcheId) ||
                other.typeDemarcheId == typeDemarcheId) &&
            (identical(other.citoyenId, citoyenId) ||
                other.citoyenId == citoyenId) &&
            (identical(other.agentId, agentId) || other.agentId == agentId) &&
            (identical(other.collectiviteId, collectiviteId) ||
                other.collectiviteId == collectiviteId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dateSoumission, dateSoumission) ||
                other.dateSoumission == dateSoumission) &&
            (identical(other.dateEcheance, dateEcheance) ||
                other.dateEcheance == dateEcheance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    numero,
    statut,
    priorite,
    typeDemarcheId,
    citoyenId,
    agentId,
    collectiviteId,
    description,
    dateSoumission,
    dateEcheance,
  );

  /// Create a copy of Dossier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DossierImplCopyWith<_$DossierImpl> get copyWith =>
      __$$DossierImplCopyWithImpl<_$DossierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DossierImplToJson(this);
  }
}

abstract class _Dossier implements Dossier {
  const factory _Dossier({
    required final int id,
    required final String numero,
    required final StatutDossier statut,
    required final PrioriteDossier priorite,
    required final int typeDemarcheId,
    final int? citoyenId,
    final int? agentId,
    final int? collectiviteId,
    final String? description,
    final DateTime? dateSoumission,
    final DateTime? dateEcheance,
  }) = _$DossierImpl;

  factory _Dossier.fromJson(Map<String, dynamic> json) = _$DossierImpl.fromJson;

  @override
  int get id;
  @override
  String get numero;
  @override
  StatutDossier get statut;
  @override
  PrioriteDossier get priorite;
  @override
  int get typeDemarcheId;
  @override
  int? get citoyenId;
  @override
  int? get agentId;
  @override
  int? get collectiviteId;
  @override
  String? get description;
  @override
  DateTime? get dateSoumission;
  @override
  DateTime? get dateEcheance;

  /// Create a copy of Dossier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DossierImplCopyWith<_$DossierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
