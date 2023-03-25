
import 'package:fireapp/base/list_extensions.dart';
import 'package:fireapp/domain/models/dietary_requirements.dart';
import 'package:fireapp/domain/repository/dietary_requirements_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_presentation_model.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class DietaryRequirementsViewModel extends FireAppViewModel {

  final DietaryRequirementsRepository _dietaryRequirementsRepository;

  final BehaviorSubject<RequestState<UserDietaryRequirements>> _requirements
    = BehaviorSubject.seeded(RequestState.initial());
  final BehaviorSubject<List<UserDietaryRestriction>> _changes = BehaviorSubject.seeded([]);

  TextEditingController customRestrictions = TextEditingController();
  Stream<RequestState<UserDietaryRequirements>> get requirements
    => Rx.combineLatest2(_requirements.stream, _changes.stream,
      (RequestState<UserDietaryRequirements> sot, List<UserDietaryRestriction> c) {
        if (sot is! SuccessRequestState) return sot;
        UserDietaryRequirements v = (sot as SuccessRequestState).result;
        return RequestState.success(
          v.copyWith(
            restrictions: _mergeRequirements(v.restrictions, c)
          )
        );
      }
    );

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
        _changes.add([]);
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
    _changes.add(
      _mergeRequirements(
        _changes.value,
        [UserDietaryRestriction(restriction: restriction, checked: checked)]
      )
    );
  }

  void updateCustomRestriction(String? value) {
    customRestrictions.text = value ?? "";
  }

  void submit() {
    final state = _requirements.value;
    if (state is! SuccessRequestState) return;

    var changedRestrictions = _mergeRequirements((state as SuccessRequestState).result, _changes.value);

    _dietaryRequirementsRepository.updateDietaryRequirements(
      DietaryRequirements(
        restrictions: changedRestrictions.where((e) => e.checked).map((e) => e.restriction).toList(),
        customRestrictions: customRestrictions.text
      )
    );
  }

  List<UserDietaryRestriction> _mergeRequirements(
    List<UserDietaryRestriction> original,
    List<UserDietaryRestriction> novel
  ) {
    var c = original.map(
      (e) {
        var n = novel.firstOrNull((element) => element.restriction == e.restriction);
        if (n != null) novel.remove(n);
        return n ?? e;
      }
    ).toList();
    c.addAll(novel);
    return c;
  }

  @override
  Future<void> dispose() async {
    _requirements.close();
    _changes.close();
    _customRestrictions.close();
  }

}