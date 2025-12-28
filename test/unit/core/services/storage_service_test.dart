import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_less_buddy/core/services/storage_service.dart';
import 'package:drink_less_buddy/core/error/failures.dart';
import 'package:drink_less_buddy/core/utils/result.dart';

void main() {
  group('SharedPrefsStorageService', () {
    late SharedPrefsStorageService service;

    setUp(() async {
      // Set up mock values
      SharedPreferences.setMockInitialValues({});
      service = SharedPrefsStorageService();
      await service.init();
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        final newService = SharedPrefsStorageService();
        await newService.init();

        // Should not throw when accessing methods
        final result = await newService.getString('test');
        expect(result.isSuccess, true);
      });

      test('should throw if accessed before initialization', () async {
        final uninitializedService = SharedPrefsStorageService();

        expect(
          () => uninitializedService.getString('test'),
          throwsStateError,
        );
      });
    });

    group('getString', () {
      test('should return null for non-existent key', () async {
        final result = await service.getString('non_existent');

        expect(result.isSuccess, true);
        expect(result.value, isNull);
      });

      test('should return stored string value', () async {
        await service.setString('test_key', 'test_value');

        final result = await service.getString('test_key');

        expect(result.isSuccess, true);
        expect(result.value, 'test_value');
      });

      test('should return success result', () async {
        final result = await service.getString('any_key');

        expect(result, isA<Success<String?>>());
        expect(result.isSuccess, true);
        expect(result.isFailure, false);
      });
    });

    group('setString', () {
      test('should store string value', () async {
        final setResult = await service.setString('test_key', 'test_value');

        expect(setResult.isSuccess, true);

        final getResult = await service.getString('test_key');
        expect(getResult.value, 'test_value');
      });

      test('should overwrite existing value', () async {
        await service.setString('test_key', 'old_value');
        await service.setString('test_key', 'new_value');

        final result = await service.getString('test_key');
        expect(result.value, 'new_value');
      });

      test('should return success result', () async {
        final result = await service.setString('key', 'value');

        expect(result, isA<Success<void>>());
        expect(result.isSuccess, true);
      });
    });

    group('remove', () {
      test('should remove existing key', () async {
        await service.setString('test_key', 'test_value');

        final removeResult = await service.remove('test_key');
        expect(removeResult.isSuccess, true);

        final getResult = await service.getString('test_key');
        expect(getResult.value, isNull);
      });

      test('should handle removing non-existent key', () async {
        final result = await service.remove('non_existent');

        expect(result.isSuccess, true);
      });

      test('should return success result', () async {
        final result = await service.remove('any_key');

        expect(result, isA<Success<void>>());
      });
    });

    group('clear', () {
      test('should remove all keys', () async {
        await service.setString('key1', 'value1');
        await service.setString('key2', 'value2');
        await service.setString('key3', 'value3');

        final clearResult = await service.clear();
        expect(clearResult.isSuccess, true);

        final result1 = await service.getString('key1');
        final result2 = await service.getString('key2');
        final result3 = await service.getString('key3');

        expect(result1.value, isNull);
        expect(result2.value, isNull);
        expect(result3.value, isNull);
      });

      test('should return success result', () async {
        final result = await service.clear();

        expect(result, isA<Success<void>>());
      });
    });

    group('containsKey', () {
      test('should return true for existing key', () async {
        await service.setString('test_key', 'test_value');

        final result = await service.containsKey('test_key');

        expect(result.isSuccess, true);
        expect(result.value, true);
      });

      test('should return false for non-existent key', () async {
        final result = await service.containsKey('non_existent');

        expect(result.isSuccess, true);
        expect(result.value, false);
      });

      test('should return false after removal', () async {
        await service.setString('test_key', 'test_value');
        await service.remove('test_key');

        final result = await service.containsKey('test_key');

        expect(result.value, false);
      });
    });

    group('JSON Extension - getJson', () {
      test('should return null for non-existent key', () async {
        final result = await service.getJson(
          'non_existent',
          (json) => json['test'] as String,
        );

        expect(result.isSuccess, true);
        expect(result.value, isNull);
      });

      test('should deserialize JSON object', () async {
        await service.setString('user', '{"name":"John","age":30}');

        final result = await service.getJson(
          'user',
          (json) => json,
        );

        expect(result.isSuccess, true);
        expect(result.value, {'name': 'John', 'age': 30});
      });

      test('should return error for invalid JSON', () async {
        await service.setString('invalid', 'not valid json');

        final result = await service.getJson(
          'invalid',
          (json) => json,
        );

        expect(result.isFailure, true);
        expect(result.failure, isA<StorageFailure>());
        expect(result.failure.message, contains('parse JSON'));
      });

      test('should handle complex objects with fromJson', () async {
        await service.setString(
          'drink',
          '{"type":"Beer","units":2.5}',
        );

        final result = await service.getJson(
          'drink',
          (json) => {
            'type': json['type'],
            'units': json['units'],
          },
        );

        expect(result.isSuccess, true);
        expect(result.value?['type'], 'Beer');
        expect(result.value?['units'], 2.5);
      });
    });

    group('JSON Extension - getJsonList', () {
      test('should return empty list for non-existent key', () async {
        final result = await service.getJsonList(
          'non_existent',
          (json) => json,
        );

        expect(result.isSuccess, true);
        expect(result.value, isEmpty);
      });

      test('should deserialize JSON list', () async {
        await service.setString(
          'drinks',
          '[{"type":"Beer","units":2},{"type":"Wine","units":3}]',
        );

        final result = await service.getJsonList(
          'drinks',
          (json) => json,
        );

        expect(result.isSuccess, true);
        expect(result.value, hasLength(2));
        expect(result.value[0]['type'], 'Beer');
        expect(result.value[1]['type'], 'Wine');
      });

      test('should return error for invalid JSON', () async {
        await service.setString('invalid', 'not valid json');

        final result = await service.getJsonList(
          'invalid',
          (json) => json,
        );

        expect(result.isFailure, true);
        expect(result.failure, isA<StorageFailure>());
      });
    });

    group('JSON Extension - setJson', () {
      test('should serialize and store object', () async {
        final user = {'name': 'John', 'age': 30};

        final setResult = await service.setJson(
          'user',
          user,
          (u) => u,
        );

        expect(setResult.isSuccess, true);

        final getResult = await service.getString('user');
        expect(getResult.value, '{"name":"John","age":30}');
      });

      test('should handle complex objects', () async {
        final drink = {
          'id': '123',
          'type': 'Beer',
          'units': 2.5,
          'timestamp': DateTime(2024, 1, 1).toIso8601String(),
        };

        final setResult = await service.setJson(
          'drink',
          drink,
          (d) => d,
        );

        expect(setResult.isSuccess, true);

        final getResult = await service.getJson('drink', (json) => json);
        expect(getResult.value?['type'], 'Beer');
        expect(getResult.value?['units'], 2.5);
      });
    });

    group('JSON Extension - setJsonList', () {
      test('should serialize and store list', () async {
        final drinks = [
          {'type': 'Beer', 'units': 2.0},
          {'type': 'Wine', 'units': 3.0},
        ];

        final setResult = await service.setJsonList(
          'drinks',
          drinks,
          (d) => d,
        );

        expect(setResult.isSuccess, true);

        final getResult = await service.getJsonList('drinks', (json) => json);
        expect(getResult.value, hasLength(2));
        expect(getResult.value[0]['type'], 'Beer');
        expect(getResult.value[1]['type'], 'Wine');
      });

      test('should handle empty list', () async {
        final setResult = await service.setJsonList(
          'empty',
          [],
          (d) => d,
        );

        expect(setResult.isSuccess, true);

        final getResult = await service.getJsonList('empty', (json) => json);
        expect(getResult.value, isEmpty);
      });
    });

    group('Integration scenarios', () {
      test('should handle full read-write cycle', () async {
        // Write
        await service.setString('key1', 'value1');
        await service.setString('key2', 'value2');

        // Read
        final result1 = await service.getString('key1');
        final result2 = await service.getString('key2');

        expect(result1.value, 'value1');
        expect(result2.value, 'value2');

        // Update
        await service.setString('key1', 'updated');

        final updated = await service.getString('key1');
        expect(updated.value, 'updated');

        // Delete
        await service.remove('key1');

        final deleted = await service.getString('key1');
        expect(deleted.value, isNull);
      });

      test('should handle multiple JSON objects', () async {
        final user = {'name': 'John', 'isPremium': true};
        final settings = {'theme': 'dark', 'notifications': true};

        await service.setJson('user', user, (u) => u);
        await service.setJson('settings', settings, (s) => s);

        final userResult = await service.getJson('user', (j) => j);
        final settingsResult = await service.getJson('settings', (j) => j);

        expect(userResult.value?['name'], 'John');
        expect(settingsResult.value?['theme'], 'dark');
      });

      test('should verify data persistence simulation', () async {
        // Store data
        await service.setString('persisted', 'data');

        // Verify it exists
        final contains = await service.containsKey('persisted');
        expect(contains.value, true);

        // Read it back
        final read = await service.getString('persisted');
        expect(read.value, 'data');

        // Clear all
        await service.clear();

        // Verify it's gone
        final afterClear = await service.containsKey('persisted');
        expect(afterClear.value, false);
      });
    });
  });
}
