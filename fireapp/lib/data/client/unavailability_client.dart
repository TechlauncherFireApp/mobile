import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnavailabilityClient {
  final RestClient restClient;
  UnavailabilityClient(this.restClient);

  // Send an HTTP request to create new unavailability event in the calendar
  Future<void> createUnavailabilityEvent(
      int userId, UnavailabilityEventPost newEvent) {
    return restClient.createUnavailabilityEvent(userId, newEvent);
  }
}
