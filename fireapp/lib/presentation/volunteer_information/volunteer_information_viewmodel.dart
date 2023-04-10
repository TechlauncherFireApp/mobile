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
      } catch (e) {
        logger.e(e);
        _volunteerInformation.add(RequestState.exception(e));
    }
    }();
  }

  String formatHours(List<List<int>> hours) {
    return hours.map((hourRange) => '${formatHour(hourRange[0])} to ${formatHour(hourRange[1])}').join(', ');
  }

  String formatHour(int hour) {
    if (hour == 0) {
      return '12am';
    } else if (hour < 12) {
      return '$hour' + 'am';
    } else if (hour == 12) {
      return '12pm';
    } else {
      return '${hour - 12}' + 'pm';
    }
  }

  @override
  Future<void> dispose() async {
    _volunteerInformation.close();
  }
}