import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_less_buddy/data/repositories/intention_repository.dart';
import 'package:drink_less_buddy/core/services/storage_service.dart';
import 'package:drink_less_buddy/models/intention.dart';

void main() {
  group('IntentionRepository', () {
    late IntentionRepository repository;
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = SharedPrefsStorageService();
      await storage.init();
      repository = IntentionRepositoryImpl(storage);
    });

    group('getAllIntentions', () {
      test('should return empty list when no intentions exist', () async {
        final result = await repository.getAllIntentions();

        expect(result.isSuccess, true);
        expect(result.value, isEmpty);
      });

      test('should return all saved intentions', () async {
        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 2),
          description: 'Maximum 2 units',
          maxUnits: 2,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);

        final result = await repository.getAllIntentions();

        expect(result.isSuccess, true);
        expect(result.value, hasLength(2));
        expect(result.value[0].description, 'No drinking today');
        expect(result.value[1].description, 'Maximum 2 units');
      });

      test('should deserialize intentions correctly', () async {
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 15, 10, 30),
          description: 'Stay sober for the meeting',
          maxUnits: 0,
          userId: 'user123',
        );

        await repository.saveIntention(intention);

        final result = await repository.getAllIntentions();

        expect(result.isSuccess, true);
        expect(result.value.first.description, 'Stay sober for the meeting');
        expect(result.value.first.maxUnits, 0);
      });
    });

    group('saveIntention', () {
      test('should save intention successfully', () async {
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        final result = await repository.saveIntention(intention);

        expect(result.isSuccess, true);

        final allIntentions = await repository.getAllIntentions();
        expect(allIntentions.value, hasLength(1));
        expect(allIntentions.value.first.id, intention.id);
      });

      test('should append to existing intentions', () async {
        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 2),
          description: 'Maximum 2 units',
          maxUnits: 2,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);

        final result = await repository.getAllIntentions();

        expect(result.value, hasLength(2));
      });

      test('should preserve all intention properties', () async {
        final intentionDate = DateTime(2024, 1, 15, 10, 30);
        final intention = Intention(
          intentionDate: intentionDate,
          description: 'Limit to 3 units at party',
          maxUnits: 3,
          userId: 'user123',
        );

        await repository.saveIntention(intention);

        final result = await repository.getAllIntentions();
        final saved = result.value.first;

        expect(saved.id, intention.id);
        expect(saved.intentionDate, intentionDate);
        expect(saved.description, 'Limit to 3 units at party');
        expect(saved.maxUnits, 3);
        expect(saved.userId, 'user123');
      });
    });

    group('deleteIntention', () {
      test('should delete intention by id', () async {
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        await repository.saveIntention(intention);

        final deleteResult = await repository.deleteIntention(intention.id);

        expect(deleteResult.isSuccess, true);

        final allIntentions = await repository.getAllIntentions();
        expect(allIntentions.value, isEmpty);
      });

      test('should only delete specified intention', () async {
        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 2),
          description: 'Maximum 2 units',
          maxUnits: 2,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);

        await repository.deleteIntention(intention1.id);

        final result = await repository.getAllIntentions();

        expect(result.value, hasLength(1));
        expect(result.value.first.id, intention2.id);
      });

      test('should handle deleting non-existent intention', () async {
        final result = await repository.deleteIntention('non-existent-id');

        expect(result.isSuccess, true);

        final allIntentions = await repository.getAllIntentions();
        expect(allIntentions.value, isEmpty);
      });
    });

    group('updateIntention', () {
      test('should update existing intention', () async {
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        await repository.saveIntention(intention);

        final updated = Intention(
          id: intention.id,
          intentionDate: intention.intentionDate,
          description: 'Changed my mind - max 2 units',
          maxUnits: 2,
          userId: 'user123',
        );

        final updateResult = await repository.updateIntention(updated);

        expect(updateResult.isSuccess, true);

        final result = await repository.getAllIntentions();

        expect(result.value, hasLength(1));
        expect(result.value.first.description, 'Changed my mind - max 2 units');
        expect(result.value.first.maxUnits, 2);
      });

      test('should only update specified intention', () async {
        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 2),
          description: 'Maximum 2 units',
          maxUnits: 2,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);

        final updated = Intention(
          id: intention1.id,
          intentionDate: intention1.intentionDate,
          description: 'Updated intention',
          maxUnits: 1,
          userId: 'user123',
        );

        await repository.updateIntention(updated);

        final result = await repository.getAllIntentions();

        expect(result.value, hasLength(2));
        expect(result.value[0].description, 'Updated intention');
        expect(result.value[1].description, 'Maximum 2 units');
      });

      test('should preserve intention ID', () async {
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        await repository.saveIntention(intention);

        final updated = Intention(
          id: intention.id,
          intentionDate: intention.intentionDate,
          description: 'Updated',
          maxUnits: 3,
          userId: 'user123',
        );

        await repository.updateIntention(updated);

        final result = await repository.getAllIntentions();

        expect(result.value.first.id, intention.id);
      });
    });

    group('clearAll', () {
      test('should remove all intentions', () async {
        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 2),
          description: 'Maximum 2 units',
          maxUnits: 2,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);

        final clearResult = await repository.clearAll();

        expect(clearResult.isSuccess, true);

        final result = await repository.getAllIntentions();
        expect(result.value, isEmpty);
      });

      test('should handle clearing empty repository', () async {
        final result = await repository.clearAll();

        expect(result.isSuccess, true);

        final allIntentions = await repository.getAllIntentions();
        expect(allIntentions.value, isEmpty);
      });
    });

    group('getIntentionsForDate', () {
      test('should return intentions for specific date', () async {
        final targetDate = DateTime(2024, 1, 15);

        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 15, 10, 0),
          description: 'For today',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 16, 14, 30),
          description: 'For tomorrow',
          maxUnits: 2,
          userId: 'user123',
        );

        final intention3 = Intention(
          intentionDate: DateTime(2024, 1, 15, 20, 0),
          description: 'Also for today',
          maxUnits: 1,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);
        await repository.saveIntention(intention3);

        final result = await repository.getIntentionsForDate(targetDate);

        expect(result.isSuccess, true);
        expect(result.value, hasLength(2));
        expect(result.value[0].description, 'For today');
        expect(result.value[1].description, 'Also for today');
      });

      test('should return empty list when no intentions for date', () async {
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 15),
          description: 'For specific day',
          maxUnits: 0,
          userId: 'user123',
        );

        await repository.saveIntention(intention);

        final result = await repository.getIntentionsForDate(DateTime(2024, 1, 20));

        expect(result.isSuccess, true);
        expect(result.value, isEmpty);
      });

      test('should ignore time component when matching dates', () async {
        final targetDate = DateTime(2024, 1, 15, 23, 59);

        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 15, 0, 0),
          description: 'Start of day',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 1, 15, 23, 59),
          description: 'End of day',
          maxUnits: 1,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);

        final result = await repository.getIntentionsForDate(targetDate);

        expect(result.isSuccess, true);
        expect(result.value, hasLength(2));
      });

      test('should handle month boundaries correctly', () async {
        final intention1 = Intention(
          intentionDate: DateTime(2024, 1, 31),
          description: 'Last day of January',
          maxUnits: 0,
          userId: 'user123',
        );

        final intention2 = Intention(
          intentionDate: DateTime(2024, 2, 1),
          description: 'First day of February',
          maxUnits: 2,
          userId: 'user123',
        );

        await repository.saveIntention(intention1);
        await repository.saveIntention(intention2);

        final janResult = await repository.getIntentionsForDate(DateTime(2024, 1, 31));
        expect(janResult.value, hasLength(1));
        expect(janResult.value.first.description, 'Last day of January');

        final febResult = await repository.getIntentionsForDate(DateTime(2024, 2, 1));
        expect(febResult.value, hasLength(1));
        expect(febResult.value.first.description, 'First day of February');
      });
    });

    group('Integration scenarios', () {
      test('should handle full CRUD operations', () async {
        // Create
        final intention = Intention(
          intentionDate: DateTime(2024, 1, 1),
          description: 'No drinking today',
          maxUnits: 0,
          userId: 'user123',
        );

        await repository.saveIntention(intention);

        // Read
        var allIntentions = await repository.getAllIntentions();
        expect(allIntentions.value, hasLength(1));

        // Update
        final updated = Intention(
          id: intention.id,
          intentionDate: intention.intentionDate,
          description: 'Updated intention',
          maxUnits: 2,
          userId: 'user123',
        );

        await repository.updateIntention(updated);

        allIntentions = await repository.getAllIntentions();
        expect(allIntentions.value.first.description, 'Updated intention');

        // Delete
        await repository.deleteIntention(intention.id);

        allIntentions = await repository.getAllIntentions();
        expect(allIntentions.value, isEmpty);
      });

      test('should maintain data integrity across operations', () async {
        final intentions = List.generate(
          7,
          (i) => Intention(
            intentionDate: DateTime(2024, 1, i + 1),
            description: 'Intention for day ${i + 1}',
            maxUnits: i.toDouble(),
            userId: 'user123',
          ),
        );

        for (final intention in intentions) {
          await repository.saveIntention(intention);
        }

        final result = await repository.getAllIntentions();
        expect(result.value, hasLength(7));

        // Verify all unique IDs
        final ids = result.value.map((i) => i.id).toSet();
        expect(ids, hasLength(7));

        // Verify we can query by date
        final day3 = await repository.getIntentionsForDate(DateTime(2024, 1, 3));
        expect(day3.value, hasLength(1));
        expect(day3.value.first.description, 'Intention for day 3');
      });

      test('should handle weekly planning scenario', () async {
        // Set intentions for the week
        for (int i = 0; i < 7; i++) {
          final intention = Intention(
            intentionDate: DateTime(2024, 1, 1 + i),
            description: 'Week plan day ${i + 1}',
            maxUnits: i % 2 == 0 ? 0 : 2,
            userId: 'user123',
          );
          await repository.saveIntention(intention);
        }

        // Verify all saved
        final all = await repository.getAllIntentions();
        expect(all.value, hasLength(7));

        // Check specific days
        final monday = await repository.getIntentionsForDate(DateTime(2024, 1, 1));
        expect(monday.value.first.maxUnits, 0);

        final tuesday = await repository.getIntentionsForDate(DateTime(2024, 1, 2));
        expect(tuesday.value.first.maxUnits, 2);
      });
    });
  });
}
