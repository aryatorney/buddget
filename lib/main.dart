import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:buddget/firebase_options.dart';
import 'package:buddget/features/auth/domain/models/user.dart';
import 'package:buddget/features/expense/domain/models/expense.dart';
import 'package:buddget/features/group/domain/models/group.dart';
import 'package:buddget/shared/theme/app_theme.dart';
import 'package:buddget/features/home/presentation/pages/home_page.dart';
import 'package:buddget/features/auth/data/repositories/user_repository.dart';
import 'package:buddget/features/group/data/repositories/group_repository.dart';
import 'package:buddget/features/expense/data/repositories/expense_repository.dart';
import 'package:buddget/features/auth/presentation/pages/sign_in_page.dart';
import 'package:buddget/features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ExpenseAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(GroupAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(UserAdapter());
  }
  
  // Initialize repositories
  final userRepo = UserRepository();
  final groupRepo = GroupRepository();
  final expenseRepo = ExpenseRepository();
  
  await Future.wait([
    userRepo.init(),
    groupRepo.init(),
    expenseRepo.init(),
  ]);
  
  runApp(const ProviderScope(child: BuddgetApp()));
}

class BuddgetApp extends ConsumerWidget {
  const BuddgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
      title: 'Buddget',
      theme: AppTheme.lightTheme,
      home: authState.when(
        data: (user) => user != null ? const HomePage() : const SignInPage(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
