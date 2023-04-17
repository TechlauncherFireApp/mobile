
import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'db/reference_data_db_dao.dart';
import 'db/reference_data_db_metadata_dao.dart';

@injectable
class ReferenceDataPersistence {

  late ReferenceDataDbDao _dataDbDao;
  late ReferenceDataDbMetadataDao _dataDbMetadataDao;
  late Future<void> isSetup;

  // coverage:ignore-start
  // This should be done through DI (hence .di), but asynchronous constructors are wack
  @factoryMethod
  ReferenceDataPersistence() {
    isSetup = () async {
      _dataDbDao = await GetIt.instance.getAsync();
      _dataDbMetadataDao = await GetIt.instance.getAsync();
    }();
  }
  // coverage:ignore-end

  ReferenceDataPersistence.di(this._dataDbDao, this._dataDbMetadataDao) {
    isSetup = Future.value(null);
  }

  Future<DateTime?> getLastUpdated(ReferenceDataType type) async {
    await isSetup;
    var metadata = await _dataDbMetadataDao.getByType(type.name);
    if (metadata == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(metadata.lastRefreshed);
  }

  Future<void> save(ReferenceDataType type, List<ReferenceDataDb> data) async {
    await isSetup;
    _dataDbMetadataDao.insertReferenceData(ReferenceDataDbMetadata(
      type: type.name,
      lastRefreshed: DateTime.now().millisecondsSinceEpoch
    ));
    _dataDbDao.insertReferenceData(data);
  }

  Future<List<ReferenceDataDb>> getReferenceData(ReferenceDataType type) async {
    await isSetup;
    return _dataDbDao.getByType(type.name);
  }

}