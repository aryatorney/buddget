import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/auth/data/repositories/auth_repository.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<User?>>((ref) {
  return AuthViewModel(ref);
});

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final Ref ref;

  AuthViewModel(this.ref) : super(const AsyncValue.data(null)) {
    state = AsyncValue.data(ref.read(authRepositoryProvider).currentUser);
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmail(email, password);
      return ref.read(authRepositoryProvider).currentUser;
    });
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUpWithEmail(email, password);
      return ref.read(authRepositoryProvider).currentUser;
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      return null;
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      return ref.read(authRepositoryProvider).currentUser;
    });
  }
} 