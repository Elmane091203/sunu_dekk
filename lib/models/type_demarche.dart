import 'package:freezed_annotation/freezed_annotation.dart';

part 'type_demarche.freezed.dart';
part 'type_demarche.g.dart';

@freezed
class TypeDemarche with _$TypeDemarche {
  const factory TypeDemarche({
    required int id,
    required String code,
    required String nom,
    required String categorie,
    String? description,
    @Default(0) int delaiJours,
  }) = _TypeDemarche;

  factory TypeDemarche.fromJson(Map<String, dynamic> json) =>
      _$TypeDemarcheFromJson(json);
}
