class MUsers {
  final int id;
  final String name;
  final String? altId;
  final String username;
  final String email;
  final DateTime? emailVerifiedAt;
  final String password;
  final String? twoFactorSecret;
  final String? twoFactorRecoveryCodes;
  final String? rememberToken; 
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt; 

  const MUsers({
    required this.id,
    required this.name,
    this.altId,
    required this.username,
    required this.email,
    this.emailVerifiedAt,
    required this.password,
    this.twoFactorSecret,
    this.twoFactorRecoveryCodes,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory MUsers.fromJson(Map<String, dynamic> json) {
    return MUsers(
      id: json['id'],
      name: json['name'],
      altId: json['alt_id'] as String?,
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      emailVerifiedAt: json['email_verified_at'] != null ? DateTime.tryParse(json['email_verified_at']) : null,
      password: json['password'] ?? "",
      twoFactorSecret: json['two_factor_secret'] as String?,
      twoFactorRecoveryCodes: json['two_factor_recovery_codes'] as String?,
      rememberToken: json['remember_token'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alt_id': altId,
      'username': username,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'password': password,
      'two_factor_secret': twoFactorSecret,
      'two_factor_recovery_codes': twoFactorRecoveryCodes,
      'remember_token': rememberToken,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

}
