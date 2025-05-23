import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:buddget/features/auth/data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<User?> authState(StreamProviderRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@riverpod
User? currentUser(ProviderRef ref) {
  return ref.watch(authRepositoryProvider).currentUser;
} 