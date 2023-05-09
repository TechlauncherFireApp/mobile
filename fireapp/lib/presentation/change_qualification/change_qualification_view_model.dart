import 'package:fireapp/base/list_extensions.dart';
import 'package:fireapp/base/mutex_extension.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/change_qualification/change_qualification_option_model.dart';
import 'package:fireapp/presentation/change_roles/change_roles_option_model.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mutex/mutex.dart';

import '../../domain/repository/volunteer_information_repository.dart';

@injectable
class ChangeQualificationsViewModel extends FireAppViewModel {

  final ReferenceDataRepository _referenceDataRepository;
  final VolunteerInformationRepository _volunteerInformationRepository;
  late String _volunteerId;
  late List<Qualification> _qualifications;

  final BehaviorSubject<RequestState<List<UserQualification>>> _userQualifications
    = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<UserQualification>>> get userQualifications => _userQualifications;

  final BehaviorSubject<RequestState<void>> _submissionState
    = BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get submissionState => _submissionState.stream;

  final _changeMutex = Mutex();

  ChangeQualificationsViewModel(this._referenceDataRepository, this._volunteerInformationRepository);

  void load() {
    _userQualifications.add(RequestState.loading());
    () async {
      try {
        final options = await _referenceDataRepository.getQualifications();

        final userQualifications = options.map((o) =>
            UserQualification(
                qualification: o,
                checked: _qualifications.has((p0) => p0.id == o.id)
            )
        ).toList();
        _userQualifications.add(RequestState.success(
            (userQualifications)
        ));

      } catch (e) {
        logger.e(e);
        _userQualifications.add(RequestState.exception(e));
      }
    }();
  }

  void init(String volunteerId, List<Qualification> qualifications){
    _volunteerId = volunteerId;
    _qualifications = qualifications;
    load();
  }

  void updateQualification(UserQualification qualification) async {
    await _changeMutex.protect(() async {
      var state = _userQualifications.value;
      if (state is! SuccessRequestState) return;

      var qualifications = (state as SuccessRequestState<List<UserQualification>>).result;
      var index = qualifications.indexWhere((element) => element.qualification == qualification.qualification);
      qualifications[index] = qualification.copyWith(checked: !qualification.checked);
      _userQualifications.add(RequestState.success(qualifications));
    });
  }

  void submit() {
    final state = _userQualifications.value;
    if (state is! SuccessRequestState) return;

    () async {
      _submissionState.add(RequestState.loading());

      try {
        final qualifications = (state as SuccessRequestState<List<UserQualification>>).result;
        //await _volunteerInformationRepository.updateQualifications(_volunteerId, qualifications.where((q) => q.checked).map((q) => q.qualification).toList());
        _submissionState.add(RequestState.success(null));
      } catch (e) {
        logger.e(e);
        _submissionState.add(RequestState.exception(e));
      }
    }();
  }

  @override
  Future<void> dispose() async {
    _userQualifications.close();
  }
}