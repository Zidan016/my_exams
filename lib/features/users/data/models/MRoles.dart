class MRoles {
  final int id;
  final int roleId;
  final int entityId;
  final String entityType;
  final String? restrictedToId;
  final String? restrictedToType;
  final int? scope;

  const MRoles({
    required this.id,
    required this.roleId,
    required this.entityId,
    required this.entityType,
    this.restrictedToId,
    this.restrictedToType,
    this.scope,
  });

  factory MRoles.fromJson(Map<String, dynamic> json) {
    return MRoles(
      id: json['id'] as int,
      roleId: json['role_id'] as int,
      entityId: json['entity_id'] as int,
      entityType: json['entity_type'] as String,
      restrictedToId: json['restricted_to_id'] as String?,
      restrictedToType: json['restricted_to_type'] as String?,
      scope: json['scope'] as int?,
    );
  }

  // Convert an MRoles instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'entity_id': entityId,
      'entity_type': entityType,
      'restricted_to_id': restrictedToId,
      'restricted_to_type': restrictedToType,
      'scope': scope,
    };
  }

  // Create a copy of the current instance with modified fields
  MRoles copyWith({
    int? id,
    int? roleId,
    int? entityId,
    String? entityType,
    String? restrictedToId,
    String? restrictedToType,
    int? scope,
  }) {
    return MRoles(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      restrictedToId: restrictedToId ?? this.restrictedToId,
      restrictedToType: restrictedToType ?? this.restrictedToType,
      scope: scope ?? this.scope,
    );
  }
}