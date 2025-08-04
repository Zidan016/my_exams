class Participantsectionitems {
  final String id;
  final String sectionId;
  final String? itemId;
  final String? config;
  final String type;
  final String label;
  final String content;
  final String? subContent;
  final int remainingTime;
  final int order;
  final String? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isEncrypted;
  final String? encryptionId;

  const Participantsectionitems({
    required this.id,
    required this.sectionId,
    this.itemId,
    this.config,
    required this.type,
    required this.label,
    required this.content,
    this.subContent,
    required this.remainingTime,
    required this.order,
    this.tags,
    this.createdAt,
    this.updatedAt,
    required this.isEncrypted,
    this.encryptionId,
  });

  factory Participantsectionitems.fromJson(Map<String, dynamic> json) {
    return Participantsectionitems(
      id: json['id'] as String,
      sectionId: json['section_id'] as String,
      itemId: json['item_id'] as String?,
      config: json['config'] as String?,
      type: json['type'] as String,
      label: json['label'] as String,
      content: json['content'] as String,
      subContent: json['sub_content'] as String?,
      remainingTime: json['remaining_time'] as int,
      order: json['order'] as int,
      tags: json['tags'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isEncrypted: json['is_encrypted'] as int,
      encryptionId: json['encryption_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section_id': sectionId,
      'item_id': itemId,
      'config': config,
      'type': type,
      'label': label,
      'content': content,
      'sub_content': subContent,
      'remaining_time': remainingTime,
      'order': order,
      'tags': tags,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_encrypted': isEncrypted,
      'encryption_id': encryptionId,
    };
  }

  Participantsectionitems copyWith({
    String? id,
    String? sectionId,
    String? itemId,
    String? config,
    String? type,
    String? label,
    String? content,
    String? subContent,
    int? remainingTime,
    int? order,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isEncrypted,
    String? encryptionId,
  }) {
    return Participantsectionitems(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      itemId: itemId ?? this.itemId,
      config: config ?? this.config,
      type: type ?? this.type,
      label: label ?? this.label,
      content: content ?? this.content,
      subContent: subContent ?? this.subContent,
      remainingTime: remainingTime ?? this.remainingTime,
      order: order ?? this.order,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionId: encryptionId ?? this.encryptionId,
    );
  }
}