import 'package:fireapp/base/disposable.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/request_state.dart';
import '../global/di.dart';

// This is a root class from which all ViewModels should extend
abstract class FireAppViewModel implements Disposable {
  
  void handle<T>(
      BehaviorSubject<RequestState<T>> state,
      Future<T> Function() task,
      { bool load = true }
  ) {
    state.add(RequestState.loading());
    () async {
      try {
        state.add(RequestState.success(await task()));
      } catch (e, stacktrace) {
        logger.e("$e $stacktrace");
        state.add(RequestState.exception(e));
      }
    }();
  }
  
}

abstract class NavigationViewModel<T> {

  Stream<T> get navigate;

}