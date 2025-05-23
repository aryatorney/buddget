import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:buddget/features/auth/data/repositories/auth_repository.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends AutoDisposeAsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return ref.watch(authRepositoryProvider).currentUser;
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

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
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