import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../error/failures.dart';
import '../utils/result.dart';

/// Abstract storage service interface
/// Following Dependency Inversion Principle
abstract class StorageService {
  Future<Result<String?>> getString(String key);
  Future<Result<void>> setString(String key, String value);
  Future<Result<void>> remove(String key);
  Future<Result<void>> clear();
  Future<Result<bool>> containsKey(String key);
}

/// Implementation using SharedPreferences
/// Can be easily swapped with different implementation
class SharedPrefsStorageService implements StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError(
        'StorageService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  @override
  Future<Result<String?>> getString(String key) async {
    try {
      final value = _instance.getString(key);
      return Success(value);
    } catch (e, stackTrace) {
      return Error(StorageFailure('Failed to get $key', stackTrace));
    }
  }

  @override
  Future<Result<void>> setString(String key, String value) async {
    try {
      await _instance.setString(key, value);
      return const Success(null);
    } catch (e, stackTrace) {
      return Error(StorageFailure('Failed to set $key', stackTrace));
    }
  }

  @override
  Future<Result<void>> remove(String key) async {
    try {
      await _instance.remove(key);
      return const Success(null);
    } catch (e, stackTrace) {
      return Error(StorageFailure('Failed to remove $key', stackTrace));
    }
  }

  @override
  Future<Result<void>> clear() async {
    try {
      await _instance.clear();
      return const Success(null);
    } catch (e, stackTrace) {
      return Error(StorageFailure('Failed to clear storage', stackTrace));
    }
  }

  @override
  Future<Result<bool>> containsKey(String key) async {
    try {
      final contains = _instance.containsKey(key);
      return Success(contains);
    } catch (e, stackTrace) {
      return Error(StorageFailure('Failed to check $key', stackTrace));
    }
  }
}

/// Extension for JSON storage
extension JsonStorageExtension on StorageService {
  Future<Result<T?>> getJson<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final result = await getString(key);
    return result.fold(
      onSuccess: (jsonString) {
        if (jsonString == null) return const Success(null);
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return Success(fromJson(json));
        } catch (e, stackTrace) {
          return Error(StorageFailure('Failed to parse JSON', stackTrace));
        }
      },
      onError: (failure) => Error(failure),
    );
  }

  Future<Result<List<T>>> getJsonList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final result = await getString(key);
    return result.fold(
      onSuccess: (jsonString) {
        if (jsonString == null) return const Success([]);
        try {
          final jsonList = jsonDecode(jsonString) as List<dynamic>;
          final items = jsonList
              .map((json) => fromJson(json as Map<String, dynamic>))
              .toList();
          return Success(items);
        } catch (e, stackTrace) {
          return Error(StorageFailure('Failed to parse JSON list', stackTrace));
        }
      },
      onError: (failure) => Error(failure),
    );
  }

  Future<Result<void>> setJson<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      final jsonString = jsonEncode(toJson(value));
      return await setString(key, jsonString);
    } catch (e, stackTrace) {
      return Error(StorageFailure('Failed to encode JSON', stackTrace));
    }
  }

  Future<Result<void>> setJsonList<T>(
    String key,
    List<T> values,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      final jsonList = values.map(toJson).toList();
      final jsonString = jsonEncode(jsonList);
      return await setString(key, jsonString);
    } catch (e, stackTrace) {
      return Error(StorageFailure('Failed to encode JSON list', stackTrace));
    }
  }
}
