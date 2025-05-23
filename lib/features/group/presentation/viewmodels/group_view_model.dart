import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/group/data/repositories/group_repository.dart';
import 'package:buddget/features/group/domain/models/group.dart';

final groupViewModelProvider = StateNotifierProvider<GroupViewModel, AsyncValue<List<Group>>>((ref) {
  return GroupViewModel(GroupRepository());
});

class GroupViewModel extends StateNotifier<AsyncValue<List<Group>>> {
  final GroupRepository _repository;

  GroupViewModel(this._repository) : super(const AsyncValue.loading()) {
    loadGroups();
  }

  Future<void> loadGroups() async {
    try {
      state = const AsyncValue.loading();
      final groups = await _repository.getAll();
      state = AsyncValue.data(groups);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createGroup(Group group) async {
    try {
      await _repository.save(group);
      await loadGroups();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addMember(String groupId, String userId, String userName) async {
    try {
      await _repository.addMember(groupId, userId, userName);
      await loadGroups();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<List<Group>> getUserGroups(String userId) async {
    try {
      return await _repository.getGroupsByMember(userId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<bool> checkMembership(String groupId, String userId) async {
    try {
      return await _repository.isMember(groupId, userId);
    } catch (e) {
      return false;
    }
  }
} 