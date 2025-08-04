class Mparticipants {
  final String id;
  final int? userId;
  final String examId;
  final String status;

  Mparticipants({
    required this.id,
    this.userId,
    required this.examId,
    required this.status,
  });

  factory Mparticipants.fromJson(Map<String, dynamic> json) {
    return Mparticipants(
      id: json['id'] as String,
      userId: json['user_id'] as int?,
      examId: json['exam_id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'exam_id': examId,
      'status': status,
    };
  }

  Mparticipants copyWith({
    String? id,
    int? userId,
    String? examId,
    String? status,
  }) {
    return Mparticipants(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      examId: examId ?? this.examId,
      status: status ?? this.status,
    );
  }
}