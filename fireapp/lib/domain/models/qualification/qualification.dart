// new_qualification.dart

import 'package:freezed_annotation/freezed_annotation.dart';
part 'new_qualification.freezed.dart';
part 'new_qualification.g.dart';

@freezed
class NewQualification with _$NewQualification {
  const factory NewQualification({
    required int id,
    required String name,
    required bool deleted,
    DateTime? updateDateTime,
    DateTime? insertDateTime,
  }) = _NewQualification;

  factory NewQualification.fromJson(Map<String, dynamic> json) => _$NewQualificationFromJson(json);
}