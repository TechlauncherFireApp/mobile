
abstract class Response<T> {

  Response._();

  factory Response.success(T result) = SuccessResponse;
  factory Response.cached(T result) = CachedResponse;
  factory Response.exception(Object exception) = ExceptionResponse;

}

class SuccessResponse<T> extends Response<T> {

  final T result;
  SuccessResponse(this.result): super._();

}

class CachedResponse<T> extends SuccessResponse<T> {

  CachedResponse(T result): super(result);

}

class ExceptionResponse<T> extends Response<T> {

  final Object exception;
  ExceptionResponse(this.exception): super._();

}