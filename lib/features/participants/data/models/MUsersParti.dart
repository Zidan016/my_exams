import 'package:my_exams/features/participants/data/models/MParticipants.dart';
import 'package:my_exams/features/users/data/models/MUsers.dart';

class Musersparti {
  final MUsers mUsers;
  final Mparticipants mParticipants;

  Musersparti({required this.mUsers, required this.mParticipants});

  factory Musersparti.fromJson(Map<String, dynamic> json) {
    return Musersparti(
      mUsers: MUsers.fromJson(json['users']),
      mParticipants: Mparticipants.fromJson(json['participant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': mUsers.toJson(),
      'participant': mParticipants.toJson(),
    };
  }
}