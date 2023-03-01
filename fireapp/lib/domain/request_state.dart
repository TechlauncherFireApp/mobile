
abstract class RequestState<T> {

  RequestState._();

  factory RequestState.initial() = InitialRequestState;
  factory RequestState.loading() = LoadingRequestState;
  factory RequestState.success(T result) = SuccessRequestState;
  factory RequestState.exception(Object exception) = ExceptionRequestState;

}

class InitialRequestState<T> extends RequestState<T> {
  InitialRequestState(): super._();
}

class LoadingRequestState<T> extends RequestState<T> {
  LoadingRequestState(): super._();
}

class SuccessRequestState<T> extends RequestState<T> {

  final T result;
  SuccessRequestState(this.result): super._();

}

class ExceptionRequestState<T> extends RequestState<T> {

  final Object exception;
  ExceptionRequestState(this.exception): super._();

}