import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String paidById;

  @HiveField(6)
  final Map<String, double> splitAmounts;

  @HiveField(7)
  final String? receiptImagePath;

  @HiveField(8)
  final String groupId;

  const Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.paidById,
    required this.splitAmounts,
    required this.groupId,
    this.receiptImagePath,
  });

  Expense copyWith({
    String? id,
    String? description,
    double? amount,
    String? category,
    DateTime? date,
    String? paidById,
    Map<String, double>? splitAmounts,
    String? groupId,
    String? receiptImagePath,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      paidById: paidById ?? this.paidById,
      splitAmounts: splitAmounts ?? this.splitAmounts,
      groupId: groupId ?? this.groupId,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
    );
  }
} 