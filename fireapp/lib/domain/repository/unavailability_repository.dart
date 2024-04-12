import 'package:fireapp/data/client/unavailability_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnavailabilityRepository {
  final UnavailabilityClient unavailabilityClient;

  UnavailabilityRepository(this.unavailabilityClient);

  // Send an http request to make a new unavailability event in the
  // corresponding userID calendar
  Future<void> createUnavailabilityEvent(
      int userId, UnavailabilityEventPost newEvent) {
    return unavailabilityClient.createUnavailabilityEvent(userId, newEvent);
  }
}
