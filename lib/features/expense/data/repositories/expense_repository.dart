import 'package:hive_flutter/hive_flutter.dart';
import 'package:buddget/core/repositories/base_repository.dart';
import 'package:buddget/features/expense/domain/models/expense.dart';

class ExpenseRepository implements BaseRepository<Expense> {
  static const String _boxName = 'expenses';
  late Box<Expense> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Expense>(_boxName);
  }

  @override
  Future<Expense?> get(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<Expense>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(Expense item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  // Custom methods for expense-specific queries
  Future<List<Expense>> getExpensesByGroup(String groupId) async {
    return _box.values.where((expense) => expense.groupId == groupId).toList();
  }

  Future<List<Expense>> getExpensesByUser(String userId) async {
    return _box.values.where((expense) => expense.paidById == userId).toList();
  }

  Future<double> getTotalExpensesByGroup(String groupId) async {
    final expenses = _box.values.where((expense) => expense.groupId == groupId);
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }
} 