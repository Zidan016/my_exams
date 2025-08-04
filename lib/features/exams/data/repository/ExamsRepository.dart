import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/exams/data/models/MPackExams.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/participants/data/models/MUsersParti.dart';
import 'package:my_exams/features/users/data/models/MUsers.dart';
import 'package:my_exams/core/service/ApiService.dart';

class Examsrepository {
  ApiService api = Get.find<ApiService>();

  Future upComing()async{
    final response = await api.format(
      {},
      'exams/up-coming',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<MPackExams> data = decodedData
        .map((item) => MPackExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future UpcomingExam()async{
    final response = await api.format(
      {},
      'exams/draft',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<MPackExams> data = decodedData
        .map((item) => MPackExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future nowExam()async{
    final response = await api.format(
      {},
      'exams/now',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<MPackExams> data = decodedData
        .map((item) => MPackExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future endExam()async{
    final response = await api.format(
      {},
      'exams/end',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<MPackExams> data = decodedData
        .map((item) => MPackExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future draftExam()async{
    final response = await api.format(
      {},
      'exams/draft',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<MPackExams> data = decodedData
        .map((item) => MPackExams.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future searchPackage()async{
    final respone = await api.format({}, 'package/search-package');
    List<dynamic> decodedData = jsonDecode(respone);
    List<PackageModel> data = decodedData.map((item)=> PackageModel.fromJson(item as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }

  Future searchUsers()async{
    final respone = await api.format({}, 'package/search-participant');
    List<dynamic> decodedData = jsonDecode(respone);
    List<MUsers> data = decodedData.map((item)=> MUsers.fromJson(item as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }

  Future add(MExams exams)async{
    final respone = await api.format({
      "exams": exams.toJson()
    }, 'exams/add');
    return respone != null ? true : false;
  }

  Future update(MExams exams)async{
    final respone = await api.format({
      "exams": exams.toJson()
    }, 'exams/update');
    return respone != null ? true : false;
  }

  Future del(id)async{
    final respone = await api.format({
      "id": id
    }, 'exams/delete');
    return respone != null ? true : false;
  }

  Future startExams(examId)async{
    final respone = await api.format({
      "exam_id": examId
    }, 'exams/start-exam');
    return respone != null ? true : false;
  }

  Future publishExam(examId)async{
    final respone = await api.format({
      "exam_id": examId
    }, 'exams/publish-exam');
    return respone != null ? true : false;
  }

  Future getParticipant(String examId)async{
    final respone = await api.format({"examId" : examId}, 'participant/get');
    List<dynamic> decoded = jsonDecode(respone);
    List<Musersparti> data = decoded.map((item)=> Musersparti.fromJson(item as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }
}