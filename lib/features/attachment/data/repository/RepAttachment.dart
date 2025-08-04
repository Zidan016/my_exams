import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/features/attachment/data/models/MAttachment.dart';

class AttachmentRepository{
  ApiService api = Get.find<ApiService>();

  Future getAttachment()async{
    final response = await api.format({}, 'attachment/all');
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<AttachmentModel> data = decodedData
        .map((item) => AttachmentModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future addAttachment(data, File file) async {
    try {
      final response = await api.fileFormat(data, 'attachment/upload', file);
      return response != null ? true : false;
    } catch (e) {
      print('Error uploading file: $e');
      return false;
    }
  }

  Future updateAttachment(AttachmentModel model, File file)async{
    final respone = await api.fileFormat(
      {"data": model.toJson()},
      'attachment/update', file);
    return respone != null ? true : false;
  }

  Future delete(String data)async{
    final respone = await api.format({"id": data}, 'attachment/delete');
    return respone != null ? true : false;
  }

}