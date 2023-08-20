import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// This associates 'new_request.dart' with the code generated by Freezed
part 'new_request.freezed.dart';

// Immutable data class representing the input for a post request.
@freezed
class PostRequestInput with _$PostRequestInput {
  const factory PostRequestInput({
    required String title,
    required String status,
  }) =
  _PostRequestInput; // Named private constructor for the actual implementation
}

// Immutable data class representing the input for a delete request.
@freezed
class DeleteRequestInput with _$DeleteRequestInput {
  const factory DeleteRequestInput({
    required String requestID,
  }) = _DeleteRequestInput;
}

// Immutable data class representing the output for a post request.
@freezed
class PostRequestOutput with _$PostRequestOutput {
  const factory PostRequestOutput({
    required String id,
  }) =
  _PostRequestOutput;
}

// Immutable data class representing the output for a delete request.
@freezed
class DeleteRequestOutput with _$DeleteRequestOutput {
  const factory DeleteRequestOutput({
    required bool success,
  }) =
  _DeleteRequestOutput;
}
