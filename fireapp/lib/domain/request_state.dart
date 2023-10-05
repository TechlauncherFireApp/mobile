/// An abstract class representing the current state of a request operation.
///
/// It is parameterized by a type `T` that represents the result of the request.
abstract class RequestState<T> {

  /// Private constructor to prevent instantiation of the base class.
  RequestState._();

  /// Factory constructor that creates an `InitialRequestState`.
  factory RequestState.initial() = InitialRequestState;

  /// Factory constructor that creates a `LoadingRequestState`.
  factory RequestState.loading() = LoadingRequestState;

  /// Factory constructor that creates a `SuccessRequestState` with a given [result].
  factory RequestState.success(T result) = SuccessRequestState;

  /// Factory constructor that creates an `ExceptionRequestState` with a given [exception].
  factory RequestState.exception(Object? exception) = ExceptionRequestState;

}

/// Represents an initial request state, indicating that no request has been made yet.
class InitialRequestState<T> extends RequestState<T> {
  InitialRequestState(): super._();
}

/// Represents a loading request state, indicating that the request is being processed.
class LoadingRequestState<T> extends RequestState<T> {
  LoadingRequestState() : super._();
}

/// Represents a successful request state, containing the [result] of the request.
class SuccessRequestState<T> extends RequestState<T> {

  /// The result of the request.
  final T result;

  /// Creates a successful request state with the given [result].
  SuccessRequestState(this.result): super._();

}

/// Represents an exception request state, containing the [exception] that occurred during the request.
class ExceptionRequestState<T> extends RequestState<T> {

  /// The exception that occurred during the request.
  final Object? exception;

  /// Creates an exception request state with the given [exception].
  ExceptionRequestState(this.exception): super._();

}