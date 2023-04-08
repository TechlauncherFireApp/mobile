import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'qualification.freezed.dart';
part 'qualification.g.dart';

@freezed
class Qualification with _$Qualification {

  @Implements<ReferenceData>()
  const factory Qualification({
    required int id,
    required String name,
    required DateTime updated,
    required DateTime created
  }) = _Qualification;

  factory Qualification.fromJson(Map<String, Object?> json) => _$QualificationFromJson(json);

}