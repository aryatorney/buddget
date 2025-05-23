import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/group/presentation/viewmodels/group_view_model.dart';
import 'package:buddget/features/auth/presentation/viewmodels/user_view_model.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(groupViewModelProvider);
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Show create group dialog
            },
          ),
        ],
      ),
      body: groupsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (groups) {
          if (groups.isEmpty) {
            return const Center(
              child: Text('No groups yet. Create one to get started!'),
            );
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(group.name),
                  subtitle: Text('${group.memberIds.length} members'),
                  trailing: userState.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (user) => Text(
                      user?.totalBalances[group.id]?.toStringAsFixed(2) ?? '0.00',
                      style: TextStyle(
                        color: (user?.totalBalances[group.id] ?? 0) >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to group details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 