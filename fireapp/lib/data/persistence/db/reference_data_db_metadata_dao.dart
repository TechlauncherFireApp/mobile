import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:floor/floor.dart';

@dao
abstract class ReferenceDataDbMetadataDao {
  @Query('SELECT * FROM ReferenceDataDbMetadata WHERE type = :type')
  Future<ReferenceDataDbMetadata?> getByType(String type);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertReferenceData(ReferenceDataDbMetadata referenceData);
}
