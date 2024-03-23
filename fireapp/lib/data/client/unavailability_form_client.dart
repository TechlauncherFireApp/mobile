import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnavailabilityFormClient {

  final RestClient restClient;
  UnavailabilityFormClient(this.restClient);

  Future<void> createUnavailabilityEvent(int userId,UnavailabilityEventPost newEvent){
    return restClient.createUnavailabilityEvent(userId,newEvent);
  }

}