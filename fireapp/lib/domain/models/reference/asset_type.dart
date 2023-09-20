
import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_type.freezed.dart';
part 'asset_type.g.dart';

@freezed
class AssetType
    with _$AssetType
    implements CodeableReferenceData {

  @Implements<CodeableReferenceData>()
  const factory AssetType({
    required int id,
    required String name,
    required String code,
    required DateTime updated,
    required DateTime created
  }) = _AssetType;

  factory AssetType.fromJson(Map<String, Object?> json) => _$AssetTypeFromJson(json);

}