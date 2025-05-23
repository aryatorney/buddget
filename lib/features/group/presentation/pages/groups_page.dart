import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/group/presentation/viewmodels/group_view_model.dart';
import 'package:buddget/features/auth/presentation/viewmodels/user_view_model.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Group Name',
            hintText: 'Enter group name',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                ref.read(groupViewModelProvider.notifier).createGroup(
                  nameController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(groupViewModelProvider);
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: userState.value != null
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showCreateGroupDialog(context, ref),
                ),
              ]
            : null,
      ),
      body: groupsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No groups yet.'),
                  if (userState.value != null) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showCreateGroupDialog(context, ref),
                      child: const Text('Create a Group'),
                    ),
                  ],
                ],
              ),
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