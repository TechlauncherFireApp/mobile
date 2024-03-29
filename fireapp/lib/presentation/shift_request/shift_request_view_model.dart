import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fireapp/base/list_extensions.dart';
import 'package:fireapp/base/mutex_extension.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mutex/mutex.dart';

import '../../domain/repository/shift_request_repository.dart'; // Ensure this is the correct path

@injectable
class ShiftRequestViewModel extends FireAppViewModel {

  final ShiftRequestRepository _shiftRequestRepository;

  final BehaviorSubject<RequestState<List<ShiftRequest>>> _shiftRequests
    = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<ShiftRequest>>> get shiftRequests => _shiftRequests;

  final BehaviorSubject<RequestState<void>> _updateState
    = BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get updateState => _updateState.stream;

  final _updateMutex = Mutex();

  ShiftRequestViewModel(this._shiftRequestRepository);

  void loadShiftRequests(String requestId) async {
    _shiftRequests.add(RequestState.loading());

    try {
      _shiftRequests.add(RequestState.success(
          await _shiftRequestRepository.getShiftRequestsByRequestID(requestId)
      ));
    } catch (e) {
      logger.e(e);
      _shiftRequests.add(RequestState.exception(e));
    }
  }

  void deleteShiftAssignment(int shiftId, int positionId) async {
    await _updateMutex.protect(() async {
      try {
        await _shiftRequestRepository.deleteShiftAssignment(shiftId, positionId);
        _updateState.add(RequestState.success(null));
      } catch (e) {
        logger.e(e);
        _updateState.add(RequestState.exception(e));
      }
    });
  }

  void updateShiftByPosition(int shiftId, int positionId, int volunteerId) async {
    await _updateMutex.protect(() async {
      try {
        await _shiftRequestRepository.updateShiftByPosition(shiftId, positionId, volunteerId);
        _updateState.add(RequestState.success(null));
      } catch (e) {
        logger.e(e);
        _updateState.add(RequestState.exception(e));
      }
    });
  }

  @override
  Future<void> dispose() async {
    _shiftRequests.close();
    _updateState.close();
  }
}
