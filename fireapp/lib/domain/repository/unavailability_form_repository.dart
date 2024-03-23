import 'package:fireapp/data/client/unavailability_form_client.dart';
import 'package:injectable/injectable.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';

@injectable
class UnavailabilityFormRepository {
  final UnavailabilityFormClient schedulerConstraintFormClient;

  UnavailabilityFormRepository(this.schedulerConstraintFormClient);

  Future<void> makeNewUnavailabilityEvent(UnavailabilityTime newEvent){
    return schedulerConstraintFormClient.makeNewUnavailabilityEvent(newEvent);
  }

}