import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/auth/presentation/viewmodels/user_view_model.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null
                    ? Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                user.email,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: user.isDarkMode,
                  onChanged: (_) {
                    ref.read(userViewModelProvider.notifier).toggleDarkMode();
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Groups'),
                trailing: Text('${user.groupIds.length}'),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Total Balance'),
                trailing: Text(
                  user.totalBalances.values
                      .fold(0.0, (sum, amount) => sum + amount)
                      .toStringAsFixed(2),
                  style: TextStyle(
                    color: user.totalBalances.values
                                .fold(0.0, (sum, amount) => sum + amount) >=
                            0
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 