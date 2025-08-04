import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/student/data/models/participantItemAnswers.dart';
import 'package:my_exams/features/student/data/models/participantSectionItemAttempts.dart';
import 'package:my_exams/features/student/data/models/participantSectionItems.dart';

class Sectionitemanswers {
  final Participantsectionitems particiapantSectionItems;
  final List<ParticipantItemAnswers> participantItemAnswers;
  final ParticipantSectionItemAttempts? participantSectionItemAttempts;
  final List<AttachmentModel> attachment;

  const Sectionitemanswers({
    required this.particiapantSectionItems,
    required this.participantItemAnswers,
    required this.participantSectionItemAttempts,
    required this.attachment,
  });
  factory Sectionitemanswers.fromJson(Map<String, dynamic> map) {
    return Sectionitemanswers(
      particiapantSectionItems: Participantsectionitems.fromJson(map['items']),
      participantItemAnswers: (map['answer'] as List<dynamic>)
          .map((item) => ParticipantItemAnswers.fromJson(item))
          .toList(),
      participantSectionItemAttempts: (map['attempts'] != null && map['attempts'].isNotEmpty)
          ? ParticipantSectionItemAttempts.fromJson(map['attempts'][0])
          : null,
      attachment: (map['attachment'] != null && map['attachment'].isNotEmpty)
          ? (map['attachment'] as List<dynamic>)
              .map((item) => AttachmentModel.fromJson(item))
              .toList()
          : [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'items': particiapantSectionItems.toJson(),
      'answer': participantItemAnswers.map((item) => item.toJson()).toList(),
      'attempts': participantSectionItemAttempts?.toJson(),
      'attachment': attachment.map((att)=> att.toJson()).toList(),
    };
  }

  Sectionitemanswers copyWith({
    Participantsectionitems? particiapantSectionItems,
    List<ParticipantItemAnswers>? participantItemAnswers,
    ParticipantSectionItemAttempts? participantSectionItemAttempts,
    List<AttachmentModel>? attachment,
  }) {
    return Sectionitemanswers(
      particiapantSectionItems: particiapantSectionItems ?? this.particiapantSectionItems,
      participantItemAnswers: participantItemAnswers ?? this.participantItemAnswers,
      participantSectionItemAttempts: participantSectionItemAttempts ?? this.participantSectionItemAttempts,
      attachment: attachment ?? this.attachment,
    );
  }
}