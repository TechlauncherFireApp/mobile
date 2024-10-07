import 'package:fireapp/domain/repository/shifts_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/request_state.dart';
import '../../global/di.dart';

@Injectable()
class SupervisorShiftsViewModel {
  final ShiftsRepository shiftsRepository;
  final BehaviorSubject<RequestState<void>> _loadingState =
  BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<void>> get loadingState  => _loadingState.stream;

  SupervisorShiftsViewModel(this.shiftsRepository);

  Future<void> optimiseShifts() async {
    _loadingState.add(RequestState.loading());
    try {
      await shiftsRepository.optimiseShifts();
      _loadingState.add(RequestState.success(null));
    } catch (e) {
      logger.e(e);
      _loadingState.add(RequestState.exception(e));
    }
  }
}
