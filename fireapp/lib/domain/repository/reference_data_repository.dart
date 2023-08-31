import 'package:fireapp/data/client/reference_data_client.dart';
import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:injectable/injectable.dart';

import '../../data/persistence/reference_data_persistence.dart';

@injectable
class ReferenceDataRepository {

  static const lifetime = 1000 * 60 * 60 * 24 * 31;

  final ReferenceDataClient _client;
  final ReferenceDataPersistence _persistence;
  ReferenceDataRepository(this._client, this._persistence);

  // TODO, persist to local DB
  Future<List<Qualification>> getQualifications() async {
    return _fetch<Qualification>(
        ReferenceDataType.qualification,
            (e) => Qualification(
            id: e.id,
            name: e.name,
            updated: DateTime.fromMillisecondsSinceEpoch(e.updated),
            created: DateTime.fromMillisecondsSinceEpoch(e.created)
        ),
            () => _client.getQualifications()
    );
  }

  Future<List<VolunteerRole>> getRoles() async {
    return _fetch<VolunteerRole>(
        ReferenceDataType.role,
            (e) => VolunteerRole(
            id: e.id,
            name: e.name,
            updated: DateTime.fromMillisecondsSinceEpoch(e.updated),
            created: DateTime.fromMillisecondsSinceEpoch(e.created),
        ),
            () => _client.getRoles()
    );
  }

  Future<List<AssetType>> getAssetType() async {
    return _fetch<AssetType>(
        ReferenceDataType.assetType,
            (e) => AssetType(
          id: e.id,
          name: e.name,
          code: e.code ?? "",
          updated: DateTime.fromMillisecondsSinceEpoch(e.updated),
          created: DateTime.fromMillisecondsSinceEpoch(e.created),
        ),
            () => _client.getAssetTypes()
    );
  }

  Future<List<T>> _fetch<T extends ReferenceData>(
      ReferenceDataType type,
      T Function(ReferenceDataDb) map,
      Future<List<T>> Function() get,
      ) async {
        var current = await _persistence.getLastUpdated(type);
        if (
        current != null &&
            current.millisecondsSinceEpoch + lifetime > DateTime.now().millisecondsSinceEpoch
        ) {
          return (await _persistence.getReferenceData(type)).map((e) => map(e)).toList();
        }
        var data = await get();

    _persistence.save(type, data.map((e) {
      return ReferenceDataDb(
          pk: "${type.name}_${e.id}",
          type: type.name,
          id: e.id,
          name: e.name,
          code: (e is CodeableReferenceData) ? e.code : null,
          updated: e.updated.millisecondsSinceEpoch,
          created: e.created.millisecondsSinceEpoch
      );
    }).toList());

    return data;
  }
}