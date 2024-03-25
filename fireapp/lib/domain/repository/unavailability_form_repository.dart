import 'package:fireapp/data/client/unavailability_form_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnavailabilityFormRepository {
  final UnavailabilityFormClient unavailabilityFormClient;

  UnavailabilityFormRepository(this.unavailabilityFormClient);

  // Send an http request to make a new unavailability event in the
  // corresponding userID calendar
  Future<void> createUnavailabilityEvent(int userId,UnavailabilityEventPost newEvent){
    return unavailabilityFormClient.createUnavailabilityEvent(userId,newEvent);
  }

}