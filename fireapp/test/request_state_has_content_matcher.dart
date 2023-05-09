
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/change_qualification/change_qualification_option_model.dart';
import 'package:flutter_test/flutter_test.dart';

class RequestStateHasContentMatcher<T> extends CustomMatcher {

  RequestStateHasContentMatcher(matcher) : super("RequestState result is", "result", matcher);
  @override
  featureValueOf(actual) {
    if (actual is SuccessRequestState<T>) {
      return actual.result;
    } else {
      return null;
    }
  }

}

class RequestStateHasExceptionMatcher<T> extends CustomMatcher {

  RequestStateHasExceptionMatcher(matcher) : super("RequestState exception is", "exception", matcher);
  @override
  featureValueOf(actual) {
    if (actual is ExceptionRequestState<T>) {
      return actual.exception;
    } else {
      return null;
    }
  }

}
