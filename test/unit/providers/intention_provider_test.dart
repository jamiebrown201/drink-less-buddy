import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/intention.dart';
import 'package:drink_less_buddy/providers/intention_provider_refactored.dart';
import '../../helpers/mock_providers.dart';

void main() {
  group('IntentionProvider', () {
    late IntentionProvider provider;
    late MockIntentionRepository repository;

    setUp(() {
      repository = MockIntentionRepository();
      provider = IntentionProvider(repository);
    });

    test('should start with empty intentions list', () {
      expect(provider.intentions, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.hasError, false);
    });

    group('loadIntentions', () {
      test('should load intentions successfully', () async {
        await repository.saveIntention(Intention(
          intentionDate: DateTime.now(),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        ));

        await provider.loadIntentions();

        expect(provider.intentions, hasLength(1));
        expect(provider.intentions.first.description, 'No drinking today');
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
      });

      test('should set loading state', () async {
        var wasLoading = false;
        provider.addListener(() {
          if (provider.isLoading) {
            wasLoading = true;
          }
        });

        await provider.loadIntentions();

        expect(wasLoading, true);
        expect(provider.isLoading, false);
      });

      test('should clear error before loading', () async {
        // Create an error state
        await provider.deleteIntention('non-existent');

        // Load intentions should clear the error
        await provider.loadIntentions();

        expect(provider.error, isNull);
        expect(provider.hasError, false);
      });
    });

    group('addIntention', () {
      test('should add intention successfully', () async {
        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        final success = await provider.addIntention(intention);

        expect(success, true);
        expect(provider.intentions, contains(intention));
        expect(provider.error, isNull);
      });

      test('should notify listeners when adding intention', () async {
        var notified = false;
        provider.addListener(() {
          notified = true;
        });

        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);

        expect(notified, true);
      });

      test('should append to existing intentions', () async {
        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'First intention',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 2),
          description: 'Second intention',
          maxUnits: 2,
          userId: 'user123',
        );

        await provider.addIntention(intention1);
        await provider.addIntention(intention2);

        expect(provider.intentions, hasLength(2));
      });
    });

    group('updateIntention', () {
      test('should update existing intention', () async {
        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final updated = Intention(
          id: intention.id,
          intentionDate: intention.intentionDate,
          description: 'Updated description',
          maxUnits: 2,
          userId: 'user123',
        );

        final success = await provider.updateIntention(updated);

        expect(success, true);
        expect(provider.intentions.first.description, 'Updated description');
        expect(provider.intentions.first.maxUnits, 2);
      });

      test('should preserve intention count', () async {
        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'Original',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final updated = intention.copyWith(description: 'Updated');

        await provider.updateIntention(updated);

        expect(provider.intentions, hasLength(1));
      });
    });

    group('completeIntention', () {
      test('should mark intention as completed', () async {
        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(intention);

        final success = await provider.completeIntention(intention.id);

        expect(success, true);
        expect(provider.intentions.first.isCompleted, true);
      });

      test('should preserve other properties', () async {
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(intention);

        await provider.completeIntention(intention.id);

        final completed = provider.intentions.first;
        expect(completed.description, 'No drinking today');
        expect(completed.maxUnits, 0);
        expect(completed.intentionDate, DateTime(2024, 1, 1));
      });
    });

    group('deleteIntention', () {
      test('should delete intention successfully', () async {
        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final success = await provider.deleteIntention(intention.id);

        expect(success, true);
        expect(provider.intentions, isEmpty);
      });

      test('should only delete specified intention', () async {
        final intention1 = Intention(
          intentionDate: DateTime.now(),
          description: 'First',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime.now(),
          description: 'Second',
          maxUnits: 2,
          userId: 'user123',
        );

        await provider.addIntention(intention1);
        await provider.addIntention(intention2);

        await provider.deleteIntention(intention1.id);

        expect(provider.intentions, hasLength(1));
        expect(provider.intentions.first.description, 'Second');
      });
    });

    group('getTodayIntentions', () {
      test('should return intentions for today', () async {
        final today = DateTime.now();
        final tomorrow = today.add(const Duration(days: 1));

        final todayIntention = Intention(
          intentionDate: today,
          description: 'Today',
          maxUnits: 0,
          userId: 'user123',
        );

        final tomorrowIntention = Intention(
          intentionDate: tomorrow,
          description: 'Tomorrow',
          maxUnits: 2,
          userId: 'user123',
        );

        await provider.addIntention(todayIntention);
        await provider.addIntention(tomorrowIntention);

        final todayList = provider.getTodayIntentions();

        expect(todayList, hasLength(1));
        expect(todayList.first.description, 'Today');
      });

      test('should return empty list when no intentions for today', () async {
        final tomorrow = DateTime.now().add(const Duration(days: 1));

        final intention = Intention(
          intentionDate: tomorrow,
          description: 'Tomorrow',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final todayList = provider.getTodayIntentions();

        expect(todayList, isEmpty);
      });
    });

    group('getTomorrowIntentions', () {
      test('should return intentions for tomorrow', () async {
        final tomorrow = DateTime.now().add(const Duration(days: 1));

        final intention = Intention(
          intentionDate: tomorrow,
          description: 'Tomorrow',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final tomorrowList = provider.getTomorrowIntentions();

        expect(tomorrowList, hasLength(1));
        expect(tomorrowList.first.description, 'Tomorrow');
      });
    });

    group('getTodayIncompleteIntentions', () {
      test('should return only incomplete intentions for today', () async {
        final today = DateTime.now();

        final completed = Intention(
          intentionDate: today,
          description: 'Completed',
          maxUnits: 0,
          userId: 'user123',
          isCompleted: true,
        );

        final incomplete = Intention(
          intentionDate: today,
          description: 'Incomplete',
          maxUnits: 2,
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(completed);
        await provider.addIntention(incomplete);

        final incompleteList = provider.getTodayIncompleteIntentions();

        expect(incompleteList, hasLength(1));
        expect(incompleteList.first.description, 'Incomplete');
      });
    });

    group('getTodayCompletionRate', () {
      test('should calculate completion rate correctly', () async {
        final today = DateTime.now();

        final completed1 = Intention(
          intentionDate: today,
          description: 'Done 1',
          maxUnits: 0,
          userId: 'user123',
          isCompleted: true,
        );

        final completed2 = Intention(
          intentionDate: today,
          description: 'Done 2',
          maxUnits: 0,
          userId: 'user123',
          isCompleted: true,
        );

        final incomplete = Intention(
          intentionDate: today,
          description: 'Not done',
          maxUnits: 2,
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(completed1);
        await provider.addIntention(completed2);
        await provider.addIntention(incomplete);

        final rate = provider.getTodayCompletionRate();

        expect(rate, closeTo(66.67, 0.01));
      });

      test('should return 0 when no intentions for today', () async {
        final rate = provider.getTodayCompletionRate();

        expect(rate, 0.0);
      });

      test('should return 100 when all complete', () async {
        final today = DateTime.now();

        final completed = Intention(
          intentionDate: today,
          description: 'Done',
          maxUnits: 0,
          userId: 'user123',
          isCompleted: true,
        );

        await provider.addIntention(completed);

        final rate = provider.getTodayCompletionRate();

        expect(rate, 100.0);
      });
    });

    group('hasTomorrowIntentions', () {
      test('should return true when intentions exist for tomorrow', () async {
        final tomorrow = DateTime.now().add(const Duration(days: 1));

        final intention = Intention(
          intentionDate: tomorrow,
          description: 'Tomorrow',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);

        expect(provider.hasTomorrowIntentions(), true);
      });

      test('should return false when no intentions for tomorrow', () async {
        expect(provider.hasTomorrowIntentions(), false);
      });
    });

    group('getIntentionsForDate', () {
      test('should return intentions for specific date', () async {
        final targetDate = DateTime(2024, 1, 15);
        final otherDate = DateTime(2024, 1, 16);

        final target = Intention(
          intentionDate: targetDate,
          description: 'Target date',
          maxUnits: 0,
          userId: 'user123',
        );

        final other = Intention(
          intentionDate: otherDate,
          description: 'Other date',
          maxUnits: 2,
          userId: 'user123',
        );

        await provider.addIntention(target);
        await provider.addIntention(other);

        final list = provider.getIntentionsForDate(targetDate);

        expect(list, hasLength(1));
        expect(list.first.description, 'Target date');
      });

      test('should ignore time component', () async {
        final date = DateTime(2024, 1, 15);
        final morning = DateTime(2024, 1, 15, 8, 0);
        final evening = DateTime(2024, 1, 15, 20, 0);

        final morningIntention = Intention(
          intentionDate: morning,
          description: 'Morning',
          maxUnits: 0,
          userId: 'user123',
        );

        final eveningIntention = Intention(
          intentionDate: evening,
          description: 'Evening',
          maxUnits: 2,
          userId: 'user123',
        );

        await provider.addIntention(morningIntention);
        await provider.addIntention(eveningIntention);

        final list = provider.getIntentionsForDate(date);

        expect(list, hasLength(2));
      });
    });

    group('clearAllIntentions', () {
      test('should clear all intentions', () async {
        final intention1 = Intention(
          intentionDate: DateTime.now(),
          description: 'First',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime.now(),
          description: 'Second',
          maxUnits: 2,
          userId: 'user123',
        );

        await provider.addIntention(intention1);
        await provider.addIntention(intention2);

        final success = await provider.clearAllIntentions();

        expect(success, true);
        expect(provider.intentions, isEmpty);
      });
    });

    group('Integration scenarios', () {
      test('should handle full intention lifecycle', () async {
        // Add intention
        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(intention);
        expect(provider.intentions, hasLength(1));

        // Update intention
        final updated = intention.copyWith(description: 'Updated');
        await provider.updateIntention(updated);
        expect(provider.intentions.first.description, 'Updated');

        // Complete intention
        await provider.completeIntention(intention.id);
        expect(provider.intentions.first.isCompleted, true);

        // Delete intention
        await provider.deleteIntention(intention.id);
        expect(provider.intentions, isEmpty);
      });

      test('should notify listeners on all operations', () async {
        var notifyCount = 0;
        provider.addListener(() {
          notifyCount++;
        });

        final intention = Intention(
          intentionDate: DateTime.now(),
          description: 'Test',
          maxUnits: 0,
          userId: 'user123',
        );

        await provider.addIntention(intention);
        await provider.updateIntention(intention);
        await provider.deleteIntention(intention.id);

        expect(notifyCount, greaterThan(0));
      });
    });
  });
}
