import 'dart:io';

import 'package:fireapp/domain/models/reference/gender.dart';
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
import 'package:fireapp/presentation/register/register_navigation.dart';
import 'package:fireapp/presentation/register/register_view_model.dart';
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
import 'register_view_model_test.mocks.dart';

void main() {
  late MockAuthenticationRepository mockAuthRepository;
  late RegisterViewModel viewModel;
  const tokenResponse = TokenResponse(
      accessToken: 'test_token',
      userId: 1,
      role: "role"
  );

  setUp(() {
    mockAuthRepository = MockAuthenticationRepository();
    viewModel = RegisterViewModel(mockAuthRepository);
  });

  group('RegisterViewModel', () {
    test('register should set state to loading and then success', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'test_password';
      const firstName = 'name';
      const lastName = 'name';
      const gender = Gender.other;
      const phoneNumber = "0212321123";
      when(mockAuthRepository.register(
        email,
        password,
        firstName,
        lastName,
        gender,
        phoneNumber
      )).thenAnswer((_) async => tokenResponse);

      // Assert
      expectLater(viewModel.state, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<SuccessRequestState<void>>())
      ]));
      expectLater(viewModel.navigate, emits(const TypeMatcher<RegisterNavigation>()));

      // Act
      viewModel.email.text = email;
      viewModel.password.text = password;
      viewModel.firstName.text = firstName;
      viewModel.lastName.text = lastName;
      viewModel.setGender(const GenderOption(label: "other", gender: gender));
      viewModel.phoneNumber.text = phoneNumber;
      viewModel.register();

      verify(mockAuthRepository.register(any, any, any, any, any, any)).called(1);
      verifyNever(mockAuthRepository.login(any, any));
    });

    test('login should set state to exception when authentication fails', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'test_password';
      const firstName = 'name';
      const lastName = 'name';
      const gender = Gender.other;
      const phoneNumber = "0212321123";
      when(mockAuthRepository.register(
          email,
          password,
          firstName,
          lastName,
          gender,
          phoneNumber
      )).thenThrow(Exception());

      // Assert
      expectLater(viewModel.state, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<ExceptionRequestState<void>>())
      ]));

      // Act
      viewModel.email.text = email;
      viewModel.password.text = password;
      viewModel.firstName.text = firstName;
      viewModel.lastName.text = lastName;
      viewModel.setGender(const GenderOption(label: "other", gender: gender));
      viewModel.phoneNumber.text = phoneNumber;
      viewModel.register();
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
  });
}