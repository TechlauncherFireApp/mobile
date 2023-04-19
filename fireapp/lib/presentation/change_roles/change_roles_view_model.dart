import 'package:fireapp/base/list_extensions.dart';
import 'package:fireapp/base/mutex_extension.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/change_roles/change_roles_option_model.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mutex/mutex.dart';

@injectable
class ChangeRolesViewModel extends FireAppViewModel {

  final ReferenceDataRepository _referenceDataRepository;
  late String _volunteerId;
  late List<String> _roles;

  final BehaviorSubject<RequestState<List<String>>> _roles
    = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<String>>> get roles => _roles;

  final BehaviorSubject<RequestState<void>> _submissionState
    = BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get submissionState => _submissionState.stream;

  final _changeMutex = Mutex();

  ChangeRolesViewModel(this._referenceDataRepository);

  void load() {
    _roles.add(RequestState.loading());
    () async {
      try {
        final options = await _referenceDataRepository.getRoles();
        final userData = await _;

        final userRoles = options.map((o) =>
            UserRole(restriction: o, checked: checked)
        ).toList();

        customRestrictions.text = userData.customRestrictions ?? "";
        _roles.add(RequestState.success(
            UserDietaryRequirements(
                restrictions: userRestrictions
            )
        ));
      } catch (e) {
        logger.e(e);
        _roles.add(RequestState.exception(e));
      }
    }();
  }

  void init(String volunteerId, List<String> roles){

  }

  void submit() {
    _changeMutex.protect(() async {
      _submissionState.add(RequestState.loading());
      try {
        await Future.delayed(Duration(seconds: 1));
        _submissionState.add(RequestState.success(null));
      } catch (e) {
        logger.e(e);
        _submissionState.add(RequestState.exception(e));
      }
    });
  }
  @override
  Future<void> dispose() async {
    _roles.close();
  }
}