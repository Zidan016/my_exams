import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_exams/features/participants/data/models/MParticipants.dart';
import 'package:my_exams/features/users/data/models/MUsers.dart';
import 'package:my_exams/features/participants/data/models/MUsersParti.dart';
import 'package:my_exams/core/service/ApiService.dart';

class Participantrepo {
  final api = Get.find<ApiService>();

  Future getParticipant(String examId)async{
    final respone = await api.format({"examId" : examId}, 'participant/get');
    List<dynamic> decoded = jsonDecode(respone);
    List<Musersparti> data = decoded.map((item)=> Musersparti.fromJson(item as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }

  Future addParticipant(List<Mparticipants> model)async{
    final respone = await api.format({"add": model.map((item) => item.toJson()).toList()}, 'participant/add');
    return respone != null ? true : false;
  }

  Future deleteParticipant(id)async{
    final respone = await api.format({"id":id}, 'participant/del');
    return respone != null ? true : false;
  }

  Future searchUsers()async{
    final respone = await api.format({}, 'package/search-participant');
    List<dynamic> decodedData = jsonDecode(respone);
    List<MUsers> data = decodedData.map((item)=> MUsers.fromJson(item as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }
}