import '../../core/services/storage_service.dart';
import '../../data/repositories/drink_repository.dart';
import '../../data/repositories/intention_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../providers/drink_provider_refactored.dart';
import '../../providers/intention_provider_refactored.dart';
import '../../providers/user_provider_refactored.dart';

/// Service Locator for Dependency Injection
/// Following Dependency Inversion Principle
/// Simple implementation - can be replaced with GetIt package if needed
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  final Map<Type, dynamic> _services = {};
  bool _isInitialized = false;

  /// Initialize all services and repositories
  Future<void> init() async {
    if (_isInitialized) return;

    // Initialize storage service
    final storageService = SharedPrefsStorageService();
    await storageService.init();
    _register<StorageService>(storageService);

    // Register repositories
    _register<DrinkRepository>(DrinkRepositoryImpl(_get<StorageService>()));
    _register<IntentionRepository>(
      IntentionRepositoryImpl(_get<StorageService>()),
    );
    _register<UserRepository>(UserRepositoryImpl(_get<StorageService>()));

    // Register providers
    _register<DrinkProvider>(DrinkProvider(_get<DrinkRepository>()));
    _register<IntentionProvider>(
      IntentionProvider(_get<IntentionRepository>()),
    );
    _register<UserProvider>(UserProvider(_get<UserRepository>()));

    _isInitialized = true;
  }

  /// Register a service
  void _register<T>(T service) {
    _services[T] = service;
  }

  /// Get a service
  T _get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered');
    }
    return service as T;
  }

  /// Public getter for services
  static T get<T>() => _instance._get<T>();

  /// Reset all services (for testing)
  void reset() {
    _services.clear();
    _isInitialized = false;
  }
}
