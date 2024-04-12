import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/unavailability_form_client.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:mockito/annotations.dart';
@GenerateMocks([RestClient])
import 'unavailability_form_client_test.mocks.dart';


void main() {
  group('UnavailabilityFormClient', () {
    late MockRestClient mockRestClient;
    late UnavailabilityFormClient unavailabilityFormClient;

    setUp(() {
      mockRestClient = MockRestClient();
      unavailabilityFormClient = UnavailabilityFormClient(mockRestClient);
    });

    test('createUnavailabilityEvent sends an HTTP request to create an event', () async {
      const userId = 1;
      final newEvent = UnavailabilityEventPost(
          title: "test",
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 2),
          periodicity: 0
      );

      // Setting up the mock to do nothing since it's a void return
      when(mockRestClient.createUnavailabilityEvent(userId, newEvent))
          .thenAnswer((_) async => {});

      // Act
      await unavailabilityFormClient.createUnavailabilityEvent(userId, newEvent);

      // Assert
      verify(mockRestClient.createUnavailabilityEvent(userId, newEvent)).called(1);
    });
  });
}
