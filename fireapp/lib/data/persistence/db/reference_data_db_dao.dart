import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:floor/floor.dart';

@dao
abstract class ReferenceDataDbDao {
  @Query('SELECT * FROM ReferenceDataDb WHERE type = :type')
  Future<List<ReferenceDataDb>> getByType(String type);

  @Query("DELETE FROM ReferenceDataDb WHERE type = :type")
  Future<void> deleteByType(String type);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertReferenceData(List<ReferenceDataDb> referenceData);
}
