import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/request_state.dart';
import 'package:fireapp/domain/repository/unavailability_repository.dart';

import 'calendar_navigation.dart';

@injectable
class CalendarViewModel extends FireAppViewModel
    implements NavigationViewModel<CalendarNavigation> {
  //Load in authentication and unavailability actions
  late final AuthenticationRepository _authenticationRepository;
  late final UnavailabilityRepository _unavailabilityRepository;

  final BehaviorSubject<int> _selectedMonth = BehaviorSubject();

  final BehaviorSubject<int> _selectedYear = BehaviorSubject();


  // Loading State controllers
  final BehaviorSubject<RequestState<void>> _submissionState =
  BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get submissionState => _submissionState.stream;

  // Navigation handling
  final BehaviorSubject<CalendarNavigation> _navigate =
  BehaviorSubject();

  @override
  Stream<CalendarNavigation> get navigate => _navigate.stream;

  CalendarViewModel(
      this._authenticationRepository, this._unavailabilityRepository);


  void displayUnavailabilityEvents(){

  }

  void deleteUnavailability(int eventID){

  }

  void updateSelectedMonth(int month){
  }

  void updateSelectedYear(int year){
  }

  @override
  Future<void> dispose() async {
    _selectedMonth.close();
    _selectedYear.close();
    _navigate.close();
    _submissionState.close();

  }
}
