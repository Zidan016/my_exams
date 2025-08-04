import 'package:my_exams/features/users/data/models/MRoles.dart';
import 'package:my_exams/features/users/data/models/MUsers.dart';

class MUsersRoles {
  final MUsers users;
  final List<MRoles> roles;

  const MUsersRoles({
    required this.users,
    required this.roles,
  });

  factory MUsersRoles.fromJson(Map<String, dynamic> json) {
    return MUsersRoles(
      users: MUsers.fromJson(json['users'] as Map<String, dynamic>),
      roles: (json['role'] as List<dynamic>)
          .map((role) => MRoles.fromJson(role as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.toJson(),
      'role': roles.map((role) => role.toJson()).toList(),
    };
  }
}
