import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class VolunteerListViewModel extends FireAppViewModel {

  final VolunteerRepository volunteerRepository;

  final BehaviorSubject<RequestState<List<VolunteerListing>>>
    _volunteers = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<VolunteerListing>>> get volunteers =>
      _volunteers.stream;

  VolunteerListViewModel(this.volunteerRepository);

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
  }

}