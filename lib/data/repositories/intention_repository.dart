import '../../core/error/failures.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/result.dart';
import '../../core/constants/storage_keys.dart';
import '../../models/intention.dart';

/// Abstract repository for intention operations
abstract class IntentionRepository {
  Future<Result<List<Intention>>> getAllIntentions();
  Future<Result<void>> saveIntention(Intention intention);
  Future<Result<void>> deleteIntention(String intentionId);
  Future<Result<void>> updateIntention(Intention intention);
  Future<Result<void>> clearAll();
  Future<Result<List<Intention>>> getIntentionsForDate(DateTime date);
}

/// Local implementation using StorageService
class IntentionRepositoryImpl implements IntentionRepository {
  final StorageService _storage;

  IntentionRepositoryImpl(this._storage);

  @override
  Future<Result<List<Intention>>> getAllIntentions() async {
    return await _storage.getJsonList(
      StorageKeys.intentionsData,
      Intention.fromJson,
    );
  }

  @override
  Future<Result<void>> saveIntention(Intention intention) async {
    final intentionsResult = await getAllIntentions();

    return await intentionsResult.fold(
      onSuccess: (intentions) async {
        final updatedIntentions = [...intentions, intention];
        return await _saveIntentions(updatedIntentions);
      },
      onError: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<void>> deleteIntention(String intentionId) async {
    final intentionsResult = await getAllIntentions();

    return await intentionsResult.fold(
      onSuccess: (intentions) async {
        final updatedIntentions =
            intentions.where((i) => i.id != intentionId).toList();
        return await _saveIntentions(updatedIntentions);
      },
      onError: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<void>> updateIntention(Intention intention) async {
    final intentionsResult = await getAllIntentions();

    return await intentionsResult.fold(
      onSuccess: (intentions) async {
        final updatedIntentions = intentions.map((i) {
          return i.id == intention.id ? intention : i;
        }).toList();
        return await _saveIntentions(updatedIntentions);
      },
      onError: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<void>> clearAll() async {
    return await _storage.remove(StorageKeys.intentionsData);
  }

  @override
  Future<Result<List<Intention>>> getIntentionsForDate(DateTime date) async {
    final intentionsResult = await getAllIntentions();

    return intentionsResult.map((intentions) {
      final targetDay = DateTime(date.year, date.month, date.day);
      return intentions.where((intention) {
        final intentionDay = DateTime(
          intention.intentionDate.year,
          intention.intentionDate.month,
          intention.intentionDate.day,
        );
        return intentionDay.isAtSameMomentAs(targetDay);
      }).toList();
    });
  }

  Future<Result<void>> _saveIntentions(List<Intention> intentions) async {
    return await _storage.setJsonList(
      StorageKeys.intentionsData,
      intentions,
      (intention) => intention.toJson(),
    );
  }
}
