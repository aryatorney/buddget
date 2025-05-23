import 'package:hive_flutter/hive_flutter.dart';
import 'package:buddget/core/repositories/base_repository.dart';
import 'package:buddget/features/group/domain/models/group.dart';

class GroupRepository implements BaseRepository<Group> {
  static const String _boxName = 'groups';
  late Box<Group> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Group>(_boxName);
  }

  @override
  Future<Group?> get(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<Group>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(Group item) async {
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

  // Custom methods for group-specific queries
  Future<List<Group>> getGroupsByMember(String userId) async {
    return _box.values.where((group) => group.memberIds.contains(userId)).toList();
  }

  Future<bool> isMember(String groupId, String userId) async {
    final group = await get(groupId);
    return group?.memberIds.contains(userId) ?? false;
  }

  Future<void> addMember(String groupId, String userId, String userName) async {
    final group = await get(groupId);
    if (group != null) {
      final updatedGroup = group.copyWith(
        memberIds: [...group.memberIds, userId],
        memberNames: {...group.memberNames, userId: userName},
      );
      await save(updatedGroup);
    }
  }
} 