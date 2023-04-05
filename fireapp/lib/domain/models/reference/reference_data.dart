
import 'package:fireapp/domain/models/base/identifiable.dart';

abstract class ReferenceData extends Identifiable<int> {

  String get name;
  DateTime get updated;
  DateTime get created;
  bool get deleted;

}

abstract class CodeableReferenceData extends ReferenceData {

  String get code;

}