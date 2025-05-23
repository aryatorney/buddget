import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:buddget/features/expense/presentation/viewmodels/expense_view_model.dart';
import 'package:buddget/features/expense/domain/models/expense.dart';
import 'package:buddget/features/auth/presentation/viewmodels/user_view_model.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'food';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter expense description',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
                prefixText: '\$',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: [
                'food',
                'transport',
                'shopping',
                'entertainment',
                'utilities',
                'rent',
                'other',
              ].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.substring(0, 1).toUpperCase() + category.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedCategory = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (descriptionController.text.trim().isNotEmpty &&
                  amountController.text.trim().isNotEmpty) {
                final amount = double.tryParse(amountController.text.trim());
                if (amount != null) {
                  final expense = Expense(
                    id: 'exp${DateTime.now().millisecondsSinceEpoch}',
                    groupId: 'group1', // Default to first group for now
                    description: descriptionController.text.trim(),
                    amount: amount,
                    paidById: 'mock_user_id',
                    category: selectedCategory,
                    date: DateTime.now(),
                    splitAmounts: {
                      'mock_user_id': amount / 2,
                      'user2': amount / 2,
                    },
                  );
                  ref.read(expenseViewModelProvider.notifier).addExpense(expense);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesState = ref.watch(expenseViewModelProvider);
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: expensesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No expenses yet.'),
                  if (userState.value != null) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showAddExpenseDialog(context, ref),
                      child: const Text('Add an Expense'),
                    ),
                  ],
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(_getCategoryIcon(expense.category)),
                  ),
                  title: Text(expense.description),
                  subtitle: Text(
                    DateFormat('MMM d, y').format(expense.date),
                  ),
                  trailing: Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // TODO: Show expense details
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: userState.value != null
          ? FloatingActionButton(
              onPressed: () => _showAddExpenseDialog(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.power;
      case 'rent':
        return Icons.home;
      default:
        return Icons.receipt;
    }
  }
} 