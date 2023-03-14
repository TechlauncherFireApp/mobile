
import 'package:fireapp/base/list_extensions.dart';
import 'package:fireapp/domain/models/dietary_requirements.dart';
import 'package:fireapp/domain/repository/dietary_requirements_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_presentation_model.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class DietaryRequirementsViewModel extends FireAppViewModel {

  final DietaryRequirementsRepository _dietaryRequirementsRepository;

  final BehaviorSubject<RequestState<UserDietaryRequirements>> _requirements
    = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<UserDietaryRequirements>> get requirements => _requirements.stream;

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

        _requirements.add(RequestState.success(
          UserDietaryRequirements(
            restrictions: userRestrictions,
            customRestrictions: userData.customRestrictions
          )
        ));
      } catch (e) {
        logger.e(e);
        _requirements.add(RequestState.exception(e));
      }

    }();
  }

  @override
  Future<void> dispose() async {
    _requirements.close();
  }

}