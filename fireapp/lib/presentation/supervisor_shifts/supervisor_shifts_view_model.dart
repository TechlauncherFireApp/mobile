import 'package:fireapp/domain/repository/shifts_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../global/di.dart';

@Injectable()
class SupervisorShiftsViewModel {
  final ShiftsRepository shiftsRepository;

  SupervisorShiftsViewModel(this.shiftsRepository);

  Future<void> optimiseShifts() async {
    try {
      await shiftsRepository.optimiseShifts();
    } catch (e) {
      logger.e(e);
    }
  }
}
