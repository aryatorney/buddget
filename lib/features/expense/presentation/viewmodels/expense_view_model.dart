import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/expense/domain/models/expense.dart';

// Mock expense data
final mockExpenses = <Expense>[
  Expense(
    id: 'exp1',
    groupId: 'group1',
    description: 'Dinner',
    amount: 120.0,
    paidById: 'mock_user_id',
    category: 'food',
    date: DateTime.now().subtract(const Duration(days: 2)),
    splitAmounts: {
      'mock_user_id': 40.0,
      'user2': 40.0,
      'user3': 40.0,
    },
  ),
  Expense(
    id: 'exp2',
    groupId: 'group1',
    description: 'Taxi',
    amount: 45.0,
    paidById: 'user2',
    category: 'transport',
    date: DateTime.now().subtract(const Duration(days: 1)),
    splitAmounts: {
      'mock_user_id': 22.5,
      'user2': 22.5,
    },
  ),
  Expense(
    id: 'exp3',
    groupId: 'group2',
    description: 'Utilities',
    amount: 200.0,
    paidById: 'mock_user_id',
    category: 'utilities',
    date: DateTime.now(),
    splitAmounts: {
      'mock_user_id': 100.0,
      'user4': 100.0,
    },
  ),
];

final expenseViewModelProvider = StateNotifierProvider<ExpenseViewModel, AsyncValue<List<Expense>>>((ref) {
  return ExpenseViewModel();
});

class ExpenseViewModel extends StateNotifier<AsyncValue<List<Expense>>> {
  ExpenseViewModel() : super(const AsyncValue.data([])) {
    loadExpenses();
  }

  void loadExpenses() {
    state = AsyncValue.data(List<Expense>.from(mockExpenses));
  }

  void addExpense(Expense expense) {
    final currentExpenses = List<Expense>.from(state.value ?? []);
    currentExpenses.add(expense);
    state = AsyncValue.data(currentExpenses);
  }

  void deleteExpense(String id) {
    final currentExpenses = List<Expense>.from(state.value ?? []);
    currentExpenses.removeWhere((expense) => expense.id == id);
    state = AsyncValue.data(currentExpenses);
  }

  List<Expense> getGroupExpenses(String groupId) {
    return state.value?.where((expense) => expense.groupId == groupId).toList() ?? [];
  }

  double getGroupTotal(String groupId) {
    final expenses = state.value?.where((expense) => expense.groupId == groupId).toList() ?? [];
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
} 