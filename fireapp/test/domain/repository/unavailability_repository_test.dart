import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:fireapp/data/client/unavailability_client.dart';
import 'package:fireapp/domain/repository/unavailability_repository.dart';
import 'package:mockito/annotations.dart';
@GenerateMocks([UnavailabilityClient])
import 'unavailability_repository_test.mocks.dart';


void main() {
  group('UnavailabilityRepository', () {
    late MockUnavailabilityClient mockUnavailabilityClient;
    late UnavailabilityRepository unavailabilityRepository;

    setUp(() {
      mockUnavailabilityClient = MockUnavailabilityClient();
      unavailabilityRepository = UnavailabilityRepository(mockUnavailabilityClient);
    });

    test('createUnavailabilityEvent sends a POST request to create an event', () async {
      const userId = 1;
      final newEvent = UnavailabilityEventPost(
          title: "test",
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 2),
          periodicity: 0
      );

      when(mockUnavailabilityClient.createUnavailabilityEvent(userId, newEvent))
          .thenAnswer((_) async => {});

      // Act
      await unavailabilityRepository.createUnavailabilityEvent(userId, newEvent);

      // Assert
      verify(mockUnavailabilityClient.createUnavailabilityEvent(userId, newEvent)).called(1);
    });
  });
}
