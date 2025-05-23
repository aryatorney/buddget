import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/auth/data/repositories/user_repository.dart';
import 'package:buddget/features/auth/domain/models/user.dart';

final userViewModelProvider = StateNotifierProvider<UserViewModel, AsyncValue<User?>>((ref) {
  return UserViewModel(UserRepository());
});

class UserViewModel extends StateNotifier<AsyncValue<User?>> {
  final UserRepository _repository;

  UserViewModel(this._repository) : super(const AsyncValue.loading()) {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    try {
      state = const AsyncValue.loading();
      // In a real app, you'd get the current user's ID from auth service
      final user = await _repository.get('current_user_id');
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateUserBalance(String groupId, double amount) async {
    try {
      if (state.value == null) return;
      await _repository.updateBalance(state.value!.id, groupId, amount);
      await loadCurrentUser();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      if (state.value == null) return;
      await _repository.addToGroup(state.value!.id, groupId);
      await loadCurrentUser();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleDarkMode() async {
    try {
      if (state.value == null) return;
      final newValue = !state.value!.isDarkMode;
      await _repository.updateDarkMode(state.value!.id, newValue);
      await loadCurrentUser();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  double getGroupBalance(String groupId) {
    return state.value?.totalBalances[groupId] ?? 0.0;
  }
} 