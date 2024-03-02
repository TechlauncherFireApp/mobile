import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'qualification.freezed.dart';
part 'qualification.g.dart';

@freezed
class Qualification with _$Qualification {
  const factory Qualification({
    required int id,
    required String name,
    required bool deleted,
    @JsonKey(name: 'update_datetime') DateTime? updateDateTime,
    @JsonKey(name: 'insert_datetime') DateTime? insertDateTime,
  }) = _Qualification;

  factory Qualification.fromJson(Map<String, dynamic> json) => _$QualificationFromJson(json);
}