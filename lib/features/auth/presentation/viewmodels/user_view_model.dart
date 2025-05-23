import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/auth/domain/models/user.dart';

// Mock user data
final mockUser = User(
  id: 'mock_user_id',
  name: 'John Doe',
  email: 'john@example.com',
  photoUrl: null,
  isDarkMode: false,
  groupIds: ['group1', 'group2'],
  totalBalances: {
    'group1': 150.0,
    'group2': -75.0,
  },
);

final userViewModelProvider = StateNotifierProvider<UserViewModel, AsyncValue<User?>>((ref) {
  return UserViewModel();
});

class UserViewModel extends StateNotifier<AsyncValue<User?>> {
  UserViewModel() : super(const AsyncValue.data(null));

  void signIn() {
    state = AsyncValue.data(mockUser);
  }

  void signOut() {
    state = const AsyncValue.data(null);
  }

  void toggleDarkMode() {
    if (state.value != null) {
      final updatedUser = User(
        id: state.value!.id,
        name: state.value!.name,
        email: state.value!.email,
        photoUrl: state.value!.photoUrl,
        isDarkMode: !state.value!.isDarkMode,
        groupIds: state.value!.groupIds,
        totalBalances: state.value!.totalBalances,
      );
      state = AsyncValue.data(updatedUser);
    }
  }

  double getGroupBalance(String groupId) {
    return state.value?.totalBalances[groupId] ?? 0.0;
  }
} 