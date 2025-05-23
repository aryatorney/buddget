import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> memberIds;

  @HiveField(3)
  final String createdById;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final Map<String, String> memberNames; // userId -> name mapping

  const Group({
    required this.id,
    required this.name,
    required this.memberIds,
    required this.createdById,
    required this.createdAt,
    required this.memberNames,
    this.description,
  });

  Group copyWith({
    String? id,
    String? name,
    List<String>? memberIds,
    String? createdById,
    DateTime? createdAt,
    String? description,
    Map<String, String>? memberNames,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      memberIds: memberIds ?? this.memberIds,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      memberNames: memberNames ?? this.memberNames,
    );
  }
} 