import 'package:fireapp/data/client/unavailability_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../models/unavailability/unavailability_time.dart';

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

  //TODO get list of all unavailability events from user
  JsonSerializable getUnavailabilityEvents(int userId) {
    return unavailabilityClient.getUnavailabilityEvents(userId);
  }

  //Send packet to client to edit a user's specific unavailability event
  Future <void> editUnavailabilityEvent(
      int userId, int eventID, UnavailabilityEventPost event) {
    return unavailabilityClient.editUnavailabilityEvent(userId, eventID, event);
  }

  //Send packet to client to delete a user's specific unavailability event
  Future<void> deleteUnavailabilityEvent(int userId, int eventID) {
    return unavailabilityClient.deleteUnavailabilityEvent(userId, eventID);
  }
}
