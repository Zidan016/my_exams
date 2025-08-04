class ParticipantSection {
  final String id;
  final String? config;
  final String participantId;
  final DateTime? lastAttemptedAt;
  final DateTime? endedAt;
  final int itemDuration;
  final int remainingTime;
  final int attempts;
  final int score;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ParticipantSection({
    required this.id,
    this.config,
    required this.participantId,
    this.lastAttemptedAt,
    this.endedAt,
    required this.itemDuration,
    required this.remainingTime,
    required this.attempts,
    required this.score,
    this.createdAt,
    this.updatedAt,
  });

  factory ParticipantSection.fromJson(Map<String, dynamic> json) {
    return ParticipantSection(
      id: json['id'] as String,
      config: json['config'] as String?,
      participantId: json['participant_id'] as String,
      lastAttemptedAt: json['last_attempted_at'] != null
          ? DateTime.parse(json['last_attempted_at'] as String)
          : null,
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      itemDuration: json['item_duration'] as int,
      remainingTime: json['remaining_time'] as int,
      attempts: json['attempts'] as int,
      score: json['score'] as int,
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
      'config': config,
      'participant_id': participantId,
      'last_attempted_at': lastAttemptedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'item_duration': itemDuration,
      'remaining_time': remainingTime,
      'attempts': attempts,
      'score': score,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ParticipantSection copyWith({
    String? id,
    String? config,
    String? participantId,
    DateTime? lastAttemptedAt,
    DateTime? endedAt,
    int? itemDuration,
    int? remainingTime,
    int? attempts,
    int? score,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParticipantSection(
      id: id ?? this.id,
      config: config ?? this.config,
      participantId: participantId ?? this.participantId,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      endedAt: endedAt ?? this.endedAt,
      itemDuration: itemDuration ?? this.itemDuration,
      remainingTime: remainingTime ?? this.remainingTime,
      attempts: attempts ?? this.attempts,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}