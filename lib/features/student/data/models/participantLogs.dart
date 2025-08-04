
class ParticipantLogs {
  final int id;
  final String partcipantId;
  final String content;
  final String? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ParticipantLogs({
    required this.id,
    required this.partcipantId,
    required this.content,
    this.tags,
    this.createdAt,
    this.updatedAt
  });

  factory ParticipantLogs.fromJson(Map<String, dynamic> json) {
    return ParticipantLogs(
      id: json['id'],
      partcipantId: json['participant_id'],
      content: json['content'],
      tags: json['tags'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant_id': partcipantId,
      'content': content,
      'tags': tags,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

}