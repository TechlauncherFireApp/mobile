
import 'package:fireapp/domain/repository/app_config_repository.dart';
import 'package:fireapp/presentation/server_url/server_url_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/request_state.dart';
import '../../global/di.dart';
import '../fireapp_view_model.dart';

@injectable
class ServerUrlViewModel
    extends FireAppViewModel
    implements NavigationViewModel<ServerUrlNavigation> {

  final AppConfigRepository _appConfigRepository;

  final BehaviorSubject<ServerUrlNavigation> _navigate = BehaviorSubject();
  @override
  Stream<ServerUrlNavigation> get navigate => _navigate.stream;

  final BehaviorSubject<RequestState<void>> _state = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<void>> get state => _state.stream;

  TextEditingController url = TextEditingController();

  ServerUrlViewModel(this._appConfigRepository);

  void submit() {
    handle(_state, () async {
      _appConfigRepository.setServerUrl(url.text);
      _navigate.add(const ServerUrlNavigation.home());
    });
  }

  @override
  Future<void> dispose() async {
    _navigate.close();
  }

}