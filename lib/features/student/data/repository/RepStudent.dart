import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/core/service/SocketService.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/student/data/models/participantLogs.dart';
import 'package:my_exams/features/student/data/models/participantSection.dart';
import 'package:my_exams/features/student/data/models/participantSectionItemAttempts.dart';
import 'package:my_exams/features/student/data/models/sectionItemAnswers.dart';

class Repstudent {
  final socket = Get.find<SocketService>();
  final api = Get.find<ApiService>();
  LocalService pref = LocalService();

  Future upComingExam()async{
    var id = await pref.getId();
    final respone = await api.format({
      'user_id': id,
      'status' : 'up'
    }, 'do-exams/get-exam');
    print(id);
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<MExams> data = decodedData
        .map((item) => MExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future packageById(String id) async {
    final respone = await api.format({'id': id}, 'package/byId');
    if (respone != null && respone.isNotEmpty) {
      var decoded = jsonDecode(respone);
      if (decoded is Map<String, dynamic>) {
        PackageModel model = PackageModel.fromJson(decoded);
        return model;
      } else if (decoded is List && decoded.isNotEmpty) {
        // If API returns a list, take the first item
        PackageModel model = PackageModel.fromJson(decoded[0] as Map<String, dynamic>);
        return model;
      }
    }
    return null;
  }

  Future nowComingExam()async{
    var id = await pref.getId();
    final respone = await api.format({
      'user_id': id,
      'status' : 'now'
    }, 'do-exams/get-exam');
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<MExams> data = decodedData
        .map((item) => MExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future endComingExam()async{
    var id = await pref.getId();
    final respone = await api.format({
      'user_id': id,
      'status' : 'end'
    }, 'do-exams/get-exam');
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<MExams> data = decodedData
        .map((item) => MExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future updatedScore(String id, int score)async{
    final respone = await api.format({"id": id, "score": score}, 'participant-section/updated-score');
    return respone != null ? true : false;
  }

  Future fixScore(ParticipantSection models)async{
    final respone = await api.format({"section": models.toJson()}, 'do-exams/fix-score');
    return respone != null ? true : false;
  }

  Future getItemAnswer(sectionId)async{
    final respone = await api.format(
      {
        'section_id': sectionId
      }, 'do-exams/get-items-answer');
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<Sectionitemanswers> data = decodedData.map((item)=> Sectionitemanswers.fromJson(item as Map<String, dynamic>)).toList();
    return data;
  }

  Future getSection(String examId)async{
    var id = await pref.getId();
    final respone = await api.format({
      'exam_id' : examId,
      'user_id': id
    }, 'do-exams/get-section');
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<ParticipantSection> data = decodedData.map((item)=> ParticipantSection.fromJson(item as Map<String, dynamic>)).toList();
    return data;
  }

  Future getSectionPreview(String examId, int id)async{
    final respone = await api.format({
      'exam_id' : examId,
      'user_id': id
    }, 'do-exams/get-section');
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<ParticipantSection> data = decodedData.map((item)=> ParticipantSection.fromJson(item as Map<String, dynamic>)).toList();
    return data;
  }

  Future doExams(itemId, ParticipantSectionItemAttempts attempt, ParticipantSection section)async{
    final respone = await api.format(
      {
        'item_id' : itemId,
        'attempt' : attempt.toJson(),
        'prtSection' : section.toJson()
      }, 'do-exams/do-exams');
    return respone != null ? true : false;
  }

  Future logs(ParticipantLogs logs, String examId, int start, int end)async{
    final respone = await api.format(
      {
        'logs':  logs.toJson(),
        'examId': examId,
        "is_end": start,
        "isis_start": end
      }, 'do-exams/logs');
    return respone != null ? true : false;
  }

  Future endSection(ParticipantSection section)async{
    final respone = await api.format(
      {
        'section':  section.toJson()
      }, 'do-exams/end-section');
    return respone != null ? true : false;
  }

  Future listeningSection(String prtId)async{
    final respone = await api.format({
      'participant_id': prtId
    }, 'do-exams/listening-section');
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<ParticipantSection> data = decodedData.map((it)=> ParticipantSection.fromJson(it as Map<String, dynamic>)).toList();
    return data;
  }

  Future getListeningSection(Function(List<ParticipantSection>)onData, String prtId)async{
    socket.on('section-${prtId}', (data){
      List<ParticipantSection> respone = (data as List).map((it) => ParticipantSection.fromJson(it as Map<String, dynamic>)).toList();
      onData(respone);
    });
  }

  onDisconnect(){
    socket.disconnected();
  }
}