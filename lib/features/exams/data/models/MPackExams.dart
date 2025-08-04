import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
class MPackExams {
  final PackageModel? packageModel;
  final MExams examsModel;

  const MPackExams({
    this.packageModel,
    required this.examsModel,
  });

  factory MPackExams.fromJson(Map<String, dynamic> json) {
    return MPackExams(
      examsModel: MExams.fromJson(json['exams']),
      packageModel: json['package'] != null ? PackageModel.fromJson(json['package']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exams': examsModel.toJson(),
      'package': packageModel?.toJson(),
    };
  }
}