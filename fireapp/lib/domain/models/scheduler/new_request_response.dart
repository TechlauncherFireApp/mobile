import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'new_request_response.freezed.dart';
part 'new_request_response.g.dart';

@freezed
class NewRequestResponse with _$NewRequestResponse {

  const factory NewRequestResponse({
    required String id,
  }) = _NewRequestResponse;

  factory NewRequestResponse.fromJson(Map<String, Object?> json) => _$NewRequestResponseFromJson(json);

}