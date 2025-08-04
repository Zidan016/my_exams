import 'package:my_exams/core/helper/helper.dart';

class MExams {
  final String id;
  final String? packageId;
  final String name;
  final DateTime? scheduledAt;
  final DateTime? endedAt;
  final DateTime? startedAt;
  final int duration;
  final int isAnytime;
  final int isMultiAttempt;
  final int automaticStart;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? isToefl;

  const MExams({
    this.startedAt, 
    required this.duration, 
    required this.isAnytime, 
    required this.isMultiAttempt, 
    required this.automaticStart, 
    this.createdAt, 
    this.updatedAt, 
    required this.name, 
    this.scheduledAt, 
    this.endedAt,
    required this.id,
    this.packageId,
    this.isToefl
  });

  factory MExams.fromJson(Map<String, dynamic> json){
    return MExams(
      id: json['id'],
      packageId: json['package_id'],
      name: json['name'],
      scheduledAt: json['scheduled_at'] != null ? DateTime.parse(json['scheduled_at']) :null,
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at']) :null,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) :null,      
      duration: json['duration'],
      isAnytime: json['is_anytime'],
      isMultiAttempt: json['is_multi_attempt'],
      automaticStart: json['automatic_start'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) :null,
      isToefl: json['is_toefl']
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'package_id': packageId,
    'name': name,
    'scheduled_at': scheduledAt != null ? Helper.toMySQLDateTime(scheduledAt!) : null,
    'ended_at': endedAt != null ? Helper.toMySQLDateTime(endedAt!) : null,
    'started_at': startedAt != null ? Helper.toMySQLDateTime(startedAt!) : null,
    'duration': duration,
    'is_anytime': isAnytime,
    'is_multi_attempt': isMultiAttempt,
    'automatic_start': automaticStart,
    'created_at': createdAt != null ? Helper.toMySQLDateTime(createdAt!) : null,
    'updated_at': updatedAt != null ? Helper.toMySQLDateTime(updatedAt!) : null,
    'is_toefl': isToefl
  };
}


  MExams copyWith({
    String? id,
    String? packageId,
    String? name,
    DateTime? scheduledAt,
    DateTime? endedAt,
    DateTime? startedAt,
    int? duration,
    int? isAnytime,
    int? isMultiAttempt,
    int? automaticStart,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isToefl
  }) {
    return MExams(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      name: name ?? this.name,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      endedAt: endedAt ?? this.endedAt,
      startedAt: startedAt ?? this.startedAt,
      duration: duration ?? this.duration,
      isAnytime: isAnytime ?? this.isAnytime,
      isMultiAttempt: isMultiAttempt ?? this.isMultiAttempt,
      automaticStart: automaticStart ?? this.automaticStart,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isToefl: isToefl ?? this.isToefl
    );
  }
}