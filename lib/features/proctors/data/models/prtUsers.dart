import 'package:my_exams/features/participants/data/models/MParticipants.dart';
import 'package:my_exams/features/student/data/models/participantLogs.dart';
import 'package:my_exams/features/users/data/models/MUsers.dart';

class MParticipantUserLogs{
  final MUsers user;
  final Mparticipants participant;
  final ParticipantLogs? logs;

  MParticipantUserLogs({
    required this.user,
    required this.participant,
    this.logs,
  });

  factory MParticipantUserLogs.fromJson(Map<String, dynamic> json) {
    return MParticipantUserLogs(
      user: MUsers.fromJson(json['user']),
      participant: Mparticipants.fromJson(json['prt']),
      logs: json['logs'] != null ? ParticipantLogs.fromJson(json['logs']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'participant': participant.toJson(),
      'logs': logs?.toJson(),
    };
  }
}