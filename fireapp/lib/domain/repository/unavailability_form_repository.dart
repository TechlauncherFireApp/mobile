import 'package:fireapp/data/client/unavailability_form_client.dart';
import 'package:injectable/injectable.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';

@injectable
class UnavailabilityFormRepository {
  final UnavailabilityFormClient unavailabilityFormClient;

  UnavailabilityFormRepository(this.unavailabilityFormClient);

  Future<void> createUnavailabilityEvent(UnavailabilityTime newEvent){
    return unavailabilityFormClient.createUnavailabilityEvent(newEvent);
  }

}