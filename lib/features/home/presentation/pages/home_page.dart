import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/group/presentation/pages/groups_page.dart';
import 'package:buddget/features/expense/presentation/pages/expenses_page.dart';
import 'package:buddget/features/profile/presentation/pages/profile_page.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);

    final pages = [
      const GroupsPage(),
      const ExpensesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,
        onDestinationSelected: (index) {
          ref.read(currentPageProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: currentPage == 1
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Show add expense dialog
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
} 