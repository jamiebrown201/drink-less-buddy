import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_less_buddy/core/di/service_locator.dart';
import 'package:drink_less_buddy/core/services/storage_service.dart';
import 'package:drink_less_buddy/data/repositories/drink_repository.dart';
import 'package:drink_less_buddy/data/repositories/intention_repository.dart';
import 'package:drink_less_buddy/data/repositories/user_repository.dart';
import 'package:drink_less_buddy/providers/drink_provider_refactored.dart';
import 'package:drink_less_buddy/providers/intention_provider_refactored.dart';
import 'package:drink_less_buddy/providers/user_provider_refactored.dart';

void main() {
  group('ServiceLocator', () {
    setUp(() async {
      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});

      // Reset service locator before each test
      ServiceLocator.instance.reset();
    });

    tearDown(() {
      // Clean up after each test
      ServiceLocator.instance.reset();
    });

    group('Singleton pattern', () {
      test('should return same instance', () {
        final instance1 = ServiceLocator.instance;
        final instance2 = ServiceLocator.instance;

        expect(identical(instance1, instance2), true);
      });

      test('should return same instance via static getter', () {
        final instance1 = ServiceLocator.instance;
        final instance2 = ServiceLocator.instance;

        expect(instance1, same(instance2));
      });
    });

    group('Initialization', () {
      test('should initialize all services', () async {
        await ServiceLocator.instance.init();

        // Should not throw when getting services
        expect(
          () => ServiceLocator.get<StorageService>(),
          returnsNormally,
        );
        expect(
          () => ServiceLocator.get<DrinkRepository>(),
          returnsNormally,
        );
        expect(
          () => ServiceLocator.get<IntentionRepository>(),
          returnsNormally,
        );
        expect(
          () => ServiceLocator.get<UserRepository>(),
          returnsNormally,
        );
        expect(
          () => ServiceLocator.get<DrinkProvider>(),
          returnsNormally,
        );
        expect(
          () => ServiceLocator.get<IntentionProvider>(),
          returnsNormally,
        );
        expect(
          () => ServiceLocator.get<UserProvider>(),
          returnsNormally,
        );
      });

      test('should initialize only once', () async {
        await ServiceLocator.instance.init();
        await ServiceLocator.instance.init();
        await ServiceLocator.instance.init();

        // Should still work normally
        final storage = ServiceLocator.get<StorageService>();
        expect(storage, isNotNull);
      });

      test('should throw when getting uninitialized service', () {
        expect(
          () => ServiceLocator.get<StorageService>(),
          throwsException,
        );
      });
    });

    group('Service registration', () {
      test('should register StorageService', () async {
        await ServiceLocator.instance.init();

        final service = ServiceLocator.get<StorageService>();

        expect(service, isA<StorageService>());
        expect(service, isA<SharedPrefsStorageService>());
      });

      test('should register DrinkRepository', () async {
        await ServiceLocator.instance.init();

        final repository = ServiceLocator.get<DrinkRepository>();

        expect(repository, isA<DrinkRepository>());
        expect(repository, isA<DrinkRepositoryImpl>());
      });

      test('should register IntentionRepository', () async {
        await ServiceLocator.instance.init();

        final repository = ServiceLocator.get<IntentionRepository>();

        expect(repository, isA<IntentionRepository>());
        expect(repository, isA<IntentionRepositoryImpl>());
      });

      test('should register UserRepository', () async {
        await ServiceLocator.instance.init();

        final repository = ServiceLocator.get<UserRepository>();

        expect(repository, isA<UserRepository>());
        expect(repository, isA<UserRepositoryImpl>());
      });

      test('should register DrinkProvider', () async {
        await ServiceLocator.instance.init();

        final provider = ServiceLocator.get<DrinkProvider>();

        expect(provider, isA<DrinkProvider>());
      });

      test('should register IntentionProvider', () async {
        await ServiceLocator.instance.init();

        final provider = ServiceLocator.get<IntentionProvider>();

        expect(provider, isA<IntentionProvider>());
      });

      test('should register UserProvider', () async {
        await ServiceLocator.instance.init();

        final provider = ServiceLocator.get<UserProvider>();

        expect(provider, isA<UserProvider>());
      });
    });

    group('Service retrieval', () {
      test('should throw exception for unregistered service', () async {
        await ServiceLocator.instance.init();

        expect(
          () => ServiceLocator.get<String>(),
          throwsException,
        );
      });

      test('should return same instance for multiple gets', () async {
        await ServiceLocator.instance.init();

        final storage1 = ServiceLocator.get<StorageService>();
        final storage2 = ServiceLocator.get<StorageService>();

        expect(identical(storage1, storage2), true);
      });

      test('should maintain singleton pattern for all services', () async {
        await ServiceLocator.instance.init();

        final drink1 = ServiceLocator.get<DrinkRepository>();
        final drink2 = ServiceLocator.get<DrinkRepository>();

        final intention1 = ServiceLocator.get<IntentionRepository>();
        final intention2 = ServiceLocator.get<IntentionRepository>();

        final user1 = ServiceLocator.get<UserRepository>();
        final user2 = ServiceLocator.get<UserRepository>();

        expect(identical(drink1, drink2), true);
        expect(identical(intention1, intention2), true);
        expect(identical(user1, user2), true);
      });
    });

    group('Reset functionality', () {
      test('should clear all services on reset', () async {
        await ServiceLocator.instance.init();

        final storage1 = ServiceLocator.get<StorageService>();

        ServiceLocator.instance.reset();

        expect(
          () => ServiceLocator.get<StorageService>(),
          throwsException,
        );
      });

      test('should allow re-initialization after reset', () async {
        await ServiceLocator.instance.init();
        final storage1 = ServiceLocator.get<StorageService>();

        ServiceLocator.instance.reset();
        await ServiceLocator.instance.init();

        final storage2 = ServiceLocator.get<StorageService>();

        expect(storage2, isNotNull);
        expect(identical(storage1, storage2), false);
      });

      test('should create new instances after reset', () async {
        await ServiceLocator.instance.init();
        final provider1 = ServiceLocator.get<DrinkProvider>();

        ServiceLocator.instance.reset();
        await ServiceLocator.instance.init();

        final provider2 = ServiceLocator.get<DrinkProvider>();

        expect(identical(provider1, provider2), false);
      });
    });

    group('Dependency injection chain', () {
      test('should inject StorageService into repositories', () async {
        await ServiceLocator.instance.init();

        final storage = ServiceLocator.get<StorageService>();
        final drinkRepo = ServiceLocator.get<DrinkRepository>() as DrinkRepositoryImpl;

        // Repositories should have access to storage service
        expect(storage, isNotNull);
        expect(drinkRepo, isNotNull);
      });

      test('should inject repositories into providers', () async {
        await ServiceLocator.instance.init();

        final drinkRepo = ServiceLocator.get<DrinkRepository>();
        final drinkProvider = ServiceLocator.get<DrinkProvider>();

        expect(drinkRepo, isNotNull);
        expect(drinkProvider, isNotNull);
      });

      test('should maintain complete dependency chain', () async {
        await ServiceLocator.instance.init();

        // Get services at each layer
        final storage = ServiceLocator.get<StorageService>();
        final repository = ServiceLocator.get<DrinkRepository>();
        final provider = ServiceLocator.get<DrinkProvider>();

        // All should be properly initialized
        expect(storage, isNotNull);
        expect(repository, isNotNull);
        expect(provider, isNotNull);
      });
    });

    group('Integration scenarios', () {
      test('should support full app initialization flow', () async {
        // Simulate app startup
        expect(
          () => ServiceLocator.get<StorageService>(),
          throwsException,
        );

        // Initialize
        await ServiceLocator.instance.init();

        // All services should be available
        final storage = ServiceLocator.get<StorageService>();
        final drinkRepo = ServiceLocator.get<DrinkRepository>();
        final intentionRepo = ServiceLocator.get<IntentionRepository>();
        final userRepo = ServiceLocator.get<UserRepository>();
        final drinkProvider = ServiceLocator.get<DrinkProvider>();
        final intentionProvider = ServiceLocator.get<IntentionProvider>();
        final userProvider = ServiceLocator.get<UserProvider>();

        expect(storage, isNotNull);
        expect(drinkRepo, isNotNull);
        expect(intentionRepo, isNotNull);
        expect(userRepo, isNotNull);
        expect(drinkProvider, isNotNull);
        expect(intentionProvider, isNotNull);
        expect(userProvider, isNotNull);
      });

      test('should support test isolation with reset', () async {
        // Test 1
        await ServiceLocator.instance.init();
        final provider1 = ServiceLocator.get<DrinkProvider>();
        ServiceLocator.instance.reset();

        // Test 2 (isolated)
        await ServiceLocator.instance.init();
        final provider2 = ServiceLocator.get<DrinkProvider>();

        expect(identical(provider1, provider2), false);
      });

      test('should handle multiple service types correctly', () async {
        await ServiceLocator.instance.init();

        // Get different service types
        final storage = ServiceLocator.get<StorageService>();
        final drink = ServiceLocator.get<DrinkRepository>();
        final intention = ServiceLocator.get<IntentionRepository>();
        final user = ServiceLocator.get<UserRepository>();

        // All should be different instances
        expect(storage, isNot(drink));
        expect(drink, isNot(intention));
        expect(intention, isNot(user));

        // But each type should return same instance
        final storage2 = ServiceLocator.get<StorageService>();
        expect(identical(storage, storage2), true);
      });
    });

    group('Error handling', () {
      test('should provide clear error message for unregistered service', () async {
        await ServiceLocator.instance.init();

        try {
          ServiceLocator.get<String>();
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('String'));
          expect(e.toString(), contains('not registered'));
        }
      });

      test('should handle getting service before init', () {
        expect(
          () => ServiceLocator.get<StorageService>(),
          throwsException,
        );
      });

      test('should handle multiple resets', () {
        ServiceLocator.instance.reset();
        ServiceLocator.instance.reset();
        ServiceLocator.instance.reset();

        expect(
          () => ServiceLocator.get<StorageService>(),
          throwsException,
        );
      });
    });
  });
}
