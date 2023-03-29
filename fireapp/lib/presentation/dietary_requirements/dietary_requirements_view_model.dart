
import 'package:fireapp/base/list_extensions.dart';
import 'package:fireapp/base/mutex_extension.dart';
import 'package:fireapp/domain/models/dietary_requirements.dart';
import 'package:fireapp/domain/repository/dietary_requirements_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_presentation_model.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mutex/mutex.dart';

@injectable
class DietaryRequirementsViewModel extends FireAppViewModel {

  final DietaryRequirementsRepository _dietaryRequirementsRepository;

  final BehaviorSubject<RequestState<UserDietaryRequirements>> _requirements
    = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<UserDietaryRequirements>> get requirements
    => _requirements;

  final BehaviorSubject<RequestState<void>> _submissionState
    = BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get submissionState => _submissionState.stream;

  TextEditingController customRestrictions = TextEditingController();

  final _changeMutex = Mutex();

  DietaryRequirementsViewModel(this._dietaryRequirementsRepository);

  void load() {
    _requirements.add(RequestState.loading());
    () async {
      try {
        final options = await _dietaryRequirementsRepository.getOptions();
        final userData = await _dietaryRequirementsRepository.getDietaryRequirements();

        final userRestrictions = options.map((o) =>
          UserDietaryRestriction(
            restriction: o,
            checked: userData.restrictions.contains(o)
          )
        ).toList();

        customRestrictions.text = userData.customRestrictions ?? "";
        _requirements.add(RequestState.success(
          UserDietaryRequirements(
            restrictions: userRestrictions
          )
        ));
      } catch (e) {
        logger.e(e);
        _requirements.add(RequestState.exception(e));
      }
    }();
  }

  void updateRequirement(DietaryRestriction restriction, bool checked) {
    () async {
      _changeMutex.withLock(
          () async {
            var state = _requirements.value;
            if (state is! SuccessRequestState<UserDietaryRequirements>) return;
            var restrictions = List<UserDietaryRestriction>.from(state.result.restrictions, growable: false);
            var index = restrictions.indexWhere((element) => element.restriction == restriction);
            restrictions[index] = UserDietaryRestriction(restriction: restriction, checked: checked);
            _requirements.add(RequestState.success(state.result.copyWith(
              restrictions: restrictions
            )));
          }
      );
    }();
  }

  void updateCustomRestriction(String? value) {
    customRestrictions.text = value ?? "";
  }

  void submit() {
    final state = _requirements.value;
    if (state is! SuccessRequestState) return;

    () async {
      _submissionState.add(RequestState.loading());

      try {
        await _dietaryRequirementsRepository.updateDietaryRequirements(
            DietaryRequirements(
                restrictions: (state as SuccessRequestState<UserDietaryRequirements>)
                    .result
                    .restrictions
                    .where((e) => e.checked).map((e) => e.restriction).toList(),
                customRestrictions: customRestrictions.text
            )
        );
        _submissionState.add(RequestState.success(null));
      } catch(e) {
        logger.e("$e");
        _submissionState.add(RequestState.exception(e));
      }
    }();
  }

  @override
  Future<void> dispose() async {
    _requirements.close();
  }

}