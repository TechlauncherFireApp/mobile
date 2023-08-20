import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'results.freezed.dart';
part 'results.g.dart';

@freezed
class Results<T> with _$Results<T> {

  @JsonSerializable(genericArgumentFactories: true)
  const factory Results({
    required List<T> results,
  }) = _Results<T>;

  factory Results.fromJson(Map<String, Object?> json, T Function(Object? json) fromJsonT) => _$ResultsFromJson(json);
}