import 'dart:io';

import 'package:fireapp/domain/models/reference/gender.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/app_config_repository.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/login/login_navigation.dart';
import 'package:fireapp/presentation/login/login_view_model.dart';
import 'package:fireapp/presentation/register/register_view_model.dart';
import 'package:fireapp/presentation/server_url/server_url_navigation.dart';
import 'package:fireapp/presentation/server_url/server_url_view_model.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information_viewmodel.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matcher/matcher.dart';

import '../../request_state_has_content_matcher.dart';
@GenerateNiceMocks([
  MockSpec<AppConfigRepository>(),
])
import 'server_url_view_model_test.mocks.dart';

void main() {
  group('ServerUrlViewModel', () {
    late ServerUrlViewModel viewModel;
    late MockAppConfigRepository mockRepository;

    setUp(() {
      mockRepository = MockAppConfigRepository();
      viewModel = ServerUrlViewModel(mockRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('submit sets server URL, navigates, and updates state on success', () async {
      // Arrange
      when(mockRepository.setServerUrl(any)).thenAnswer((_) async => null);

      // Assert
      expectLater(viewModel.state, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<SuccessRequestState<void>>())
      ]));

      expectLater(viewModel.navigate, emitsInOrder([
        emits(const TypeMatcher<Home>())
      ]));

      // Act
      viewModel.url.text = 'http://example.com';
      viewModel.submit();

      // Assert
      verify(mockRepository.setServerUrl('http://example.com'));
    });

    test('submit updates state on exception', () async {
      // Arrange
      when(mockRepository.setServerUrl(any)).thenThrow(Exception('An error'));

      // Assert
      expectLater(viewModel.state, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<ExceptionRequestState<void>>())
      ]));

      // Act
      viewModel.url.text = 'http://example.com';
      viewModel.submit();
      await Future.delayed(Duration(milliseconds: 100)); // Wait for async operations to complete
    });
  });
}