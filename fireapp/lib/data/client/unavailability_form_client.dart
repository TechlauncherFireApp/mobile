import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnavailabilityFormClient {

  final RestClient restClient;
  UnavailabilityFormClient(this.restClient);

  Future<void> makeNewUnavailabilityEvent(UnavailabilityTime newEvent){
    return restClient.makeNewUnavailabilityEvent(newEvent);
  }

}