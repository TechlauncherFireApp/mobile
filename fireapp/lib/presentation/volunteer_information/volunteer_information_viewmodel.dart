import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class VolunteerInformationViewModel extends FireAppViewModel{
  final VolunteerInformationRepository volunteerInformationRepository;

  final BehaviorSubject<RequestState<VolunteerInformation>>
    _volunteerInformation = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<VolunteerInformation>> get volunteerInformation =>
      _volunteerInformation.stream;

  VolunteerInformationViewModel(this.volunteerInformationRepository);

  void getVolunteerInformation(String volunteerId) {
    () async {
      _volunteerInformation.add(RequestState.loading());
      try {
        _volunteerInformation.add(RequestState.success
          (await volunteerInformationRepository.getVolunteerInformation(volunteerId)));
      } catch (e,stacktrace) {
        // logger.e(e);
        print(stacktrace);
        _volunteerInformation.add(RequestState.exception(e));
      }
    }();
  }

  @override
  Future<void> dispose() async {
    _volunteerInformation.close();
  }
}