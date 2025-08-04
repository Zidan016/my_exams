class ParticipantItemAnswers {
  final String id;
  final String participantSectionItemId;
  final String? content;
  final int correctAnswer;
  final int order;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isEncrypted;
  final String? encryptionId;

  const ParticipantItemAnswers({
    required this.id,
    required this.participantSectionItemId,
    this.content,
    required this.correctAnswer,
    required this.order,
    this.createdAt,
    this.updatedAt,
    required this.isEncrypted,
    this.encryptionId,
  });

  factory ParticipantItemAnswers.fromJson(Map<String, dynamic> json) {
    return ParticipantItemAnswers(
      id: json['id'] as String,
      participantSectionItemId: json['participant_section_item_id'] as String,
      content: json['content'] as String?,
      correctAnswer: json['correct_answer'] as int,
      order: json['order'] as int,
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
      'participant_section_item_id': participantSectionItemId,
      'content': content,
      'correct_answer': correctAnswer,
      'order': order,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_encrypted': isEncrypted,
      'encryption_id': encryptionId,
    };
  }

  ParticipantItemAnswers copyWith({
    String? id,
    String? participantSectionItemId,
    String? content,
    int? correctAnswer,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isEncrypted,
    String? encryptionId,
  }) {
    return ParticipantItemAnswers(
      id: id ?? this.id,
      participantSectionItemId: participantSectionItemId ?? this.participantSectionItemId,
      content: content ?? this.content,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionId: encryptionId ?? this.encryptionId,
    );
  }
}