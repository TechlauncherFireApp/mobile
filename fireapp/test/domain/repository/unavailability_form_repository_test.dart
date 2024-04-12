import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:fireapp/data/client/unavailability_form_client.dart';
import 'package:fireapp/domain/repository/unavailability_form_repository.dart';
import 'package:mockito/annotations.dart';
@GenerateMocks([UnavailabilityFormClient])
import 'unavailability_form_repository_test.mocks.dart';


void main() {
  group('UnavailabilityFormRepository', () {
    late MockUnavailabilityFormClient mockUnavailabilityFormClient;
    late UnavailabilityFormRepository unavailabilityFormRepository;

    setUp(() {
      mockUnavailabilityFormClient = MockUnavailabilityFormClient();
      unavailabilityFormRepository = UnavailabilityFormRepository(mockUnavailabilityFormClient);
    });

    test('createUnavailabilityEvent sends a POST request to create an event', () async {
      const userId = 1;
      final newEvent = UnavailabilityEventPost(
          title: "test",
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 2),
          periodicity: 0
      );

      when(mockUnavailabilityFormClient.createUnavailabilityEvent(userId, newEvent))
          .thenAnswer((_) async => {});

      // Act
      await unavailabilityFormRepository.createUnavailabilityEvent(userId, newEvent);

      // Assert
      verify(mockUnavailabilityFormClient.createUnavailabilityEvent(userId, newEvent)).called(1);
    });
  });
}
