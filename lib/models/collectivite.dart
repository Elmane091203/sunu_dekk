import 'package:freezed_annotation/freezed_annotation.dart';

part 'collectivite.freezed.dart';
part 'collectivite.g.dart';

@freezed
class Collectivite with _$Collectivite {
  const factory Collectivite({
    required int id,
    required String code,
    required String nom,
    String? type,
    String? region,
    @Default(true) bool actif,
  }) = _Collectivite;

  factory Collectivite.fromJson(Map<String, dynamic> json) =>
      _$CollectiviteFromJson(json);
}
