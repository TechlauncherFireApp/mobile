
import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:injectable/injectable.dart';

import 'db/reference_data_db_dao.dart';
import 'db/reference_data_db_metadata_dao.dart';

@injectable
class ReferenceDataPersistence {

  final ReferenceDataDbDao _dataDbDao;
  final ReferenceDataDbMetadataDao _dataDbMetadataDao;
  ReferenceDataPersistence(this._dataDbDao, this._dataDbMetadataDao);

  Future<DateTime?> getLastUpdated(ReferenceDataType type) async {
    var metadata = await _dataDbMetadataDao.getByType(type.name);
    if (metadata == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(metadata.lastRefreshed);
  }

  Future<void> save(ReferenceDataType type, List<ReferenceDataDb> data) async {
    _dataDbMetadataDao.insertReferenceData(ReferenceDataDbMetadata(
      type: type.name,
      lastRefreshed: DateTime.now().millisecondsSinceEpoch
    ));
    _dataDbDao.insertReferenceData(data);
  }

  Future<List<ReferenceDataDb>> getReferenceData(ReferenceDataType type) async {
    return _dataDbDao.getByType(type.name);
  }

}