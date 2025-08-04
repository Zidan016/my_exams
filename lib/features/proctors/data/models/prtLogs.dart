class MParticipantLogs {
  final int id;
  final String participantId;
  final String content;
  final String? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MParticipantLogs({
    required this.id,
    required this.participantId,
    required this.content,
    this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory MParticipantLogs.fromJson(Map<String, dynamic> json) {
    return MParticipantLogs(
      id: json['id'],
      participantId: json['participant_id'] as String,
      content: json['content'] as String,
      tags: json['tags'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant_id': participantId,
      'content': content,
      'tags': tags,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MParticipantLogs copyWith({
    int? id,
    String? participantId,
    String? content,
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MParticipantLogs(
      id: id ?? this.id,
      participantId: participantId ?? this.participantId,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}