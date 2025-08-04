class ParticipantSectionItemAttempts {
  final String id;
  final String participantSectionItemId;
  final int attemptNumber;
  final String? answer;
  final int score;
  final int isCorrect;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ParticipantSectionItemAttempts({
    required this.id,
    required this.participantSectionItemId,
    required this.attemptNumber,
    this.answer,
    required this.score,
    required this.isCorrect,
    this.createdAt,
    this.updatedAt,
  });

  factory ParticipantSectionItemAttempts.fromJson(Map<String, dynamic> json) {
    return ParticipantSectionItemAttempts(
      id: json['id'] as String,
      participantSectionItemId: json['participant_section_item_id'] as String,
      attemptNumber: json['attempt_number'] as int,
      answer: json['answer'] as String?,
      score: json['score'] as int,
      isCorrect: json['is_correct'] as int,
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
      'participant_section_item_id': participantSectionItemId,
      'attempt_number': attemptNumber,
      'answer': answer,
      'score': score,
      'is_correct': isCorrect,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ParticipantSectionItemAttempts copyWith({
    String? id,
    String? participantSectionItemId,
    int? attemptNumber,
    String? answer,
    int? score,
    int? isCorrect,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParticipantSectionItemAttempts(
      id: id ?? this.id,
      participantSectionItemId:
          participantSectionItemId ?? this.participantSectionItemId,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      answer: answer ?? this.answer,
      score: score ?? this.score,
      isCorrect: isCorrect ?? this.isCorrect,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}