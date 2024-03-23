import 'package:fireapp/data/client/unavailability_form_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnavailabilityFormRepository {
  final UnavailabilityFormClient unavailabilityFormClient;

  UnavailabilityFormRepository(this.unavailabilityFormClient);

  Future<void> createUnavailabilityEvent(int userId,UnavailabilityEventPost newEvent){
    return unavailabilityFormClient.createUnavailabilityEvent(userId,newEvent);
  }

}