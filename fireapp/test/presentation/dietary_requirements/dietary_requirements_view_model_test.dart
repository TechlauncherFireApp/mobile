import 'dart:io';

import 'package:fireapp/domain/models/dietary_requirements.dart';
import 'package:fireapp/domain/models/reference/gender.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/dietary_requirements_repository.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_presentation_model.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_view_model.dart';
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
  MockSpec<DietaryRequirementsRepository>(),
])
import 'dietary_requirements_view_model_test.mocks.dart';

void main() {
  late MockDietaryRequirementsRepository repository;
  late DietaryRequirementsViewModel viewModel;
  final options = [
    const DietaryRestriction(key: "peanut", displayName: "Peanuts"),
    const DietaryRestriction(key: "fish", displayName: "Fish"),
    const DietaryRestriction(key: "vegetarian", displayName: "Vegetarian"),
    const DietaryRestriction(key: "vegan", displayName: "Vegan"),
  ];

  setUp(() {
    repository = MockDietaryRequirementsRepository();
    viewModel = DietaryRequirementsViewModel(repository);
  });

  group('load', () {
    test('should emit loading and then success when repository calls succeed', () async {
      const custom = "No peanuts";
      final restrictions = [
        options[0],
        options[1],
      ];
      final dietaryRequirements = DietaryRequirements(
          restrictions: restrictions,
          customRestrictions: custom
      );
      final userData = UserDietaryRequirements(
          restrictions: options.map((e) =>
            UserDietaryRestriction(restriction: e, checked: restrictions.contains(e))
          ).toList(),
      );

      when(repository.getOptions()).thenAnswer((_) async => options);
      when(repository.getDietaryRequirements()).thenAnswer((
          _) async => dietaryRequirements);

      final expectedOutput = [
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(RequestStateHasContentMatcher(userData))
      ];

      expectLater(viewModel.requirements, emitsInOrder(expectedOutput));

      viewModel.load();
    });

    test(
        'should emit loading and then exception when repository calls fail', () async {
      final exception = Exception('Failed to get dietary requirements');

      when(repository.getOptions()).thenAnswer((_) => Future.error(exception));

      final expectedOutput = [
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(RequestStateHasExceptionMatcher(exception)),
      ];

      expectLater(viewModel.requirements, emitsInOrder(expectedOutput));

      viewModel.load();
    });
  });

  group('updateRequirement', () {
    test('should emit success when updating a restriction is successful', () async {
      const custom = "No peanuts";
      final restrictions = [
        options[0],
        options[1],
      ];
      final dietaryRequirements = DietaryRequirements(
          restrictions: restrictions,
          customRestrictions: custom
      );

      when(repository.getOptions()).thenAnswer((_) async => options);
      when(repository.getDietaryRequirements()).thenAnswer((_) async => dietaryRequirements);

      // Assert
      expectLater(viewModel.submissionState, emitsInOrder([
        emits(const TypeMatcher<SuccessRequestState<void>>())
      ]));

      // Act
      viewModel.load();
      viewModel.submissionState.firstWhere((element) => element is SuccessRequestState).then((value) {
        viewModel.updateCustomRestriction("Test");
        viewModel.updateRequirement(restrictions[0], false);
        viewModel.submit();
      });
    });

    test('should emit exception when updating a restriction fails', () async {
      const custom = "No peanuts";
      final restrictions = [
        options[0],
        options[1],
      ];
      final dietaryRequirements = DietaryRequirements(
          restrictions: restrictions,
          customRestrictions: custom
      );

      when(repository.getOptions()).thenAnswer((_) async => options);
      when(repository.getDietaryRequirements()).thenAnswer((_) async => dietaryRequirements);
      when(repository.updateDietaryRequirements(any)).thenThrow(Exception());

      // Assert
      expectLater(viewModel.submissionState, emitsInOrder([
        emits(const TypeMatcher<SuccessRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<ExceptionRequestState<void>>())
      ]));

      // Act
      viewModel.load();
      viewModel.submissionState.firstWhere((element) => element is SuccessRequestState).then((value) {
        viewModel.updateCustomRestriction("Test");
        viewModel.updateRequirement(restrictions[0], false);
        viewModel.submit();
      });
    });
  });
}