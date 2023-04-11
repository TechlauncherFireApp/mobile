import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:floor/floor.dart';


@entity
class ReferenceDataDb {

  @primaryKey
  final String pk;
  final String type;
  final int id;
  final String name;
  final String? code;
  final int updated;
  final int created;

  ReferenceDataDb({
    required this.pk,
    required this.type,
    required this.id,
    required this.name,
    this.code,
    required this.updated,
    required this.created
  });
}

@entity
class ReferenceDataDbMetadata {

  @primaryKey
  final String type;
  final int lastRefreshed;

  ReferenceDataDbMetadata({
    required this.type,
    required this.lastRefreshed
  });

}