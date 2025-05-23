import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/group/domain/models/group.dart';

// Mock group data
final mockGroups = <Group>[
  Group(
    id: 'group1',
    name: 'Weekend Trip',
    memberIds: ['mock_user_id', 'user2', 'user3'],
    memberNames: {
      'mock_user_id': 'John Doe',
      'user2': 'Alice Smith',
      'user3': 'Bob Johnson',
    },
    createdById: 'mock_user_id',
    createdAt: DateTime.now(),
  ),
  Group(
    id: 'group2',
    name: 'Shared Apartment',
    memberIds: ['mock_user_id', 'user4'],
    memberNames: {
      'mock_user_id': 'John Doe',
      'user4': 'Emma Wilson',
    },
    createdById: 'mock_user_id',
    createdAt: DateTime.now(),
  ),
];

final groupViewModelProvider = StateNotifierProvider<GroupViewModel, AsyncValue<List<Group>>>((ref) {
  return GroupViewModel();
});

class GroupViewModel extends StateNotifier<AsyncValue<List<Group>>> {
  GroupViewModel() : super(const AsyncValue.data([])) {
    loadGroups();
  }

  void loadGroups() {
    state = AsyncValue.data(List<Group>.from(mockGroups));
  }

  void createGroup(String name) {
    final currentGroups = List<Group>.from(state.value ?? []);
    final newGroup = Group(
      id: 'group${currentGroups.length + 1}',
      name: name,
      memberIds: ['mock_user_id'],
      memberNames: {'mock_user_id': 'John Doe'},
      createdById: 'mock_user_id',
      createdAt: DateTime.now(),
    );
    currentGroups.add(newGroup);
    state = AsyncValue.data(currentGroups);
  }

  void addMember(String groupId, String userId, String userName) {
    final currentGroups = List<Group>.from(state.value ?? []);
    final groupIndex = currentGroups.indexWhere((g) => g.id == groupId);
    
    if (groupIndex != -1) {
      final group = currentGroups[groupIndex];
      final updatedGroup = Group(
        id: group.id,
        name: group.name,
        memberIds: [...group.memberIds, userId],
        memberNames: {...group.memberNames, userId: userName},
        createdById: group.createdById,
        createdAt: group.createdAt,
      );
      currentGroups[groupIndex] = updatedGroup;
      state = AsyncValue.data(currentGroups);
    }
  }

  List<Group> getUserGroups(String userId) {
    return state.value?.where((group) => group.memberIds.contains(userId)).toList() ?? [];
  }

  bool checkMembership(String groupId, String userId) {
    return state.value?.any((group) => group.id == groupId && group.memberIds.contains(userId)) ?? false;
  }
} 