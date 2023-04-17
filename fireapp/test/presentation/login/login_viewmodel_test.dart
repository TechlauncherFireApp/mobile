import 'dart:io';

import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/login/login_navigation.dart';
import 'package:fireapp/presentation/login/login_view_model.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information_viewmodel.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matcher/matcher.dart';

import '../../request_state_has_content_matcher.dart';
@GenerateNiceMocks([
  MockSpec<AuthenticationRepository>(),
])
import 'login_viewmodel_test.mocks.dart';

void main() {
  late MockAuthenticationRepository mockAuthRepository;
  late LoginViewModel viewModel;
  const tokenResponse = TokenResponse(
      accessToken: 'test_token',
      userId: 1,
      role: "role"
  );

  setUp(() {
    mockAuthRepository = MockAuthenticationRepository();
    viewModel = LoginViewModel(mockAuthRepository);
  });

  group('LoginViewModel', () {
    test('login should set state to loading and then success', () async {
      // Arrange
      const email = 'email@example.com';
      const password = 'password';
      when(mockAuthRepository.login(email, password)).thenAnswer((_) async => tokenResponse);

      // Assert
      expectLater(viewModel.state, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<SuccessRequestState<void>>())
      ]));
      expectLater(viewModel.navigate, emits(const TypeMatcher<HomeLoginNavigation>()));

      // Act
      viewModel.email.text = email;
      viewModel.password.text = password;
      viewModel.login();

      verify(mockAuthRepository.login(any, any)).called(1);
      verifyNever(mockAuthRepository.register(any, any, any, any, any, any));
    });

    test('login should set state to exception when authentication fails', () async {
      // Arrange
      final email = 'email@example.com';
      final password = 'password';
      final error = 'Invalid credentials';
      when(mockAuthRepository.login(email, password)).thenThrow(error);

      // Assert
      expectLater(viewModel.state, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<ExceptionRequestState<void>>())
      ]));

      // Act
      viewModel.email.text = email;
      viewModel.password.text = password;
      viewModel.login();
    });

    test('toggleObscureText should toggle the value of obscureText', () {
      // Arrange
      final initialObscureText = viewModel.obscureText;

      // Act
      viewModel.toggleObscureText();
      final afterToggleObscureText = viewModel.obscureText;

      // Assert
      expect(afterToggleObscureText, !initialObscureText);
    });

    test('navigateToRegister should emit register navigation event', () {
      // Assert
      expectLater(viewModel.navigate, emitsInOrder([
        emits(const TypeMatcher<RegisterLoginNavigation>()),
      ]));

      // Act
      viewModel.navigateToRegister();
    });

    test('navigateToForgotPassword should emit register navigation event', () {
      // Assert
      expectLater(viewModel.navigate, emitsInOrder([
        emits(const TypeMatcher<ForgotPasswordLoginNavigation>()),
      ]));

      // Act
      viewModel.navigateToForgotPassword();
    });

    test('dispose throws nothing', () {
      viewModel.dispose();
    });
  });
}