class AttachmentModel{
  final String id;
  final int user_id;
  final String? title;
  final String mime;
  final String path;
  final String type;
  final String? description;
  final String? options;
  final String? created_at;
  final String? updated_at;

  AttachmentModel({
    required this.id,
    required this.user_id,
    this.title,
    required this.mime,
    required this.path,
    required this.type,
    this.description,
    this.options,
    this.created_at,
    this.updated_at,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String,
      user_id: json['user_id'] as int,
      title: json['title'] as String?,
      mime: json['mime'] as String,
      path: json['path'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      options: json['options'] as String?,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String).toIso8601String() : null,
      updated_at: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String).toIso8601String() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'title': title,
      'mime': mime,
      'path': path,
      'type': type,
      'description': description,
      'options': options,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  AttachmentModel copyWith({
    String? id,
    int? user_id,
    String? title,
    String? mime,
    String? path,
    String? type,
    String? description,
    String? options,
    String? created_at,
    String? updated_at,
  }) {
    return AttachmentModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      title: title ?? this.title,
      mime: mime ?? this.mime,
      path: path ?? this.path,
      type: type ?? this.type,
      description: description ?? this.description,
      options: options ?? this.options,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}