import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class VolunteerListViewModel extends FireAppViewModel {
  final TextEditingController searchController = TextEditingController();

  final BehaviorSubject<String>
    _search = BehaviorSubject.seeded('');

  final VolunteerRepository volunteerRepository;

  final BehaviorSubject<RequestState<List<VolunteerListing>>>
    _volunteers = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<VolunteerListing>>> get volunteers =>
      Rx.combineLatest2(_volunteers, _search,
              (RequestState<List<VolunteerListing>> volunteers, String search) {
        if (volunteers is SuccessRequestState) {
          return RequestState.success((volunteers as
          SuccessRequestState<List<VolunteerListing>>).result
              .where((volunteer) => volunteer.name
                  .toLowerCase()
                  .contains(search.toLowerCase() ?? ''))
              .toList());
        } else {
          return volunteers;
        }
      });

  VolunteerListViewModel(this.volunteerRepository){
    searchController.addListener(_updateSearch);
  }

  void _updateSearch() {
    _search.add(searchController.text);
  }

  void getVolunteerList() {
    () async {
      _volunteers.add(RequestState.loading());
      try {
        _volunteers.add(RequestState.success
          (await volunteerRepository.volunteerList()));
      } catch (e) {
        logger.e(e);
        _volunteers.add(RequestState.exception(e));
    }
    }();
  }


  @override
  Future<void> dispose() async {
    _volunteers.close();
    _search.close();
    searchController.dispose();
  }

}