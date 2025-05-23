import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/auth/domain/models/user.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  // For now, we'll just return a stream that emits null
  return Stream.value(null);
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
}); 