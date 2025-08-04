import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/participants/data/models/MParticipants.dart';

class MExamsParticipants {
  final List<MExams> exams;
  final List<Mparticipants> participant;

  const MExamsParticipants({
    required this.exams,
    required this.participant,
  });

  factory MExamsParticipants.fromJson(Map<String, dynamic> json) {
    return MExamsParticipants(
      exams: (json['exams'] as List<dynamic>)
          .map((e) => MExams.fromJson(e as Map<String, dynamic>))
          .toList(),
      participant: (json['participants'] as List<dynamic>)
          .map((e) => Mparticipants.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exams': exams.map((e) => e.toJson()).toList(),
      'participants': participant.map((e) => e.toJson()).toList(),
    };
  }
}