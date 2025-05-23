import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddget/features/expense/data/repositories/expense_repository.dart';
import 'package:buddget/features/expense/domain/models/expense.dart';

final expenseViewModelProvider = StateNotifierProvider<ExpenseViewModel, AsyncValue<List<Expense>>>((ref) {
  return ExpenseViewModel(ExpenseRepository());
});

class ExpenseViewModel extends StateNotifier<AsyncValue<List<Expense>>> {
  final ExpenseRepository _repository;

  ExpenseViewModel(this._repository) : super(const AsyncValue.loading()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      state = const AsyncValue.loading();
      final expenses = await _repository.getAll();
      state = AsyncValue.data(expenses);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _repository.save(expense);
      await loadExpenses();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _repository.delete(id);
      await loadExpenses();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<List<Expense>> getGroupExpenses(String groupId) async {
    try {
      return await _repository.getExpensesByGroup(groupId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<double> getGroupTotal(String groupId) async {
    try {
      return await _repository.getTotalExpensesByGroup(groupId);
    } catch (e) {
      return 0.0;
    }
  }
} 