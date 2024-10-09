import 'package:fireapp/base/date_extensions.dart';
import 'package:fireapp/domain/models/new/vehicle_request.dart';
import 'package:fireapp/domain/models/scheduler/new_request.dart';
import 'package:fireapp/domain/models/scheduler/new_request_response.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/repository/scheduler_constraint_form_repository.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_navigation.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/expect.dart' hide expectLater, expect;

@GenerateNiceMocks([
  MockSpec<SchedulerConstraintFormRepository>(),
  MockSpec<ReferenceDataRepository>(),
])
import 'constraint_form_view_model_test.mocks.dart';


void main() {
  group('SchedulerConstraintFormViewModel Tests', ()
  {
    late SchedulerConstraintFormViewModel viewModel;
    late MockSchedulerConstraintFormRepository
    mockSchedulerConstraintFormRepository;
    late MockReferenceDataRepository mockReferenceDataRepository;

    setUp(() {
      mockSchedulerConstraintFormRepository =
          MockSchedulerConstraintFormRepository();
      mockReferenceDataRepository = MockReferenceDataRepository();
      viewModel = SchedulerConstraintFormViewModel(
        mockReferenceDataRepository,
        mockSchedulerConstraintFormRepository,
      );
    });

    test('SubmitForm sets submission state to loading', () async {
      var title = "Test title";
      var id = 1;
      viewModel.titleController.text = title;
      var request = NewRequest(title: title, status: "");
      var response = NewRequestResponse(id: id);
      when(mockSchedulerConstraintFormRepository.makeNewRequest(request))
          .thenAnswer((realInvocation) async => response);

      DateTime date = DateTime.timestamp();
      TimeOfDay start = TimeOfDay.now();
      TimeOfDay end = TimeOfDay.now();
      var assetType = "mediumtanker";
      viewModel.selectDate(date);
      viewModel.selectStartTime(start);
      viewModel.selectEndTime(end);
      viewModel.selectedAsset = AssetType(
          id: 0,
          name: "",
          code: assetType,
          updated: DateTime.now(),
          created: DateTime.now()
      );
      var vehicleRequest = VehicleRequest(requestId: id.toString(),
          startDate: date.withTime(start),
          endDate: date.withTime(end),
          assetType: assetType);
      when(mockSchedulerConstraintFormRepository.makeVehicleRequest(
          vehicleRequest)).thenAnswer((realInvocation) async => response);


      expectLater(
          viewModel.submissionState, emitsInOrder([
        emits(const TypeMatcher<SuccessRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<SuccessRequestState<void>>())
      ]));

      viewModel.submitForm();
    });

    test('SelectDate updates selectedDate stream', () {
      final testDate = DateTime.now();

      expectLater(viewModel.selectedDate, emits(testDate));

      viewModel.selectDate(testDate);
    });

    test('SelectStartTime updates selectedStartTime stream', () {
      final testTime = TimeOfDay.now();

      expectLater(viewModel.selectedStartTime, emits(testTime));

      viewModel.selectStartTime(testTime);
    });

    test('SelectEndTime updates selectedEndTime stream', () {
      final testTime = TimeOfDay.now();

      expectLater(viewModel.selectedEndTime, emits(testTime));

      viewModel.selectEndTime(testTime);
    });

    test('FetchAssetTypes updates assetsStream with data', () async {
      final mockAssetTypes = [
        AssetType(
            id: 123,
            name: 'Asset A',
            code: '123A',
            updated: DateTime.timestamp(),
            created: DateTime.timestamp())
      ];
      when(mockReferenceDataRepository.getAssetType())
          .thenAnswer((_) async => mockAssetTypes);

      expectLater(
          viewModel.assetsStream,
          emitsInOrder([
            emits(const TypeMatcher<SuccessRequestState<List<AssetType>>>()),
            emits(const TypeMatcher<LoadingRequestState<List<AssetType>>>()),
            emits(const TypeMatcher<SuccessRequestState<List<AssetType>>>()),
          ])
      );

      viewModel.fetchAssetTypes();
    });

    test('FetchAssetTypes handles errors', () async {
      const errorMessage = 'Error fetching asset types';
      when(mockReferenceDataRepository.getAssetTypeHardCoded()).thenThrow(errorMessage);

      expectLater(
          viewModel.assetsStream,
          emitsInOrder([
            emits(const TypeMatcher<SuccessRequestState<List<AssetType>>>()),
            emits(const TypeMatcher<LoadingRequestState<List<AssetType>>>()),
            emits(const TypeMatcher<ExceptionRequestState<List<AssetType>>>()),
          ])
      );

      viewModel.fetchAssetTypes();
    });

    test('Dispose closes all streams', () async {
      viewModel.dispose();
    });
  });
}
