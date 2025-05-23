import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:buddget/features/expense/presentation/viewmodels/expense_view_model.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesState = ref.watch(expenseViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: expensesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(
              child: Text('No expenses yet. Add one to get started!'),
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