import 'package:fireapp/data/client/reference_data_client.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReferenceDataRepository {

  final ReferenceDataClient _client;
  ReferenceDataRepository(this._client);


  // TODO, persist to local DB
  Future<List<Qualification>> getQualifications() {
    return _client.getQualifications();
  }

}