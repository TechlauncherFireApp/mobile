import 'dart:async';
import 'package:fireapp/data/persistence/db/reference_data_db_dao.dart';
import 'package:fireapp/data/persistence/db/reference_data_db_metadata_dao.dart';
import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:floor/floor.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'db.g.dart'; // the generated code will be there

@Database(version: 1, entities: [ReferenceDataDb, ReferenceDataDbMetadata])
abstract class AppDatabase extends FloorDatabase {
  ReferenceDataDbDao get referenceDataDbDao;
  ReferenceDataDbMetadataDao get referenceDataDbMetadataDao;
}

@module
abstract class DBDependencyInjection {

  @singleton
  Future<AppDatabase> createDb() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  @singleton
  ReferenceDataDbDao createReferenceDataDbDao(AppDatabase db) {
    return db.referenceDataDbDao;
  }

  @singleton
  ReferenceDataDbMetadataDao createReferenceDataDbMetadataDao(AppDatabase db) {
    return db.referenceDataDbMetadataDao;
  }

}