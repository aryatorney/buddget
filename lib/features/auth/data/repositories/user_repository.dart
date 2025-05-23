import 'package:hive_flutter/hive_flutter.dart';
import 'package:buddget/core/repositories/base_repository.dart';
import 'package:buddget/features/auth/domain/models/user.dart';

class UserRepository implements BaseRepository<User> {
  static const String _boxName = 'users';
  late Box<User> _box;

  Future<void> init() async {
    _box = await Hive.openBox<User>(_boxName);
  }

  @override
  Future<User?> get(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<User>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(User item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  // Custom methods for user-specific queries
  Future<void> updateBalance(String userId, String groupId, double amount) async {
    final user = await get(userId);
    if (user != null) {
      final newBalances = Map<String, double>.from(user.totalBalances);
      newBalances[groupId] = (newBalances[groupId] ?? 0) + amount;
      
      final updatedUser = user.copyWith(totalBalances: newBalances);
      await save(updatedUser);
    }
  }

  Future<void> addToGroup(String userId, String groupId) async {
    final user = await get(userId);
    if (user != null) {
      final updatedUser = user.copyWith(
        groupIds: [...user.groupIds, groupId],
        totalBalances: {...user.totalBalances, groupId: 0.0},
      );
      await save(updatedUser);
    }
  }

  Future<void> updateDarkMode(String userId, bool isDarkMode) async {
    final user = await get(userId);
    if (user != null) {
      final updatedUser = user.copyWith(isDarkMode: isDarkMode);
      await save(updatedUser);
    }
  }
} 