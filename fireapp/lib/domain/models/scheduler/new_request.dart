import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'new_request.freezed.dart';
part 'new_request.g.dart';

@freezed
class NewRequest with _$NewRequest {

  const factory NewRequest({
    required String title,
    required String status,
  }) = _NewRequest;

  factory NewRequest.fromJson(Map<String, Object?> json) => _$NewRequestFromJson(json);

}