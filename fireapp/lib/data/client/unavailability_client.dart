import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnavailabilityClient {
  final RestClient restClient;
  UnavailabilityClient(this.restClient);

  //Send an packet to rest client to create new unavailability event in the calendar
  Future<void> createUnavailabilityEvent(
      int userId, UnavailabilityEventPost newEvent) {
    return restClient.createUnavailabilityEvent(userId, newEvent);
  }

  //TODO get list of all unavailability events from user
  JsonSerializable getUnavailabilityEvents(int userId) {
    return restClient.getUnavailabilityEvents(userId);
  }

  //Send an packet to rest client to edit a user's specific unavailability event
  Future <void> editUnavailabilityEvent(
      int userId, int eventID, UnavailabilityEventPost event) {
    return restClient.editUnavailabilityEvent(userId, eventID, event);
  }

  //Send an packet to rest client to delete a user's specific unavailability event
  Future<void> deleteUnavailabilityEvent(int userId, int eventID) {
    return restClient.deleteUnavailabilityEvent(userId, eventID);
  }
}
