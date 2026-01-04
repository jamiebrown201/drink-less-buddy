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
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'No drinking today',
          userId: 'user123',
        ));

        await provider.loadIntentions();

        expect(provider.intentions, hasLength(1));
        expect(provider.intentions.first.activity, 'No drinking today');
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
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'No drinking today',
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
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'No drinking today',
          userId: 'user123',
        );

        await provider.addIntention(intention);

        expect(notified, true);
      });

      test('should append to existing intentions', () async {
        final intention1 = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime(2024, 1, 1),
          activity: 'First intention',
          userId: 'user123',
        );

        final intention2 = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime(2024, 1, 2),
          activity: 'Second intention',
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
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'No drinking today',
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final updated = Intention(
          id: intention.id,
          createdAt: intention.createdAt,
          intentionDate: intention.intentionDate,
          activity: 'Updated activity',
          userId: 'user123',
        );

        final success = await provider.updateIntention(updated);

        expect(success, true);
        expect(provider.intentions.first.activity, 'Updated activity');
      });

      test('should preserve intention count', () async {
        final intention = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'Original',
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final updated = intention.copyWith(activity: 'Updated');

        await provider.updateIntention(updated);

        expect(provider.intentions, hasLength(1));
      });
    });

    group('completeIntention', () {
      test('should mark intention as completed', () async {
        final intention = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'No drinking today',
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
          createdAt: DateTime.now(),
          intentionDate: DateTime(2024, 1, 1),
          activity: 'No drinking today',
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(intention);

        await provider.completeIntention(intention.id);

        final completed = provider.intentions.first;
        expect(completed.activity, 'No drinking today');
        expect(completed.intentionDate, DateTime(2024, 1, 1));
      });
    });

    group('deleteIntention', () {
      test('should delete intention successfully', () async {
        final intention = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'No drinking today',
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final success = await provider.deleteIntention(intention.id);

        expect(success, true);
        expect(provider.intentions, isEmpty);
      });

      test('should only delete specified intention', () async {
        final intention1 = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'First',
          userId: 'user123',
        );

        final intention2 = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'Second',
          userId: 'user123',
        );

        await provider.addIntention(intention1);
        await provider.addIntention(intention2);

        await provider.deleteIntention(intention1.id);

        expect(provider.intentions, hasLength(1));
        expect(provider.intentions.first.activity, 'Second');
      });
    });

    group('getTodayIntentions', () {
      test('should return intentions for today', () async {
        final today = DateTime.now();
        final tomorrow = today.add(const Duration(days: 1));

        final todayIntention = Intention(
          createdAt: DateTime.now(),
          intentionDate: today,
          activity: 'Today',
          userId: 'user123',
        );

        final tomorrowIntention = Intention(
          createdAt: DateTime.now(),
          intentionDate: tomorrow,
          activity: 'Tomorrow',
          userId: 'user123',
        );

        await provider.addIntention(todayIntention);
        await provider.addIntention(tomorrowIntention);

        final todayList = provider.getTodayIntentions();

        expect(todayList, hasLength(1));
        expect(todayList.first.activity, 'Today');
      });

      test('should return empty list when no intentions for today', () async {
        final tomorrow = DateTime.now().add(const Duration(days: 1));

        final intention = Intention(
          createdAt: DateTime.now(),
          intentionDate: tomorrow,
          activity: 'Tomorrow',
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
          createdAt: DateTime.now(),
          intentionDate: tomorrow,
          activity: 'Tomorrow',
          userId: 'user123',
        );

        await provider.addIntention(intention);

        final tomorrowList = provider.getTomorrowIntentions();

        expect(tomorrowList, hasLength(1));
        expect(tomorrowList.first.activity, 'Tomorrow');
      });
    });

    group('getTodayIncompleteIntentions', () {
      test('should return only incomplete intentions for today', () async {
        final today = DateTime.now();

        final completed = Intention(
          createdAt: DateTime.now(),
          intentionDate: today,
          activity: 'Completed',
          userId: 'user123',
          isCompleted: true,
        );

        final incomplete = Intention(
          createdAt: DateTime.now(),
          intentionDate: today,
          activity: 'Incomplete',
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(completed);
        await provider.addIntention(incomplete);

        final incompleteList = provider.getTodayIncompleteIntentions();

        expect(incompleteList, hasLength(1));
        expect(incompleteList.first.activity, 'Incomplete');
      });
    });

    group('getTodayCompletionRate', () {
      test('should calculate completion rate correctly', () async {
        final today = DateTime.now();

        final completed1 = Intention(
          createdAt: DateTime.now(),
          intentionDate: today,
          activity: 'Done 1',
          userId: 'user123',
          isCompleted: true,
        );

        final completed2 = Intention(
          createdAt: DateTime.now(),
          intentionDate: today,
          activity: 'Done 2',
          userId: 'user123',
          isCompleted: true,
        );

        final incomplete = Intention(
          createdAt: DateTime.now(),
          intentionDate: today,
          activity: 'Not done',
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
          createdAt: DateTime.now(),
          intentionDate: today,
          activity: 'Done',
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
          createdAt: DateTime.now(),
          intentionDate: tomorrow,
          activity: 'Tomorrow',
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
          createdAt: DateTime.now(),
          intentionDate: targetDate,
          activity: 'Target date',
          userId: 'user123',
        );

        final other = Intention(
          createdAt: DateTime.now(),
          intentionDate: otherDate,
          activity: 'Other date',
          userId: 'user123',
        );

        await provider.addIntention(target);
        await provider.addIntention(other);

        final list = provider.getIntentionsForDate(targetDate);

        expect(list, hasLength(1));
        expect(list.first.activity, 'Target date');
      });

      test('should ignore time component', () async {
        final date = DateTime(2024, 1, 15);
        final morning = DateTime(2024, 1, 15, 8, 0);
        final evening = DateTime(2024, 1, 15, 20, 0);

        final morningIntention = Intention(
          createdAt: DateTime.now(),
          intentionDate: morning,
          activity: 'Morning',
          userId: 'user123',
        );

        final eveningIntention = Intention(
          createdAt: DateTime.now(),
          intentionDate: evening,
          activity: 'Evening',
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
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'First',
          userId: 'user123',
        );

        final intention2 = Intention(
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'Second',
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
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'No drinking today',
          userId: 'user123',
          isCompleted: false,
        );

        await provider.addIntention(intention);
        expect(provider.intentions, hasLength(1));

        // Update intention
        final updated = intention.copyWith(activity: 'Updated');
        await provider.updateIntention(updated);
        expect(provider.intentions.first.activity, 'Updated');

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
          createdAt: DateTime.now(),
          intentionDate: DateTime.now(),
          activity: 'Test',
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
