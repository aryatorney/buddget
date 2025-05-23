import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:buddget/features/expense/domain/models/expense.dart';
import 'package:buddget/features/group/domain/models/group.dart';
import 'package:buddget/features/auth/domain/models/user.dart';
import 'package:buddget/shared/theme/app_theme.dart';
import 'package:buddget/features/home/presentation/pages/home_page.dart';
import 'package:buddget/features/group/data/repositories/group_repository.dart';
import 'package:buddget/features/expense/data/repositories/expense_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
  final groupRepo = GroupRepository();
  final expenseRepo = ExpenseRepository();
  
  await Future.wait([
    groupRepo.init(),
    expenseRepo.init(),
  ]);
  
  runApp(const ProviderScope(child: BuddgetApp()));
}

class BuddgetApp extends StatelessWidget {
  const BuddgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buddget',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
