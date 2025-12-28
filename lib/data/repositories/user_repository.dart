import '../../core/error/failures.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/result.dart';
import '../../core/constants/storage_keys.dart';
import '../../models/user.dart';

/// Abstract repository for user operations
abstract class UserRepository {
  Future<Result<User?>> getUser();
  Future<Result<void>> saveUser(User user);
  Future<Result<void>> deleteUser();
  Future<Result<void>> updateWeeklyGoal(double goal);
  Future<Result<void>> upgradeToPremium();
}

/// Local implementation using StorageService
class UserRepositoryImpl implements UserRepository {
  final StorageService _storage;

  UserRepositoryImpl(this._storage);

  @override
  Future<Result<User?>> getUser() async {
    return await _storage.getJson(
      StorageKeys.userData,
      User.fromJson,
    );
  }

  @override
  Future<Result<void>> saveUser(User user) async {
    return await _storage.setJson(
      StorageKeys.userData,
      user,
      (user) => user.toJson(),
    );
  }

  @override
  Future<Result<void>> deleteUser() async {
    return await _storage.remove(StorageKeys.userData);
  }

  @override
  Future<Result<void>> updateWeeklyGoal(double goal) async {
    final userResult = await getUser();

    return await userResult.fold(
      onSuccess: (user) async {
        if (user == null) {
          return const Error(
            StorageFailure('User not found'),
          );
        }
        final updatedUser = user.copyWith(weeklyGoalUnits: goal);
        return await saveUser(updatedUser);
      },
      onError: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<void>> upgradeToPremium() async {
    final userResult = await getUser();

    return await userResult.fold(
      onSuccess: (user) async {
        if (user == null) {
          return const Error(
            StorageFailure('User not found'),
          );
        }
        final updatedUser = user.copyWith(isPremium: true);
        return await saveUser(updatedUser);
      },
      onError: (failure) => Error(failure),
    );
  }
}
