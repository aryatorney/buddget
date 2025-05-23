import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final List<String> groupIds;

  @HiveField(5)
  final Map<String, double> totalBalances; // groupId -> balance

  @HiveField(6)
  final bool isDarkMode;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.groupIds,
    required this.totalBalances,
    this.photoUrl,
    this.isDarkMode = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    List<String>? groupIds,
    Map<String, double>? totalBalances,
    bool? isDarkMode,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      groupIds: groupIds ?? this.groupIds,
      totalBalances: totalBalances ?? this.totalBalances,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
} 