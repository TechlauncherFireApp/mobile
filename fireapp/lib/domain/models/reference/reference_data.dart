
import 'package:fireapp/domain/models/base/identifiable.dart';

enum ReferenceDataType {
  qualification, role, assetType
}

abstract class ReferenceData extends Identifiable<int> {

  String get name;
  DateTime get updated;
  DateTime get created;

}

abstract class CodeableReferenceData extends ReferenceData {

  String get code;

}